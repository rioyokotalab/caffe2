#pip install numpy
#pip install future
#pip install protobuf

#git clone https://github.com/caffe2/caffe2.git && cd caffe2
#git reset --hard 0f72d2508c5d5c295c1cd54aae1460a22ea994ea
#git submodule update --init

#rm -rf build && mkdir build && cd build


#----- pyenv
export PYENV_ROOT=/home/gi75/i75012/env/src/pyenv
if [ -d "${PYENV_ROOT}" ]; then
   export PATH=${PYENV_ROOT}/bin:$PATH
   eval "$(pyenv init -)"
fi

cd caffe2/build

module load boost/1.61 
LOCAL=/home/gi75/i75012/env/local
PYTHON_INCLUDE=/home/gi75/i75012/lustre/env/src/pyenv/versions/2.7.9/include
PYTHON_LIB=/usr/lib:/home/gi75/i75012/lustre/env/src/pyenv/versions/2.7.9:/home/gi75/i75012/env/src/pyenv/versions/2.7.9/lib:/home/env/src/pyenv/versions/2.7.9/lib/python2.7
PYTHON_INCLUDE_DIRS=${PYTHON_INCLUDE}
NUMPY_INCLUDE_DIR=/home/gi75/i75012/env/src/pyenv/versions/2.7.9/lib/python2.7/site-packages/numpy/core/include
PYTHON_LIBRARIES=${PYTHON_LIB}
HDF5_HL_LIBRARIES=/home/gi75/i75012/env/local/hdf5-1.10.0-patch1/lib

declare -a PACKAGES=(\
'boost_1_63_0' \
'gflags-2.2.0' \
'glog-0.3.4' \
'hdf5-1.10.0-patch1' \
'lmdb-LMDB_0.9.18' \
'cudnn7/cuda' \
'snappy-1.1.4' \
'opencv-2.4.13' \
'nccl-1.3.4-1' \
'cudnn7/cuda' \
'ATLAS' \
)

PREFIX_PATH=/home/gi75/i75012/env/local/cudnn7/cuda

for s in "${PACKAGES[@]}"; do
PREFIX_PATH=$LOCAL/$s:$PREFIX_PATH
done

CMAKE_PREFIX_PATH=$PYTHON_INCLUDE_DIRS:$NUMPY_INCLUDE_DIR:$PYTHON_LIBRARIES:$HDF5_HL_LIBRARIES:$PREFIX_PATH cmake \
-DCUDNN_INCLUDE_DIR=/home/gi75/i75012/env/local/cudnn7/cuda/include \
-DCUDNN_LIBRARY=/home/gi75/i75012/env/local/cudnn7/cuda/lib/libcudnn.so.7 \
-DNUMPY_INCLUDE_DIR=$NUMPY_INCLUDE_DIR \
-DPYTHON_INCLUDE_DIRS=$PYTHON_INCLUDE_DIRS \
-DPYTHON_LIBRARIES=${PYTHON_LIBRARIES} \
-DCMAKE_INSTALL_PREFIX=/home/gi75/i75012/dl/caffe2/local \
-DUSE_NCCL=ON \
-DUSE_LEVELDB=OFF \
.. | tee configure.log

make all -j 248 && make install -j 248

#-DCUDA_TOOLKIT_ROOT_DIR=/lustre/app/acc/cuda/8.0 \
