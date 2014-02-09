#
# Copyright (C) 2013 Red Rocket Computing
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# gcc-arm-embedded.mk
# Created on: 05/11/13
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

where-am-i := ${CURDIR}/$(lastword $(subst $(lastword ${MAKEFILE_LIST}),,${MAKEFILE_LIST}))

# Setup up default goal
ifeq ($(.DEFAULT_GOAL),)
	.DEFAULT_GOAL := all
endif

#https://launchpad.net/gcc-arm-embedded/4.8/4.8-2013-q4-major/+download/gcc-arm-none-eabi-4_8-2013q4-20131204-src.tar.bz2

SOURCE_PATH := ${CURDIR}
BUILD_PATH := $(subst ${PROJECT_ROOT},${BUILD_ROOT},${SOURCE_PATH})
IMAGE_PATH := ${IMAGE_ROOT}
DOWNLOAD_PATH := ${REPOSITORY_ROOT}/sources

SOURCE_BASE := gcc-arm-none-eabi-4_8
SOURCE_VERSION := 2013q4
SOURCE_RELEASE_DATE := 20131204
SOURCE_PACKAGE := ${SOURCE_BASE}-${SOURCE_VERSION}-${SOURCE_RELEASE_DATE}-src.tar.bz2
SOURCE_URI := "https://launchpad.net/gcc-arm-embedded/4.8/4.8-2013-q4-major/+download"

all: ${IMAGE_PATH}/${SOURCE_BASE}-linux.tar.bz2

clean:
	rm -rf ${IMAGE_PATH}/${SOURCE_BASE}-linux.tar.bz2

distclean:
	rm -rf ${BUILD_PATH}

${IMAGE_PATH}/${SOURCE_BASE}-linux.tar.bz2: ${BUILD_PATH}/pkg/${SOURCE_BASE}-linux.tar.bz2
	mkdir -p ${IMAGE_PATH}
	ln -f ${BUILD_PATH}/pkg/${SOURCE_BASE}-linux.tar.bz2 ${IMAGE_PATH}/${SOURCE_BASE}-linux.tar.bz2

${BUILD_PATH}/pkg/${SOURCE_BASE}-linux.tar.bz2: ${BUILD_PATH}/release.txt
	cd ${BUILD_PATH} && ./build-prerequisites.sh --skip_mingw32
	cd ${BUILD_PATH} && ./build-toolchain.sh --skip_mingw32
	
${BUILD_PATH}/release.txt: ${DOWNLOAD_PATH}/${SOURCE_PACKAGE}
	mkdir -p ${BUILD_PATH}
	tar -C ${BUILD_PATH} --strip=1 -mxf ${DOWNLOAD_PATH}/${SOURCE_PACKAGE}
	cd ${BUILD_PATH}/src && find -name "*.tar.*" | xargs -I% tar -xf %
#	cd ${BUILD_PATH} && patch -p1 < ${SOURCE_PATH}/patches/change-build-host-to-x86-64.patch
	cd ${BUILD_PATH} && patch -p1 < ${SOURCE_PATH}/patches/remove-release-date-from-package.patch
#	cd ${BUILD_PATH} && patch -p1 < ${SOURCE_PATH}/patches/cloog-ppl-run-autogen.patch
#	cd ${BUILD_PATH}/src/cloog-ppl-0.15.11 && patch -p1 < ${SOURCE_PATH}/patches/add_on_libs_position.patch
	cd ${BUILD_PATH}/src/zlib-1.2.5 && patch -p1 < ../zlib-1.2.5.patch

${DOWNLOAD_PATH}/${SOURCE_PACKAGE}:
	mkdir -p ${DOWNLOAD_PATH}
	wget ${SOURCE_URI}/${SOURCE_PACKAGE} -O ${DOWNLOAD_PATH}/${SOURCE_PACKAGE}

