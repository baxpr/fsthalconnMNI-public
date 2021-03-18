#!/bin/bash

cd ${OUT}/wkdir

IMG=${OUT}/subject_rois/roi_LHIPP.nii
freeview \
  -v ${T1}:visible=1 \
  -v ${FMRI}:visible=0 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 3 --viewport sagittal \
  -ras `fslstats ${IMG} -l 0.5 -c` \
  -ss roi_t1_LHIPP.png

IMG=${OUT}/subject_rois/roi_Lthal.nii
freeview \
  -v ${T1}:visible=1 \
  -v ${FMRI}:visible=0 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 3 --viewport sagittal \
  -ras `fslstats ${IMG} -l 0.5 -c` \
  -ss roi_t1_Lthal.png

IMG=${OUT}/subject_rois/roi_LHIPP.nii
freeview \
  -v ${T1}:visible=0 \
  -v ${FMRI}:visible=1 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 3 --viewport sagittal \
  -ras `fslstats ${IMG} -l 0.5 -c` \
  -ss roi_fmri_LHIPP.png

IMG=${OUT}/subject_rois/roi_Lthal.nii
freeview \
  -v ${T1}:visible=0 \
  -v ${FMRI}:visible=1 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 3 --viewport sagittal \
  -ras `fslstats ${IMG} -l 0.5 -c` \
  -ss roi_fmri_Lthal.png

montage -mode concatenate \
  roi_t1_LHIPP.png roi_fmri_LHIPP.png roi_t1_Lthal.png roi_fmri_Lthal.png \
  -tile 2x -quality 100 -background black -gravity center \
  -trim -border 10 -bordercolor black rois_fs.png

