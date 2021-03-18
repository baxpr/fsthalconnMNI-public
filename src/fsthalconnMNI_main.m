function fsthalconnMNI_main( ...
	out_dir,subject_dir,roiinfo_csv, ...
	removegm_niigz,keepgm_niigz,wremovegm_niigz,wkeepgm_niigz, ...
	wedge_niigz,wbrainmask_niigz, ...
	wmeanfmri_niigz,meanfmri_niigz,t1_niigz,wt1_niigz,invdef_niigz, ...
	fwhm, ...
	project,subject,session,scan, ...
	magick_path,src_path,fsl_path ...
	)

% Unzip images
[removegm_nii,keepgm_nii,wremovegm_nii,wkeepgm_nii, ...
	wedge_nii,wbrainmask_nii,wmeanfmri_nii,meanfmri_nii,t1_nii,wt1_nii,invdef_nii] = ...
	prep_files( ...
	out_dir, ...
	removegm_niigz,keepgm_niigz,wremovegm_niigz,wkeepgm_niigz, ...
	wedge_niigz,wbrainmask_niigz,wmeanfmri_niigz,meanfmri_niigz,t1_niigz,wt1_niigz,invdef_niigz);

% SPM init
spm_jobman('initcfg');

% Make ROI masks in native space using Freesurfer thalamus
disp('Make ROI mask images   ------------------------------------------------------------')
[roi_dir,rois,urois] = make_roimasks(out_dir,subject_dir,roiinfo_csv,invdef_nii,t1_nii);

% Extract ROI data in native space from unsmoothed fMRI
disp('ROI signals: removegm   -----------------------------------------------------------')
roidata_removegm_csv = extract_roidata(out_dir,roi_dir,rois,urois,removegm_nii,'removegm',fsl_path);
disp('ROI signals: keepgm     -----------------------------------------------------------')
roidata_keepgm_csv = extract_roidata(out_dir,roi_dir,rois,urois,keepgm_nii,'keepgm',fsl_path);

% Compute connectivity matrices and maps (smoothed and unsmoothed) for four
% different preprocessing streams
disp('Connectivity computation: removegm   ----------------------------------------------')
compute_connectivity_matrix(out_dir,roidata_removegm_csv,'removegm');
compute_connectivity_maps(out_dir,roidata_removegm_csv,removegm_nii,fwhm,'removegm');
compute_connectivity_maps(out_dir,roidata_removegm_csv,wremovegm_nii,fwhm,'wremovegm');

disp('Connectivity computation: keepgm     ----------------------------------------------')
compute_connectivity_matrix(out_dir,roidata_keepgm_csv,'keepgm');
compute_connectivity_maps(out_dir,roidata_keepgm_csv,keepgm_nii,fwhm,'keepgm');
compute_connectivity_maps(out_dir,roidata_keepgm_csv,wkeepgm_nii,fwhm,'wkeepgm');

% Mask MNI space connectivity maps (leniently) to reduce disk usage
disp('Mask MNI results   ----------------------------------------------------------------')
mask_mni(out_dir);

% Generate PDF report
disp('Make PDF   ------------------------------------------------------------------------')
make_pdf(out_dir,t1_nii,wmeanfmri_nii,wt1_nii,magick_path,src_path,fsl_path, ...
	project,subject,session,scan);

% Organize and clean up
disp('Organize outputs   ----------------------------------------------------------------')
organize_outputs(out_dir,roiinfo_csv);

