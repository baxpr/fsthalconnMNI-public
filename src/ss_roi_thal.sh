#!/bin/bash

cd ${OUT}/wkdir

# Find center of mass of ABIDE ROIs in native space ROI image and show on T1
IMG=nMNIrois_ABIDE.nii
freeview \
  -v ${T1}:visible=1 \
  -v ${FMRI}:visible=0 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 3 --viewport axial \
  -ras `fslstats ${IMG} -l 0.5  -c` \
  -ss roi_t1_ABIDE.png

# DTI
IMG=nMNIrois_DTI.nii
freeview \
  -v ${T1}:visible=1 \
  -v ${FMRI}:visible=0 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 3 --viewport axial \
  -ras `fslstats ${IMG} -l 0.5  -c` \
  -ss roi_t1_DTI.png

# Morel
IMG=nMNIrois_Morel.nii
freeview \
  -v ${T1}:visible=1 \
  -v ${FMRI}:visible=0 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 3 --viewport axial \
  -ras `fslstats ${IMG} -l 0.5  -c` \
  -ss roi_t1_Morel.png

# Repeat for fmri
IMG=nMNIrois_ABIDE.nii
freeview \
  -v ${T1}:visible=0 \
  -v ${FMRI}:visible=1 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 3 --viewport axial \
  -ras `fslstats ${IMG} -l 0.5  -c` \
  -ss roi_fmri_ABIDE.png

IMG=nMNIrois_DTI.nii
freeview \
  -v ${T1}:visible=0 \
  -v ${FMRI}:visible=1 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 3 --viewport axial \
  -ras `fslstats ${IMG} -l 0.5  -c` \
  -ss roi_fmri_DTI.png

IMG=nMNIrois_Morel.nii
freeview \
  -v ${T1}:visible=0 \
  -v ${FMRI}:visible=1 \
  -v ${IMG}:visible=1:colormap=lut \
  -viewsize 400 400 --layout 1 --zoom 3 --viewport axial \
  -ras `fslstats ${IMG} -l 0.5  -c` \
  -ss roi_fmri_Morel.png
  

# Combine PNGs
montage -mode concatenate \
roi_t1_ABIDE.png roi_fmri_ABIDE.png roi_t1_DTI.png roi_fmri_DTI.png roi_t1_Morel.png roi_fmri_Morel.png \
-tile 2x -quality 100 -background black -gravity center \
-trim -border 10 -bordercolor black rois_thal.png
