#
# Copyright (C) 2012 Red Rocket Computing
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
# i686-pc-elf.mk
# Created on: 15/10/12
# Author: Stephen Street
#

SOURCE_PATH = ${CURDIR}
BUILD_PATH = $(subst ${WORKSPACE},${BUILD_ROOT},${CURDIR})
IMAGE_PATH = ${IMAGE_ROOT}

all: ${IMAGE_PATH}/i686-pc-elf.tar.bz2

clean: ${BUILD_PATH}/.config
	cd ${BUILD_PATH} && DOWNLOAD_PATH=${DOWNLOAD_PATH} BUILD_PATH=${BUILD_PATH} ct-ng clean

distclean:
	rm -rf ${BUILD_PATH}

menuconfig: ${BUILD_PATH}/.config
	cd ${BUILD_PATH} && DOWNLOAD_PATH=${DOWNLOAD_PATH} BUILD_PATH=${BUILD_PATH} ct-ng menuconfig
	cp ${BUILD_PATH}/.config ${SOURCE_PATH}/i686-pc-elf.config
	rm -rf ${BUILD_PATH}

debug:
	@echo "BUILD_ROOT=${BUILD_ROOT}"
	@echo "TOOLS_ROOT=${TOOLS_ROOT}"
	@echo "SOURCE_PATH=${SOURCE_PATH}"
	@echo "DOWNLOAD_PATH=${DOWNLOAD_PATH}"
	@echo "BUILD_PATH=${BUILD_PATH}"

${IMAGE_PATH}/i686-pc-elf.tar.bz2: ${BUILD_PATH}/install/build.log.bz2
	tar -C ${BUILD_PATH}/install -cvjf ${IMAGE_PATH}/i686-pc-elf.tar.bz2 .
#	rm -rf ${IMAGE_ROOT}/i686-pc-elf-sysroot
#	cp -al ${IMAGE_ROOT}/i686-pc-elf/i686-pc-elf/i686-pc-elf-sysroot ${IMAGE_ROOT}/i686-pc-elf-sysroot
#	cp -al ${IMAGE_ROOT}/i686-pc-elf/i686-pc-elf/debug-root/* ${IMAGE_ROOT}/i686-pc-elf-sysroot/
#	rm -rf ${IMAGE_ROOT}/i686-pc-elf-sysroot/lib32 ${IMAGE_ROOT}/i686-pc-elf-sysroot/lib64 ${IMAGE_ROOT}/i686-pc-elf-sysroot/usr/lib32 ${IMAGE_ROOT}/i686-pc-elf-sysroot/usr/lib64
#	cd ${IMAGE_ROOT} && tar -C ${IMAGE_ROOT}/i686-pc-elf-sysroot -cjf i686-pc-elf-sysroot.tar.bz2 .

${BUILD_PATH}/install/build.log.bz2: ${BUILD_PATH}/.config
	cd ${BUILD_PATH} && DOWNLOAD_PATH=${DOWNLOAD_PATH} BUILD_PATH=${BUILD_PATH} ct-ng build

${BUILD_PATH}/.config: ${SOURCE_PATH}/i686-pc-elf.config
	mkdir -p ${BUILD_PATH}
	cp ${SOURCE_PATH}/i686-pc-elf.config ${BUILD_PATH}/.config

.PHONY: clean distclean


