FROM amd64/ubuntu:20.04

ARG GIT_COMMIT=main
ARG GH_PR
ARG GH_SLUG=pocl/pocl
ARG LLVM_VERSION=12

LABEL git-commit=$GIT_COMMIT vendor=pocl distro=Ubuntu version=1.0

ENV TERM=dumb
ENV TZ=Etc/UTC
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt upgrade -y

RUN apt install -y tzdata
RUN apt install -y build-essential ocl-icd-libopencl1 cmake git pkg-config libclang-${LLVM_VERSION}-dev clang-${LLVM_VERSION} libclang-cpp${LLVM_VERSION}-dev llvm-${LLVM_VERSION}-dev make ninja-build ocl-icd-libopencl1 ocl-icd-dev ocl-icd-opencl-dev libhwloc-dev zlib1g zlib1g-dev dialog apt-utils

RUN cd /home ; git clone https://github.com/$GH_SLUG.git ; cd /home/pocl ; git checkout $GIT_COMMIT
RUN cd /home/pocl ; test -z "$GH_PR" || (git fetch origin +refs/pull/$GH_PR/merge && git checkout -qf FETCH_HEAD) && :
RUN cd /home/pocl ; mkdir b ; cd b; cmake -G Ninja -DWITH_LLVM_CONFIG=/usr/bin/llvm-config-${LLVM_VERSION} -DCMAKE_INSTALL_PREFIX=/usr ..
RUN cd /home/pocl/b ; ninja install
# removing this picks up PoCL from the system install, not the build dir
RUN cd /home/pocl/b ; rm -f CTestCustom.cmake
CMD cd /home/pocl/b ; ctest -j4 --output-on-failure -L internal
