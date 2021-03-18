#!/bin/bash
#
# Create a bunch of screenshots to put in the PDF report.

export FREESURFER_HOME=/usr/local/freesurfer
. $FREESURFER_HOME/SetUpFreeSurfer.sh

export T1=${OUT}/t1.nii
export FMRI=${OUT}/meanfmri.nii

# Thalamus ROIs
ss_roi_thal.sh

# FS thal and hipp ROIs
ss_roi_fs.sh

# Cortical ROIs
ss_roi_cort.sh

# MNI space connectivity maps
ss_conn_mni.sh

# Make PDF pages
ss_combine.sh

