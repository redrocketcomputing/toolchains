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
# clang.mk
# Created on: 01/10/12
# Author: Stephen Street
#

VERSION = 3.1
SOURCE_PATH = ${CURDIR}/${VERSION}
BUILD_PATH = $(subst ${WORKSPACE},${BUILD_ROOT},${CURDIR})
BOOTSTRAP_PATH = ${BUILD_PATH}/bootstrap
FINAL_PATH = ${BUILD_PATH}/final
IMAGE_PATH = ${IMAGE_ROOT}

all: ${IMAGE_PATH}/clang-${VERSION}.tar.bz2

clean: 
	-${MAKE} -C ${FINAL_PATH} clean
	rm -rf ${FINAL_PATH}/install
	-${MAKE} -C ${BOOTSTRAP_PATH} clean
	rm -rf ${BOOTSTRAP_PATH}/install
	rm -rf ${IMAGE_PATH}/clang-${VERSION}.tar.bz2

distclean:
	rm -rf ${BUILD_PATH}

realclean: distclean
	rm -rf ${IMAGE_PATH}/clang-${VERSION}.tar.bz2

debug:
	@echo "BUILD_ROOT=${BUILD_ROOT}"
	@echo "TOOLS_ROOT=${TOOLS_ROOT}"
	@echo "SOURCE_PATH=${SOURCE_PATH}"
	@echo "BUILD_PATH=${BUILD_PATH}"
	@echo "BOOTSTRAP_PATH=${BOOTSTRAP_PATH}"
	@echo "FINAL_PATH=${FINAL_PATH}"

${IMAGE_PATH}/clang-${VERSION}.tar.bz2: ${FINAL_PATH}/install/bin/clang
	tar -C ${FINAL_PATH}/install -cvjf ${IMAGE_PATH}/clang-${VERSION}.tar.bz2 .

${FINAL_PATH}/install/bin/clang: ${BOOTSTRAP_PATH}/install/bin/clang ${FINAL_PATH}/config.log
	${MAKE} -j 8 -C ${FINAL_PATH} install
	mv ${FINAL_PATH}/install/doc ${FINAL_PATH}/install/share/

${FINAL_PATH}/config.log:
	mkdir -p ${FINAL_PATH}
	cd ${FINAL_PATH} && CC=${BOOTSTRAP_PATH}/install/bin/clang CXX=${BOOTSTRAP_PATH}/install/bin/clang++ ${SOURCE_PATH}/configure --prefix=${FINAL_PATH}/install --enable-optimized --enable-targets=all --enable-shared 

${BOOTSTRAP_PATH}/install/bin/clang: ${BOOTSTRAP_PATH}/config.log
	${MAKE} -j 8 -C ${BOOTSTRAP_PATH} install

${BOOTSTRAP_PATH}/config.log:
	mkdir -p ${BOOTSTRAP_PATH}
	cd ${BOOTSTRAP_PATH} && ${SOURCE_PATH}/configure --prefix=${BOOTSTRAP_PATH}/install --enable-optimized --disable-jit --enable-targets=host

.PHONY: clean distclean realclean

