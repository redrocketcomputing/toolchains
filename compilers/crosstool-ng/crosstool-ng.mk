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
# crosstool-ng.mk
# Created on: 30/10/13
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
DOWNLOAD_PATH := ${REPOSITORY_ROOT}/sources

CT_NG := DOWNLOAD_PATH=${DOWNLOAD_PATH} BUILD_PATH=${BUILD_PATH} ct-ng
 
TOOLCHAINS ?= $(subst ${SOURCE_PATH}/config/,,$(basename $(wildcard ${SOURCE_PATH}/config/*.config)))
TOOLCHAIN_MENUCONFIGS := $(addsuffix -menuconfig, ${TOOLCHAINS})
TOOLCHAIN_CLEANS := $(addsuffix -clean, ${TOOLCHAINS})
TOOLCHAIN_SOURCE_CONFIGS := $(addprefix ${SOURCE_PATH}/config/, $(addsuffix .config, ${TOOLCHAINS}))
TOOLCHAIN_BUILD_PATHS := $(addprefix ${BUILD_PATH}/build-, ${TOOLCHAINS})
TOOLCHAIN_BUILD_CONFIGS := $(addsuffix /.config, ${TOOLCHAIN_BUILD_PATHS})
TOOLCHAIN_INSTALL_PATHS := $(addprefix ${BUILD_PATH}/install-, ${TOOLCHAINS})
TOOLCHAIN_INSTALL_MARKERS := $(addsuffix /build.log.bz2, ${TOOLCHAIN_INSTALL_PATHS})
TOOLCHAIN_IMAGES := $(addprefix  ${IMAGE_PATH}/, $(addsuffix .tar.bz2, ${TOOLCHAINS}))

all: ${TOOLCHAIN_IMAGES}

menuconfig: ${TOOLCHAIN_MENUCONFIGS}

.PHONY: clean
clean: ${TOOLCHAIN_CLEANS}

.PHONY: distclean
distclean:
	rm -rf ${BUILD_PATH}

${TOOLCHAIN_IMAGES}: ${IMAGE_PATH}/%.tar.bz2: ${BUILD_PATH}/install-%/build.log.bz2
	mkdir -p ${IMAGE_PATH}
	tar -C ${BUILD_PATH}/install-$* --exclude="build.log.bz2" -cvjf ${IMAGE_PATH}/$*.tar.bz2 .

${TOOLCHAIN_CLEANS}: %-clean: ${BUILD_PATH}/build-%/.config
	${CT_NG} -C ${BUILD_PATH}/build-$* clean

${TOOLCHAIN_INSTALL_MARKERS}: ${BUILD_PATH}/install-%/build.log.bz2: ${BUILD_PATH}/build-%/.config ${DOWNLOAD_PATH}/.gitignore
	${CT_NG} -C ${BUILD_PATH}/build-$* build

${TOOLCHAIN_BUILD_CONFIGS}: ${BUILD_PATH}/build-%/.config: ${SOURCE_PATH}/config/%.config
	mkdir -p ${BUILD_PATH}/build-$*
	${CT_NG} DEFCONFIG=$< -C ${BUILD_PATH}/build-$* defconfig
	
${DOWNLOAD_PATH}/.gitignore:
	mkdir -p ${DOWNLOAD_PATH}
	touch ${DOWNLOAD_PATH}/.gitignore

${TOOLCHAIN_MENUCONFIGS}: %-menuconfig: ${BUILD_PATH}/build-%/.config
	${CT_NG} -C ${BUILD_PATH}/build-$* menuconfig
	cp ${BUILD_PATH}/build-$*/.config ${SOURCE_PATH}/config/$*.config
	rm -rf ${BUILD_PATH}/build-$*

.PHONY: debug
debug:
	@echo "SOURCE_PATH = ${SOURCE_PATH}"
	@echo "BUILD_PATH = ${BUILD_PATH}"
	@echo "IMAGE_PATH = ${IMAGE_PATH}"
	@echo "DOWNLOAD_PATH = ${DOWNLOAD_PATH}"
	@echo "TOOLCHAINS = ${TOOLCHAINS}"
	@echo "TOOLCHAIN_MENUCONFIGS = ${TOOLCHAIN_MENUCONFIGS}"
	@echo "TOOLCHAIN_CLEANS = ${TOOLCHAIN_CLEANS}"
	@echo "TOOLCHAIN_SOURCE_CONFIGS = ${TOOLCHAIN_SOURCE_CONFIGS}"
	@echo "TOOLCHAIN_BUILD_PATHS = ${TOOLCHAIN_BUILD_PATHS}"
	@echo "TOOLCHAIN_BUILD_CONFIGS = ${TOOLCHAIN_BUILD_CONFIGS}"
	@echo "TOOLCHAIN_INSTALL_PATHS = ${TOOLCHAIN_INSTALL_PATHS}"
	@echo "TOOLCHAIN_INSTALL_MARKERS = ${TOOLCHAIN_INSTALL_MARKERS}"
	@echo "TOOLCHAIN_IMAGES = ${TOOLCHAIN_IMAGES}"




