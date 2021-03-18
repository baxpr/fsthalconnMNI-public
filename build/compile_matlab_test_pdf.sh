#!/bin/sh
#
# Compile the matlab code so we can run it without a matlab license. To create a 
# linux container, we need to compile on a linux machine. That means a VM, if we 
# are working on OS X.
#
# We require on our compilation machine:
#     Matlab 2017a, including compiler, with license
#
# The matlab version matters. If we compile with R2017a, it will only run under 
# the R2017a Runtime.

# We may need to add Matlab to the path on the compilation machine
export PATH=/usr/local/MATLAB/R2017a/bin:${PATH}

WD=`pwd`
matlab -nodisplay -nodesktop -nosplash -sd "${WD}" -r \
    "compile_test_pdf('${WD}/../bintest','${WD}/../src'); exit"

# We grant lenient execute permissions to the matlab executable and runscript so
# we don't have hiccups later.
chmod go+rx "${WD}"/../bintest/test_pdf
chmod go+rx "${WD}"/../bintest/run_test_pdf.sh
