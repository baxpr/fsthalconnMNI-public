#!/bin/bash

# Fix imagemagick policy to allow PDF output. See https://usn.ubuntu.com/3785-1/
sed -i 's/rights="none" pattern="PDF"/rights="read | write" pattern="PDF"/' \
/etc/ImageMagick-6/policy.xml

# Run the compiled matlab
xvfb-run --server-num=$(($$ + 99)) \
--server-args='-screen 0 1600x1200x24 -ac +extension GLX' \
bash ../bintest/run_test_pdf.sh /usr/local/MATLAB/MATLAB_Runtime/v92 \
/wkdir/src \
/usr/bin \
/usr/local/fsl \
/OUTPUTS \
project subject session scan

