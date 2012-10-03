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
# arm-cortexa9-linux-gnueabi.mk
# Created on: 18/06/12
# Author: Stephen Street
#

SOURCE_PATH = ${CURDIR}
BUILD_PATH = $(subst ${WORKSPACE},${BUILD_ROOT},${CURDIR})
IMAGE_PATH = ${IMAGE_ROOT}

all: ${IMAGE_PATH}/arm-cortexa9-linux-gnueabi.tar.bz2

clean: ${BUILD_PATH}/.config
	cd ${BUILD_PATH} && DOWNLOAD_PATH=${DOWNLOAD_PATH} BUILD_PATH=${BUILD_PATH} ct-ng clean

distclean:
	rm -rf ${BUILD_PATH}

menuconfig: ${BUILD_PATH}/.config
	cd ${BUILD_PATH} && DOWNLOAD_PATH=${DOWNLOAD_PATH} BUILD_PATH=${BUILD_PATH} ct-ng menuconfig
	cp ${BUILD_PATH}/.config ${SOURCE_PATH}/arm-cortexa9-linux-gnueabi.config
	rm -rf ${BUILD_PATH}

debug:
	@echo "BUILD_ROOT=${BUILD_ROOT}"
	@echo "TOOLS_ROOT=${TOOLS_ROOT}"
	@echo "SOURCE_PATH=${SOURCE_PATH}"
	@echo "DOWNLOAD_PATH=${DOWNLOAD_PATH}"
	@echo "BUILD_PATH=${BUILD_PATH}"

${IMAGE_PATH}/arm-cortexa9-linux-gnueabi.tar.bz2: ${BUILD_PATH}/install/build.log.bz2
	tar -C ${BUILD_PATH}/install -cvjf ${IMAGE_PATH}/arm-cortexa9-linux-gnueabi.tar.bz2 .
#	rm -rf ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot
#	cp -al ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi/arm-cortexa9-linux-gnueabi/arm-cortexa9-linux-gnueabi-sysroot ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot
#	cp -al ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi/arm-cortexa9-linux-gnueabi/debug-root/* ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot/
#	rm -rf ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot/lib32 ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot/lib64 ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot/usr/lib32 ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot/usr/lib64
#	cd ${IMAGE_ROOT} && tar -C ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot -cjf arm-cortexa9-linux-gnueabi-sysroot.tar.bz2 .

${BUILD_PATH}/install/build.log.bz2: ${BUILD_PATH}/.config
	cd ${BUILD_PATH} && DOWNLOAD_PATH=${DOWNLOAD_PATH} BUILD_PATH=${BUILD_PATH} ct-ng build

${BUILD_PATH}/.config: ${SOURCE_PATH}/arm-cortexa9-linux-gnueabi.config
	mkdir -p ${BUILD_PATH}
	cp ${SOURCE_PATH}/arm-cortexa9-linux-gnueabi.config ${BUILD_PATH}/.config

.PHONY: clean distclean


