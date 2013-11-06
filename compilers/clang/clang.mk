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
# clang.mk
# Created on: 04/11/13
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

where-am-i := ${CURDIR}/$(lastword $(subst $(lastword ${MAKEFILE_LIST}),,${MAKEFILE_LIST}))

# Setup up default goal
ifeq ($(.DEFAULT_GOAL),)
	.DEFAULT_GOAL := all
endif

SOURCE_PATH := ${CURDIR}
BUILD_PATH := $(subst ${PROJECT_ROOT},${BUILD_ROOT},${SOURCE_PATH})
IMAGE_PATH := ${IMAGE_ROOT}

TARGET_VERSION ?= trunk

all: ${IMAGE_PATH}/clang-${TARGET_VERSION}.tar.bz2

.PHONY: clean
clean:

.PHONY: distclean
distclean:
	rm -rf ${BUILD_PATH}

${IMAGE_PATH}/clang-${TARGET_VERSION}.tar.bz2: ${BUILD_PATH}/Makefile
	${MAKE} WORKSPACE=${BUILD_PATH} REPOSITORY_ROOT=${REPOSITORY_ROOT} IMAGE_ROOT=${IMAGE_PATH} BUILD_ROOT=${BUILD_PATH}/build -C ${BUILD_PATH} all

#export REPOSITORY_ROOT ?= ${WORKSPACE}/repositories
#export TOOLS_ROOT ?= ${WORKSPACE}/local
#export IMAGE_ROOT ?= ${WORKSPACE}/images
#export BUILD_ROOT ?= ${WORKSPACE}/build
#export CROSS_ROOT ?= ${WORKSPACE}/rootfs

${BUILD_PATH}/Makefile:
	git clone ${REPOSITORY_ROOT}/clang-unwind-cxxabi-cxx.git ${BUILD_PATH}
	WORKSPACE=${BUILD_PATH} ${BUILD_PATH}/tools/scripts/fetch-external-projects

.PHONY: debug
debug:
	@echo "SOURCE_PATH = ${SOURCE_PATH}"
	@echo "BUILD_PATH = ${BUILD_PATH}"
	@echo "IMAGE_PATH = ${IMAGE_PATH}"


