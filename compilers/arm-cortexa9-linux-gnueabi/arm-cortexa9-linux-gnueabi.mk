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

SOURCE_DIR=${CURDIR}
BUILD_DIR=${BUILD_ROOT}/compilers/arm-cortexa9-linux-gnueabi
BUILD_MARKER=/opt/toolchains/arm-cortexa9-linux-gnueabi/build.log.bz2
CONFIGURATION_MARKER=${BUILD_DIR}/.config

all: ${BUILD_MARKER}

install: ${BUILD_MARKER}
	rm -rf ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot
	cp -al /opt/toolchains/arm-cortexa9-linux-gnueabi/arm-cortexa9-linux-gnueabi/arm-cortexa9-linux-gnueabi-sysroot ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot
	cp -al /opt/toolchains/arm-cortexa9-linux-gnueabi/arm-cortexa9-linux-gnueabi/debug-root/* ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot/
	rm -rf ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot/lib32 ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot/lib64 ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot/usr/lib32 ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot/usr/lib64
	cd ${IMAGE_ROOT} && tar -C ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot -cjf arm-cortexa9-linux-gnueabi-sysroot.tar.bz2 .
	rm -rf ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi-sysroot
	cd ${IMAGE_ROOT} && tar -C / -cjf arm-cortexa9-linux-gnueabi.tar.bz2 opt/toolchains/arm-cortexa9-linux-gnueabi

clean: ${CONFIGURATION_MARKER}
	cd ${BUILD_DIR} && ct-ng clean

distclean:
	rm -rf ${BUILD_DIR}
	rm -rf ${IMAGE_ROOT}/arm-cortexa9-linux-gnueabi*

debug:
	@echo "BUILD_ROOT=${BUILD_ROOT}"
	@echo "TOOLS_ROOT=${TOOLS_ROOT}"
	@echo "SOURCE_DIR=${SOURCE_DIR}"
	@echo "BUILD_DIR=${BUILD_DIR}"
	@echo "BUILD_MARKER=${BUILD_MARKER}"
	@echo "CONFIGURATION_MARKER=${CONFIGURATION_MARKER}"

${BUILD_MARKER}: ${CONFIGURATION_MARKER}
	cd ${BUILD_DIR} && ct-ng build

${CONFIGURATION_MARKER}:
	mkdir -p ${BUILD_DIR}
	cp ${SOURCE_DIR}/arm-cortexa9-linux-gnueabi.config ${BUILD_DIR}/.config
	
.PHONY: all install clean distclean

