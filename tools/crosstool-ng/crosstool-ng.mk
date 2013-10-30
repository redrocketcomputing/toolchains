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
# crosstools-ng.mk
# Created on: 18/06/12
# Author: Stephen Street
#

SOURCE_PATH = ${CURDIR}/src
BUILD_PATH = $(subst ${WORKSPACE},${BUILD_ROOT},${CURDIR})

all: ${TOOLS_ROOT}/bin/ct-ng

clean: ${CONFIGURATION_MARKER}
	${MAKE} -C ${BUILD_PATH} clean

distclean:
	rm -rf ${BUILD_PATH}

debug:
	@echo "BUILD_ROOT=${BUILD_ROOT}"
	@echo "TOOLS_ROOT=${TOOLS_ROOT}"
	@echo "SOURCE_DIR=${SOURCE_DIR}"
	@echo "BUILD_PATH=${BUILD_PATH}"
	@echo "CONFIGURATION_MARKER=${CONFIGURATION_MARKER}"

${TOOLS_ROOT}/bin/ct-ng: ${BUILD_PATH}/config.log
	${MAKE} -C ${BUILD_PATH} install
	
${BUILD_PATH}/config.log:
	mkdir -p ${BUILD_PATH}
	cp -a ${SOURCE_PATH}/* ${BUILD_PATH}
	cd ${BUILD_PATH} && patch -p1 < ${SOURCE_PATH}/../remove-recursion-check.patch
	cd ${BUILD_PATH} && ./configure --prefix=${TOOLS_ROOT}
	
.PHONY: clean distclean

