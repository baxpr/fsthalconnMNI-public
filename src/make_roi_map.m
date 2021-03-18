function make_roi_map( ...
	out_dir, ...
	t1_nii, ...
	project, ...
	subject, ...
	session, ...
	scan ...
	)

% Load the T1
Vt1 = spm_vol(t1_nii);
Yt1 = spm_read_vols(Vt1);


% Resample all ROIs to T1 space (NN). Load ROI images one at a time and
% combine - priority will be given to those later in the list in the case
% of overlap.
rois = {
	'Yeo7_L_1_vis'
	'Yeo7_L_2_somat'
	'Yeo7_L_3_dattn'
	'Yeo7_L_4_vattn'
	'Yeo7_L_5_limb'
	'Yeo7_L_6_fpar'
	'Yeo7_L_7_def'
	'Lthal'
	'Yeo7_R_1_vis'
	'Yeo7_R_2_somat'
	'Yeo7_R_3_dattn'
	'Yeo7_R_4_vattn'
	'Yeo7_R_5_limb'
	'Yeo7_R_6_fpar'
	'Yeo7_R_7_def'
	'Rthal'
	};
flags = struct('mask',true,'mean',false,'interp',0,'which',1, ...
	'wrap',[0 0 0],'prefix','r');
tmproi_nii = [out_dir '/tmproi.nii'];
rtmproi_nii = [out_dir '/rtmproi.nii'];
Yroi = zeros(size(Yt1));
c = 0;
for r = 1:length(rois)
	copyfile([out_dir '/subject_rois/roi_' rois{r} '.nii'],tmproi_nii)
	spm_reslice_quiet({t1_nii tmproi_nii},flags);
	Ytmproi = spm_read_vols(spm_vol(rtmproi_nii));
	c = c + 1;
	Yroi(Ytmproi(:)>0) = c;
end

% Make transparency channel
Yalpha = zeros(size(Yroi));
Yalpha(Yroi(:)>0) = 1;

% Convert ROI index to RGB color
cmap = hsv(c+1);
Ycolor = repmat(zeros(size(Yroi)),1,1,1,3);
osize = size(Ycolor);
rYcolor = reshape(Ycolor,[],3);
rYroi = Yroi(:);
uroi = unique(rYroi);
for u = 1:length(uroi)
	filler = repmat(cmap(u,:),sum(rYroi==uroi(u)),1);
	rYcolor(rYroi==uroi(u),:) = filler;
end
Ycolor = reshape(rYcolor,osize);

% PDF figures

% Figure out screen size so the figure will fit
ss = get(0,'screensize');
ssw = ss(3);
ssh = ss(4);
ratio = 8.5/11;
if ssw/ssh >= ratio
	dh = ssh;
	dw = ssh * ratio;
else
	dw = ssw;
	dh = ssw / ratio;
end

% Create figure
pdf_figure = openfig('pdf_connmaps_figure.fig','new');
set(pdf_figure,'Tag','pdf_connmaps');
set(pdf_figure,'Units','pixels','Position',[0 0 dw dh]);
figH = guihandles(pdf_figure);

% Summary
set(figH.summary_text, 'String', 'ROI map on native space T1' )

% Scan info
set(figH.scan_info, 'String', sprintf( ...
	'%s, %s, %s, %s', ...
	project, subject, session, scan));
set(figH.date,'String',['Report date: ' date]);
set(figH.version,'String',['Matlab version: ' version]);

% Slices
keepsl = find(sum(sum(Yroi))>0);
Yt1 = Yt1(:,:,keepsl);
Yalpha = Yalpha(:,:,keepsl);
Ycolor = Ycolor(:,:,keepsl,:);
ns = size(Ycolor,3);
ss = round(5 : (ns-10)/9 : ns-5);
for sl = 1:9
	ax = ['slice' num2str(sl)];
	axes(figH.(ax))
	imagesc( ...
		imrotate(Yt1(:,:,ss(sl)),90) ...
		)
	colormap(gray);
	hold on
	image( ...
		imrotate(squeeze(Ycolor(:,:,ss(sl),:)),90), ...
		'AlphaData', ...
		imrotate(Yalpha(:,:,ss(sl)),90) ...
		)
	axis image off
end

% Print to PNG
print(gcf,'-dpng',sprintf('%s/roimap.png',out_dir))
close(pdf_figure)


