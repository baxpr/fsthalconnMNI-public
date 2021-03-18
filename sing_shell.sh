#!/bin/sh

singularity shell --cleanenv \
  --home `pwd`/INPUTS \
  --bind INPUTS:/INPUTS \
  --bind OUTPUTS_before_org:/OUTPUTS \
  --bind freesurfer_license.txt:/usr/local/freesurfer/license.txt \
  fsthalconnMNI-v2.0.0.simg 
  