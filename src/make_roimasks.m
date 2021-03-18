function [roi_dir,rois,urois] = make_roimasks(out_dir,subject_dir,...
	roiinfo_csv,invdef_nii,t1_nii)

wkdir = [out_dir '/wkdir'];
if ~exist(wkdir,'dir'), mkdir(wkdir), end

roi_dir = [out_dir '/subject_rois'];
if ~exist(roi_dir,'dir'), mkdir(roi_dir), end

% Load ROI combining information. This file must be in the path
rois = readtable(which(roiinfo_csv),'Format','%s%s%s%s');

% Identify needed ROI files. Convert mgz to nii or unwarp MNI as needed
urois = table(unique(rois.fsfile),'VariableNames',{'mgzroot'});
for u = 1:height(urois)
	
	fprintf('Generating ROI file for %s\n',urois.mgzroot{u});
	
	if strcmp('.mgz',urois.mgzroot{u}(end-3:end))
		% Assume already in native space (from freesurfer)
		urois.mgz{u,1} = [subject_dir '/mri/' urois.mgzroot{u}];
		[~,n] = fileparts(urois.mgzroot{u});
		urois.nii{u,1} = [wkdir '/' n '.nii'];
		cmd = ['bash ' which('mri_convert_run.sh') ' ' urois.mgz{u,1} ' ' urois.nii{u,1}];
		system(cmd);
		
	elseif strcmp('.nii.gz',urois.mgzroot{u}(end-6:end))
		% Assume in MNI space, and unwarp
		copyfile(which(urois.mgzroot{u}),wkdir)
		system(['gunzip ' wkdir '/' urois.mgzroot{u}]);
		
		matlabbatch{1}.spm.util.defs.comp{1}.def = {invdef_nii};
		matlabbatch{1}.spm.util.defs.comp{2}.id.space = {t1_nii};
		matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = ...
			{[wkdir '/' urois.mgzroot{u}(1:end-3)]};
		matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.saveusr = {wkdir};
		matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 0;
		matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 0;
		matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
		matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'n';
		spm_jobman('run',matlabbatch)
		
		urois.nii{u,1} = [wkdir '/n' urois.mgzroot{u}(1:end-3)];
		
	else
		error('Can''t handle ROI file %s',urois.mgzroot{u})
	end
	
end

% Bung the nii filenames back into the ROI table
for r = 1:height(rois)
	rois.nii{r,1} = urois.nii{strcmp(urois.mgzroot,rois.fsfile{r})};
end

% Convert the value strings to numbers in the ROI table
rois.values = cellfun(@str2num,rois.values,'UniformOutput',false);

% Show the ROI table
disp(rois)


%% Create mask image for each desired ROI
fprintf('Creating ROI masks\n')
for r = 1:height(rois)
	
	V = spm_vol(rois.nii{r});
	Y = spm_read_vols(V);
	Yroi = zeros(size(Y));
	Yroi(ismember(Y(:),rois.values{r})) = 1;
	
	Vroi = V;
	Vroi.pinfo(1:2) = [1 0];
	Vroi.fname = [roi_dir '/roi_' rois.region{r} '.nii'];
	spm_write_vol(Vroi,Yroi);
	
end

