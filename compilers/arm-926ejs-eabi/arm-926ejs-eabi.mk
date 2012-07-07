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
# arm-926ejs-eabi.mk
# Created on: 18/06/12
# Author: Stephen Street
#

SOURCE_DIR=${CURDIR}
BUILD_DIR=${BUILD_ROOT}/compilers/arm-926ejs-eabi
BUILD_MARKER=/opt/toolchains/arm-926ejs-eabi/build.log.bz2
CONFIGURATION_MARKER=${BUILD_DIR}/.config

all: ${BUILD_MARKER}

install: ${BUILD_MARKER}
	cd ${IMAGE_ROOT} && tar -C / -cjf arm-926ejs-eabi.tar.bz2 opt/toolchains/arm-926ejs-eabi

clean: ${CONFIGURATION_MARKER}
	cd ${BUILD_DIR} && ct-ng clean

distclean:
	rm -rf ${BUILD_DIR}
	rm -rf ${IMAGE_ROOT}/arm-926ejs-eabi*

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
	cp ${SOURCE_DIR}/arm-926ejs-eabi.config ${BUILD_DIR}/.config
	
.PHONY: all install clean distclean

