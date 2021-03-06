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

where-am-i := ${CURDIR}/$(lastword $(subst $(lastword ${MAKEFILE_LIST}),,${MAKEFILE_LIST}))

# Setup up default goal
ifeq ($(.DEFAULT_GOAL),)
	.DEFAULT_GOAL := all
endif

SOURCE_PATH := ${CURDIR}
BUILD_PATH := $(subst ${PROJECT_ROOT},${BUILD_ROOT},${SOURCE_PATH})
TOOLS_PATH := ${TOOLS_ROOT}/bin

all: ${TOOLS_PATH}/ct-ng

clean: ${BUILD_PATH}/config.log
	${MAKE} -C ${BUILD_PATH} uninstall
	${MAKE} -C ${BUILD_PATH} clean

distclean:
	rm -rf ${BUILD_PATH}

${TOOLS_PATH}/ct-ng: ${BUILD_PATH}/config.log
	${MAKE} -C ${BUILD_PATH} install
	
${BUILD_PATH}/config.log:
	mkdir -p ${BUILD_PATH}
	cd ${BUILD_PATH} && git clone ${REPOSITORY_ROOT}/crosstool-ng .
	cd ${BUILD_PATH} && patch -p1 < ${SOURCE_PATH}/remove-recursion-check.patch
	cd ${BUILD_PATH} && patch -p1 < ${SOURCE_PATH}/fix-uninstall.patch
	cd ${BUILD_PATH} && patch -p1 < ${SOURCE_PATH}/add-gcc-parallel-make.patch
	cd ${BUILD_PATH} && ./bootstrap
	cd ${BUILD_PATH} && ./configure --prefix=${TOOLS_ROOT}

.PHONY: clean distclean

