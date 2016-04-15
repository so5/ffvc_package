#! /bin/sh
#
##############################################################################
#
# FFV-C Install Shell 
#
# Copyright (c) 2014 Advanced Institute for Computational Science, RIKEN.
# All rights reserved.
#

#######################################
#
# Double precision Option
#
# $ ./install_*.sh double
#
#######################################

# Default Precision
export PRCSN1=float
export PRCSN2=4

arg=$1

if [ "${arg}" = "double" ]; then
export PRCSN1=double
export PRCSN2=8
fi

#######################################
# Edit MACRO for your target machine

export FFV_HOME=${HOME}/FFVC
export TMP_LDFLAGS=

export TMP_CCC=mpicc
export TMP_CXX=mpicxx
export TMP_F90=mpif90

#######################################


# library name
export TP_LIB=TextParser-1.6.5
export PM_LIB=PMlib-4.2.2
export PLY_LIB=Polylib-3.5.4
export CPM_LIB=CPMlib-2.1.2
export CDM_LIB=CDMlib-0.9.3
export FFVC=FFVC
export PDM_LIB=PDMlib
export LPT_LIB=LPTlib


# TextParser
#
echo
echo -----------------------------
echo Install TextParser
echo
if [ ! -d ${TP_LIB} ]; then
  tar xvzf ${TP_LIB}.tar.gz
fi
autoreconf -i
cd ${TP_LIB}/BUILD_DIR
../configure --prefix=${FFV_HOME}/TextParser \
             --with-comp=INTEL \
             CXX=$TMP_CXX \
             CXXFLAGS="-O3" 
make
if [ $? -ne 0 ]; then
  echo "make error!"
  exit
fi
make install
cd ../..



# PMlib
#
echo
echo -----------------------------
echo Install PMlib
echo
if [ ! -d ${PM_LIB} ]; then
  tar xvzf ${PM_LIB}.tar.gz
fi
autoreconf -i
cd ${PM_LIB}/BUILD_DIR
../configure --prefix=${FFV_HOME}/PMlib \
             --with-comp=INTEL \
             CXX=$TMP_CXX \
             CXXFLAGS="-O3"  \
             CC=$TMP_CCC \
             CFLAGS="-O3" 
make
if [ $? -ne 0 ]; then
  echo "make error!"
  exit
fi
make install
cd ../..



# Polylib
#
echo
echo -----------------------------
echo Install Polylib
echo
if [ ! -d ${PLY_LIB} ]; then
  tar xvzf ${PLY_LIB}.tar.gz
fi
autoreconf -i
cd ${PLY_LIB}/BUILD_DIR
../configure --prefix=${FFV_HOME}/Polylib \
             --with-parser=${FFV_HOME}/TextParser \
             --with-real=$PRCSN1 \
             CXX=$TMP_CXX \
             CXXFLAGS="-O3" 
make
if [ $? -ne 0 ]; then
  echo "make error!"
  exit
fi
make install
cd ../..




# CPMlib
#
echo
echo -----------------------------
echo Install CPMlib
echo
if [ ! -d ${CPM_LIB} ]; then
  tar xvzf ${CPM_LIB}.tar.gz
fi
autoreconf -i
cd ${CPM_LIB}/BUILD_DIR
../configure --prefix=${FFV_HOME}/CPMlib \
             --with-pm=${FFV_HOME}/PMlib \
             --with-parser=${FFV_HOME}/TextParser \
             --with-comp=INTEL \
             --with-example=no \
             --with-f90example=no \
             --with-f90real=$PRCSN2 \
             CXX=$TMP_CXX \
             CXXFLAGS="-O3" \
             F90=$TMP_F90 \
             F90FLAGS="-O3"  \
             LDFLAGS=$TMP_LDFLAGS
make
if [ $? -ne 0 ]; then
  echo "make error!"
  exit
fi
make install
cd ../..



# CDMlib
#
echo
echo -----------------------------
echo CDMlib
echo
if [ ! -d ${CDM_LIB} ]; then
  tar xvzf ${CDM_LIB}.tar.gz
fi
autoreconf -i
cd ${CDM_LIB}/BUILD_DIR
../configure --prefix=${FFV_HOME}/CDMlib \
             --with-parser=${FFV_HOME}/TextParser \
             F90=$TMP_F90 \
             F90FLAGS="-O3" \
             CXX=$TMP_CXX \
             CXXFLAGS="-O3" 
make
if [ $? -ne 0 ]; then
  echo "make error!"
  exit
fi
make install
cd ../..

#fpzip/Zoltan/PDMlib
#
if [ ! -d ${PDM_LIB} ];then
  echo "PDMlib not found!"
  exit
fi
pushd ${PDM_LIB}
./install.sh -c INTEL -p${FFV_HOME} -t${FFV_HOME}/TextParser
if [ $? -ne 0 ]; then
  echo "make error!"
  exit
fi
popd

#LPTlib
#
if [ ! -d ${LPT_LIB} ];then
  echo "LPTlib not foun!"
  exit
fi
pushd ${LPT_LIB}
autoreconf -i
./configure CXX=$TMP_CXX CXXFLAGS="-g -O3 -openmp" \
 --prefix=${FFV_HOME}/LPTlib \
 --with-pm=${FFV_HOME}/PMlib \
 --with-pdm=${FFV_HOME}/PDMlib \
 --with-zoltan=${FFV_HOME}/Zoltan \
 --with-fpzip=${FFV_HOME}/fpzip
make
if [ $? -ne 0 ]; then
  echo "make error!"
  exit
fi
make install
popd


# FFVC
#
echo
echo -----------------------------
echo Install FFVC
echo
if [ ! -d ${FFVC} ]; then
  tar xvzf ${FFVC}.tar.gz
fi
cd ${FFVC}
autoreconf -i
cd BUILD_DIR
../configure --prefix=${FFV_HOME}/FFVC \
             --with-cpm=${FFV_HOME}/CPMlib \
             --with-cdm=${FFV_HOME}/CDMlib \
             --with-pm=${FFV_HOME}/PMlib\
             --with-polylib=${FFV_HOME}/Polylib \
             --with-parser=${FFV_HOME}/TextParser \
             --with-lpt=${FFV_HOME}/LPTlib \
             --with-comp=INTEL \
             --with-precision=$PRCSN1 \
             CCC=$TMP_CCC \
             CFLAGS="-O3" \
             CXX=$TMP_CXX \
             CXXFLAGS="-O3 -openmp -qopt-report=5" \
             F90FLAGS="-O3 -Warn unused -fpp -openmp -qopt-report=5" \
             F90=$TMP_F90  \
             LDFLAGS=$TMP_LDFLAGS
make
if [ $? -ne 0 ]; then
  echo "make error!"
  exit
fi
make install
cd ../..
