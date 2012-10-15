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
# compilers.mk
# Created on: 06/07/12
# Author: Stephen Street
#

BUILD_PATH = $(subst ${WORKSPACE},${BUILD_ROOT},${CURDIR})

# Force DOWNLOAD_PATH into the environment
export DOWNLOAD_PATH = ${BUILD_PATH}/downloads

SUBDIRS = clang arm-926ejs-eabi arm-926ejs-linux-gnueabi arm-cortexa9-eabi arm-cortexa9-linux-gnueabi i686-pc-linux-gnu i686-pc-elf

SUBDIRS-ALL = $(addsuffix -all, ${SUBDIRS})
SUBDIRS-CLEAN = $(addsuffix -clean, ${SUBDIRS})
SUBDIRS-DISTCLEAN = $(addsuffix -distclean, ${SUBDIRS})

all: ${DOWNLOAD_PATH} ${SUBDIRS-ALL}

clean: ${SUBDIRS-CLEAN}

distclean: ${SUBDIRS-DISTCLEAN}
	rm -rf ${BUILD_DIR}

${SUBDIRS-ALL}:
		${MAKE} -C $(@:-all=) -f $(@:-all=).mk all

${SUBDIRS-CLEAN}:
	${MAKE} -C $(@:-clean=) -f $(@:-clean=).mk clean

${SUBDIRS-DISTCLEAN}:
	${MAKE} -C $(@:-distclean=) -f $(@:-distclean=).mk distclean

${DOWNLOAD_PATH}:
	mkdir -p ${DOWNLOAD_PATH}

.PHONY: ${SUBDIRS-ALL} ${SUBDIRS-CLEAN} ${SUBDIRS_DISTCLEAN}
