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
# project.mk
# Created on: 18/06/12
# Author: Stephen Street
#

SOURCE_DIR=../../../tools/openocd/repository
BUILD_DIR=${BUILD_ROOT}/tools/openocd
CONFIGURATION_MARKER=${BUILD_DIR}/config.log

all: ${CONFIGURATION_MARKER}
	${MAKE} -C ${BUILD_DIR} all

install: ${CONFIGURATION_MARKER}
	${MAKE} -C ${BUILD_DIR} install

clean: ${CONFIGURATION_MARKER}
	${MAKE} -C ${BUILD_DIR} clean

distclean:
	rm -rf ${BUILD_DIR}

debug:
	@echo "BUILD_ROOT=${BUILD_ROOT}"
	@echo "TOOLS_ROOT=${TOOLS_ROOT}"
	@echo "SOURCE_DIR=${SOURCE_DIR}"
	@echo "BUILD_DIR=${BUILD_DIR}"
	@echo "CONFIGURATION_MARKER=${CONFIGURATION_MARKER}"

${CONFIGURATION_MARKER}:
	mkdir -p ${BUILD_DIR}
	cd ${BUILD_DIR} && CPPFLAGS=-I${TOOLS_ROOT}/include LDFLAGS=-L${TOOLS_ROOT}/lib ${SOURCE_DIR}/configure --prefix=${TOOLS_ROOT} --enable-shared=no --enable-maintainer-mode --enable-ft2232_libftdi --enable-jlink
	
.PHONY: all install clean distclean

