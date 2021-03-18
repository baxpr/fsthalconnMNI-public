#!/bin/bash
#
# Make PDF pages from screenshots

cd ${OUT}/wkdir

# Connectivity maps
convert -density 300 -gravity East conn_mni.png \
  -background white -resize 1850x -extent 2050x2800 -bordercolor white -border 100 \
  -gravity SouthEast -background white -splice 0x15 -pointsize 9 \
  -annotate +25+25 "$(date)" \
  -gravity NorthWest -pointsize 12 -annotate +50+50 \
  "${project} ${subject} ${session} ${scan}" \
  -gravity West -pointsize 12 -annotate +50-950 "L HIPP" \
  -gravity West -pointsize 12 -annotate +50-350 "L FPAR" \
  -gravity West -pointsize 12 -annotate +50+350 "L DATTN" \
  -gravity West -pointsize 12 -annotate +50+950 "L DMN" \
  page_conn_mni.png

# Cortical ROIs
convert -density 300 -gravity East rois_cort.png \
  -background white -resize 1850x -extent 2050x2800 -bordercolor white -border 100 \
  -gravity SouthEast -background white -splice 0x15 -pointsize 9 \
  -annotate +25+25 "$(date)" \
  -gravity NorthWest -pointsize 12 -annotate +50+50 \
  "${project} ${subject} ${session} ${scan}" \
  -gravity West -pointsize 12 -annotate +50-800 "Cort" \
  -gravity West -pointsize 12 -annotate +50+100 "Yeo7" \
  -gravity West -pointsize 12 -annotate +50+800 "FS" \
  page_rois_cort.png

# Thal ROIs
convert -density 300 -gravity East rois_thal.png \
  -background white -resize 1700x -extent 2050x2800 -bordercolor white -border 100 \
  -gravity SouthEast -background white -splice 0x15 -pointsize 9 \
  -annotate +25+25 "$(date)" \
  -gravity NorthWest -pointsize 12 -annotate +50+50 \
  "${project} ${subject} ${session} ${scan}" \
  -gravity West -pointsize 12 -annotate +100-900 "ABIDE" \
  -gravity West -pointsize 12 -annotate +100+0 "DTI" \
  -gravity West -pointsize 12 -annotate +100+900 "Morel" \
  page_rois_thal.png
  
# FS
convert -density 300 -gravity East rois_fs.png \
  -background white -resize 1850x -extent 2050x2800 -bordercolor white -border 100 \
  -gravity SouthEast -background white -splice 0x15 -pointsize 9 \
  -annotate +25+25 "$(date)" \
  -gravity NorthWest -pointsize 12 -annotate +50+50 \
  "${project} ${subject} ${session} ${scan}" \
  -gravity West -pointsize 12 -annotate +60-500 "LHIPP" \
  -gravity West -pointsize 12 -annotate +60+400 "Lthal" \
  page_rois_fs.png

