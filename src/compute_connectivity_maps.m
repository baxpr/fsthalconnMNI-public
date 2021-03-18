function compute_connectivity_maps(out_dir,roidata_csv,fmri_nii,fwhm,filetag)

conn_dir = [out_dir '/connmaps'];
mkdir(conn_dir);

% Load ROI data from make_roimasks_and_extract.m
roidata = readtable(roidata_csv);

% Load fmri
Vfmri = spm_vol(fmri_nii);
Yfmri = spm_read_vols(Vfmri);
osize = size(Yfmri);
rYfmri = reshape(Yfmri,[],osize(4))';

% Compute connectivity maps
R = corr(table2array(roidata),rYfmri);
Z = atanh(R) * sqrt(size(roidata,1)-3);

% Save maps to file, original and smoothed versions
for r = 1:width(roidata)

	Vout = rmfield(Vfmri(1),'pinfo');
	Vout.fname = fullfile(conn_dir, ...
		['Z_' roidata.Properties.VariableNames{r} '_' filetag '.nii']);
	Yout = reshape(Z(r,:),osize(1:3));
	Vout = spm_write_vol(Vout,Yout);
	
	sfname = fullfile(conn_dir, ...
		['sZ_' roidata.Properties.VariableNames{r} '_' filetag '.nii']);
	spm_smooth(Vout,sfname,str2double(fwhm));
	
end

