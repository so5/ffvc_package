module load PrgEnv-intel
module load intel/openmpi165


pushd PDMlib/BUILD/
cmake ../
make install
if [ $? -ne 0 ]; then
  echo "make error!"
  exit 1
fi
popd

pushd LPTlib/
make all install
if [ $? -ne 0 ]; then
  echo "make error!"
  exit 2
fi
popd

pushd FFVC/BUILD_DIR/
rm src/ffvc
make all install
if [ $? -ne 0 ]; then
  echo "make error!"
  exit 3
fi
popd
