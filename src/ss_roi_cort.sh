#!/bin/bash

cd ${OUT}/wkdir


# Cort
IMG=nMNIrois_Cort.nii
freeview \
  -v ${T1}:visible=1 \
  -v ${FMRI}:visible=0 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport axial \
  -ras `fslstats ${IMG} -l 0.5  -c` \
  -ss roi_t1_Cort.png

IMG=nMNIrois_Cort.nii
freeview \
  -v ${T1}:visible=0 \
  -v ${FMRI}:visible=1 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport axial \
  -ras `fslstats ${IMG} -l 0.5  -c` \
  -ss roi_fmri_Cort.png


# Combine a few freesurfer ROIs into single volume for viewing
fslmaths ${OUT}/subject_rois/roi_LPFC -mul 1 a
fslmaths ${OUT}/subject_rois/roi_LPAR_dmn -mul 2 b
fslmaths ${OUT}/subject_rois/roi_LPAR_ppc -mul 3 c
fslmaths ${OUT}/subject_rois/roi_LSS -mul 4 d
fslmaths ${OUT}/subject_rois/roi_LMTR -mul 5 e
fslmaths a -add b -add c -add d -add e fsrois

freeview \
  -v ${T1}:visible=1 \
  -v ${FMRI}:visible=0 \
  -v fsrois.nii.gz:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport sagittal \
  -ras `fslstats fsrois -l 0.5 -c` \
  -ss roi_t1_fs.png

freeview \
  -v ${T1}:visible=0 \
  -v ${FMRI}:visible=1 \
  -v fsrois.nii.gz:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport sagittal \
  -ras `fslstats fsrois -l 0.5 -c` \
  -ss roi_fmri_fs.png  

# Combine some Yeo
fslmaths ${OUT}/subject_rois/roi_Yeo7_L_1_vis.nii.gz -mul 1 a
fslmaths ${OUT}/subject_rois/roi_Yeo7_L_2_somat.nii.gz -mul 2 b
fslmaths ${OUT}/subject_rois/roi_Yeo7_L_3_dattn.nii.gz -mul 3 c
fslmaths ${OUT}/subject_rois/roi_Yeo7_L_4_vattn.nii.gz -mul 4 d
fslmaths ${OUT}/subject_rois/roi_Yeo7_L_5_limb.nii.gz -mul 5 e
fslmaths ${OUT}/subject_rois/roi_Yeo7_L_6_fpar.nii.gz -mul 6 f
fslmaths ${OUT}/subject_rois/roi_Yeo7_L_7_def.nii.gz -mul 7 g
fslmaths a -add b -add c -add d -add e -add f -add g yeorois

freeview \
  -v ${T1}:visible=1 \
  -v ${FMRI}:visible=0 \
  -v yeorois.nii.gz:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport sagittal \
  -ras `fslstats yeorois -l 0.5 -c` \
  -ss roi_t1_Yeo.png

freeview \
  -v ${T1}:visible=0 \
  -v ${FMRI}:visible=1 \
  -v yeorois.nii.gz:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport sagittal \
  -ras `fslstats yeorois -l 0.5 -c` \
  -ss roi_fmri_Yeo.png  


# Combine PNGs
montage -mode concatenate \
roi_t1_Cort.png roi_fmri_Cort.png roi_t1_Yeo.png roi_fmri_Yeo.png roi_t1_fs.png roi_fmri_fs.png \
-tile 2x -quality 100 -background black -gravity center \
-trim -border 10 -bordercolor black rois_cort.png

