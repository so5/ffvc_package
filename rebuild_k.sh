#!/bin/sh

FAILED=0
rm ~/scratch/FFVC_LPT/src/LPTlib/src/LPT/libLPT_a-LPT.o \
   ~/scratch/FFVC_LPT/src/LPTlib/src/libLPT.a \
   /scratch/hp120184/k02576/FFVC_LPT/LPTlib/lib/libLPT.a \
   /scratch/hp120184/k02576/FFVC_LPT/FFVC/bin/ffvc \
   /home/hp120184/k02576/scratch/FFVC_LPT/src/ffvc_package/FFVC/BUILD_DIR/src/ffvc

pushd /home/hp120184/k02576/scratch/FFVC_LPT/src/PDMlib/BUILD
make all install
if [ $? -ne 0 ]; then
  echo PDMlib build failed
  FAILED=1
fi
popd
if [ $FAILED -ne 0 ];then
  exit
fi

pushd /home/hp120184/k02576/scratch/FFVC_LPT/src/LPTlib
make all install
if [ $? -ne 0 ]; then
  echo LPTlib build failed
  FAILED=1
fi
popd
if [ $FAILED -ne 0 ];then
  exit
fi

pushd /home/hp120184/k02576/scratch/FFVC_LPT/src/ffvc_package/FFVC/BUILD_DIR
make all install
if [ $? -ne 0 ]; then
  echo FFVC build failed
  FAILED=1
fi
popd
if [ $FAILED -ne 0 ];then
  exit
fi
ls -l ~/scratch/FFVC_LPT/src/LPTlib/src/LPT/libLPT_a-LPT.o ~/scratch/FFVC_LPT/src/LPTlib/src/libLPT.a /scratch/hp120184/k02576/FFVC_LPT/LPTlib/lib/libLPT.a /scratch/hp120184/k02576/FFVC_LPT/FFVC/bin/ffvc /home/hp120184/k02576/scratch/FFVC_LPT/src/ffvc_package/FFVC/BUILD_DIR/src/ffvc
