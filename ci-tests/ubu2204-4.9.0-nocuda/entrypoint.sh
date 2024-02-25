#!/bin/bash
set -x # Print out the commands to the screen before executing them
uname -a
apt update
DEBIAN_FRONTEND=noninteractive apt install -y clang build-essential git sudo keyboard-configuration cmake unzip pkg-config zlib1g-dev libjpeg-dev libjpeg62-turbo-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libglew-dev libgtk2.0-dev libgtk-3-dev libcanberra-gtk* python3-dev python3-numpy python3-pip libxvidcore-dev libx264-dev libgtk-3-dev libtbb-dev libdc1394-dev libxine2-dev gstreamer1.0-tools libv4l-dev v4l-utils qv4l2 gstreamer1.0-plugins-good gstreamer1.0-plugins-base libgstreamer-plugins-base1.0-dev libswresample-dev libvorbis-dev libxine2-dev libtesseract-dev libmp3lame-dev libtheora-dev libpostproc-dev libopencore-amrnb-dev libopencore-amrwb-dev libopenblas-dev libatlas-base-dev libblas-dev liblapack-dev liblapacke-dev libeigen3-dev gfortran libhdf5-dev protobuf-compiler libprotobuf-dev libgoogle-glog-dev libgflags-dev python3-numpy
git clone https://github.com/opencv/opencv --depth 1 --branch 4.9.0
git clone https://github.com/opencv/opencv_contrib --depth 1 --branch 4.9.0
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr -D OPENCV_EXTRA_MODULES_PATH=$(realpath ../opencv_contrib/modules) -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 -D WITH_OPENCL=ON -D WITH_CUDA=OFF -D WITH_QT=OFF -D WITH_OPENMP=ON -D BUILD_TIFF=ON -D WITH_FFMPEG=ON -D WITH_GSTREAMER=ON -D WITH_TBB=ON -D BUILD_TBB=ON -D BUILD_TESTS=OFF -D WITH_EIGEN=ON -D WITH_V4L=ON -D WITH_LIBV4L=ON -D WITH_PROTOBUF=ON -D OPENCV_ENABLE_NONFREE=ON -D INSTALL_C_EXAMPLES=OFF -D INSTALL_PYTHON_EXAMPLES=OFF -D PYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages -D OPENCV_GENERATE_PKGCONFIG=ON -D BUILD_EXAMPLES=OFF ../opencv
make
fakeroot checkinstall --pkgname libopencv-titanian-nocuda --pkgversion 4.9.0-1+ubu2204 --arch amd64 --pkglicense Apache-2.0 --pkgsource opencv --maintainer "Ethan Charoenpitaks <echaroenpitaks@imsa.edu>" --provides "libopencv, libopencv-dev, opencv-data, python3-opencv, python3-opencv-apps, libopencv-apps-dev, libopencv-apps2d, libopencv-calib3d-dev, libopencv-calib3d406, libopencv-contrib-dev, libopencv-contrib406, libopencv-core-dev, libopencv-core406, libopencv-dnn-dev, libopencv-dnn406, libopencv-features2d-dev, libopencv-features2d406, libopencv-flann-dev, libopencv-flann406, libopencv-highgui-dev, libopencv-highgui406, libopencv-imgcodecs-dev, libopencv-imgcodecs406, libopencv-ml-dev, libopencv-ml406, libopencv-objdetect-dev, libopencv-objdetect406, libopencv-photo406, libopencv-shape-dev, libopencv-shape406, libopencv-stitching-dev, libopencv-stitching406, libopencv-superres-dev, libopencv-superres406, libopencv-video-dev, libopencv-video406, libopencv-videoio-dev, libopencv-videoio406, libopencv-videostab-dev, libopencv-videostab406, libopencv-viz-dev, libopencv-viz406" --requires "build-essential, cmake, git, unzip, pkg-config, zlib1g-dev, libjpeg-dev, libjpeg62-turbo-dev, libpng-dev, libtiff-dev, libavcodec-dev, libavformat-dev, libswscale-dev, libglew-dev, libgtk2.0-dev, libgtk-3-dev, libcanberra-gtk3-dev, python3-dev, python3-numpy, python3-pip, libxvidcore-dev, libx264-dev, libgtk-3-dev, libtbb-dev, libdc1394-dev, libxine2-dev, gstreamer1.0-tools, libv4l-dev, v4l-utils, qv4l2, gstreamer1.0-plugins-good, gstreamer1.0-plugins-base, libgstreamer-plugins-base1.0-dev, libswresample-dev, libvorbis-dev, libxine2-dev, libtesseract-dev, libmp3lame-dev, libtheora-dev, libpostproc-dev, libopencore-amrnb-dev, libopencore-amrwb-dev, libopenblas-dev, libatlas-base-dev, libblas-dev, liblapack-dev, liblapacke-dev, libeigen3-dev, gfortran, libhdf5-dev, protobuf-compiler, libprotobuf-dev, libgoogle-glog-dev, libgflags-dev, python3-numpy" --install=no --fstrans=yes
cp *.deb /github/workspace
