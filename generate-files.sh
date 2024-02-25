#!/bin/bash

clean() {
    rm -r .github/workflows/*.yml
    rm -r ci-tests/*/
}

makedirs () {
  mkdir -p .github/workflows
  mkdir -p ci-tests
}

generate() {
    name=$1
    dockerTag=$2
    version=$3

    cat <<EOF > ".github/workflows/$name-$version-nocuda.yml" 
on:
  [push]
name: $name - Build OpenCV $version (no cuda)
jobs:
  testbuild:
    name: Building OpenCV
    runs-on: ubuntu-latest
    steps:
      - name: Check out the build script repository
        uses: actions/checkout@master
      - name: Make scripts executable
        run: chmod +x "ci-tests/$name-$version-nocuda/entrypoint.sh"
      - name: Execute build script
        uses: ./ci-tests/$name-$version-nocuda
      - name: Upload Build Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: workspace_artifacts
          path: \${{ github.workspace }}
EOF
    mkdir -p "ci-tests/$name-$version-nocuda"
    cat <<EOF > "ci-tests/$name-$version-nocuda/action.yml" 
name: 'Run $name-$version-nocuda dockerfile'
description: 'Run $name-$version-nocuda dockerfile'
runs:
  using: 'docker'
  image: 'Dockerfile'
EOF
    cat <<EOF > "ci-tests/$name-$version-nocuda/Dockerfile" 
FROM $dockerTag
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EOF
    cat <<EOF > "ci-tests/$name-$version-nocuda/entrypoint.sh"
uname -a
apt-get update && apt-get install -y clang build-essential wget git sudo
DEBIAN_FRONTEND=noninteractive apt-get install -y keyboard-configuration
cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr \
-D OPENCV_EXTRA_MODULES_PATH=\$(realpath ../opencv_contrib/modules) \
-D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
-D WITH_OPENCL=ON \
-D WITH_CUDA=OFF \
-D WITH_QT=OFF \
-D WITH_OPENMP=ON \
-D BUILD_TIFF=ON \
-D WITH_FFMPEG=ON \
-D WITH_GSTREAMER=ON \
-D WITH_TBB=ON \
-D BUILD_TBB=ON \
-D BUILD_TESTS=OFF \
-D WITH_EIGEN=ON \
-D WITH_V4L=ON \
-D WITH_LIBV4L=ON \
-D WITH_PROTOBUF=ON \
-D OPENCV_ENABLE_NONFREE=ON \
-D INSTALL_C_EXAMPLES=OFF \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D PYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D BUILD_EXAMPLES=OFF ../opencv
fakeroot checkinstall --pkgname libopencv-titanian-nocuda --pkgversion $version-1+$name --arch amd64 --pkglicense Apache-2.0 --pkgsource opencv --maintainer "Ethan Charoenpitaks <echaroenpitaks@imsa.edu>" --provides "libopencv, libopencv-dev, opencv-data, python3-opencv, python3-opencv-apps, libopencv-apps-dev, libopencv-apps2d, libopencv-calib3d-dev, libopencv-calib3d406, libopencv-contrib-dev, libopencv-contrib406, libopencv-core-dev, libopencv-core406, libopencv-dnn-dev, libopencv-dnn406, libopencv-features2d-dev, libopencv-features2d406, libopencv-flann-dev, libopencv-flann406, libopencv-highgui-dev, libopencv-highgui406, libopencv-imgcodecs-dev, libopencv-imgcodecs406, libopencv-ml-dev, libopencv-ml406, libopencv-objdetect-dev, libopencv-objdetect406, libopencv-photo406, libopencv-shape-dev, libopencv-shape406, libopencv-stitching-dev, libopencv-stitching406, libopencv-superres-dev, libopencv-superres406, libopencv-video-dev, libopencv-video406, libopencv-videoio-dev, libopencv-videoio406, libopencv-videostab-dev, libopencv-videostab406, libopencv-viz-dev, libopencv-viz406" --requires "build-essential, cmake, git, unzip, pkg-config, zlib1g-dev, libjpeg-dev, libjpeg62-turbo-dev, libpng-dev, libtiff-dev, libavcodec-dev, libavformat-dev, libswscale-dev, libglew-dev, libgtk2.0-dev, libgtk-3-dev, libcanberra-gtk3-dev, python3-dev, python3-numpy, python3-pip, libxvidcore-dev, libx264-dev, libgtk-3-dev, libtbb-dev, libdc1394-dev, libxine2-dev, gstreamer1.0-tools, libv4l-dev, v4l-utils, qv4l2, gstreamer1.0-plugins-good, gstreamer1.0-plugins-base, libgstreamer-plugins-base1.0-dev, libswresample-dev, libvorbis-dev, libxine2-dev, libtesseract-dev, libmp3lame-dev, libtheora-dev, libpostproc-dev, libopencore-amrnb-dev, libopencore-amrwb-dev, libopenblas-dev, libatlas-base-dev, libblas-dev, liblapack-dev, liblapacke-dev, libeigen3-dev, gfortran, libhdf5-dev, protobuf-compiler, libprotobuf-dev, libgoogle-glog-dev, libgflags-dev, python3-numpy" --install=no --fstrans=yes
cp *.deb /github/workspace
EOF
    chmod +x "ci-tests/$name-$version-nocuda/entrypoint.sh"
}

# Creates workflows and dockerfiles given the name ($1) and docker tag ($2).
generateForOS() {
    name=$1
    dockerTag=$2

    versions=('4.9.0')

    printf "\n%s" "| $name |" >> README.md

    for version in "${versions[@]}"; do
        generate "$name" "$dockerTag" "$version"
        printf "%s" " [![$name-$version-nocuda build status](https://github.com/ethanc8/titanian-ci-opencv/actions/workflows/$name-$version-nocuda.yml/badge.svg)](https://github.com/ethanc8/titanian-ci-opencv/actions/workflows/$name-$version-nocuda.yml) |" >> README.md
    done
}

clean
makedirs

generateForOS ubu2204 'ubuntu:jammy'

# generateForOS debsid 'debian:sid'
# generateForOS debtesting 'debian:testing'
# # ADD NEW CODENAMES HERE
# generateForOS deb12 'debian:12'
# generateForOS deb11 'debian:11'
# generateForOS deb10 'debian:10'

# generateForOS ubudevel 'ubuntu:devel'
# # ADD NEW CODENAMES HERE
# generateForOS ubu2310 'ubuntu:mantic'
# generateForOS ubu2204 'ubuntu:jammy'
# generateForOS ubu2004 'ubuntu:focal'
# generateForOS ubu1804 'ubuntu:bionic'
