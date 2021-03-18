#!/bin/bash
#
# Need to test fslstats and freeview

OUT=/OUTPUTS \
project=TESTPROJ \
subject=TESTSUBJ \
session=TESTSESS \
scan=TESTSCAN \
xvfb-run --server-num=$(($$ + 99)) \
--server-args='-screen 0 1600x1200x24 -ac +extension GLX' \
screenshots.sh


exit 0


# libopenblas.so.0
#fslstats /OUTPUTS/ROIS/roi_ABIDE_PAR_Left.nii.gz -l 0.5 -c

# libvtkDomainsChemistry-7.1.so.1
export FREESURFER_HOME=/usr/local/freesurfer
. ${FREESURFER_HOME}/SetUpFreeSurfer.sh
xvfb-run --server-num=$(($$ + 99)) \
--server-args='-screen 0 1600x1200x24 -ac +extension GLX' \
freeview \
  -v /OUTPUTS/wt1.nii \
  -v /OUTPUTS/SZMAPS_REMOVEGM_MNI/sZ_ABIDE_PAR_Left_wremovegm.nii.gz:colormap=heat:heatscale=90,95,100:percentile=true \
  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport sagittal \
  -ras 0 -18 18 \
  -ss test.png

