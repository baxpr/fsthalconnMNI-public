#!/bin/bash

function connmap {
	# 1 IMG
	# 2 name
	# 3-5 x,y,z
	# connmap sZ_LHIPP_wremovegm.nii hipp -25 -20 -16

	freeview \
	  -v ${OUT}/wt1.nii \
	  -v ${OUT}/${1}:colormap=heat:heatscale=90,95,100:percentile=true \
	  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport sagittal \
	  -ras ${3} -18 18 \
	  -ss conn_mni_${2}_sag.png

  	freeview \
  	  -v ${OUT}/wt1.nii \
  	  -v ${OUT}/${1}:colormap=heat:heatscale=90,95,100:percentile=true \
  	  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport coronal \
  	  -ras 0 ${4} 18 \
  	  -ss conn_mni_${2}_cor.png

	freeview \
	  -v ${OUT}/wt1.nii \
	  -v ${OUT}/${1}:colormap=heat:heatscale=90,95,100:percentile=true \
	  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport axial \
	  -ras 0 -18 ${5} \
	  -ss conn_mni_${2}_axi.png

	montage -mode concatenate \
	  conn_mni_${2}_sag.png conn_mni_${2}_cor.png conn_mni_${2}_axi.png \
	  -tile 3x -quality 100 -background black -gravity center \
	  -border 10 -bordercolor black conn_mni_${2}.png

}

cd ${OUT}/wkdir

connmap connmaps/sZ_LHIPP_wremovegm.nii hipp -25 -20 -16
connmap connmaps/sZ_Yeo7_L_7_def_wremovegm.nii dmn 0 -16 38
connmap connmaps/sZ_Yeo7_L_6_fpar_wremovegm.nii fpar 0 -18 48
connmap connmaps/sZ_Yeo7_L_3_dattn_wremovegm.nii dattn -28 -64 40

montage -mode concatenate \
  conn_mni_hipp.png conn_mni_fpar.png conn_mni_dattn.png conn_mni_dmn.png \
  -tile 1x -quality 100 -background black -gravity center \
  -border 10 -bordercolor white conn_mni.png

