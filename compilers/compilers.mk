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

DOWNLOAD_DIR=${BUILD_ROOT}/compilers/downloads

SUBDIRS = arm-926ejs-eabi arm-926ejs-linux-gnueabi arm-cortexa9-eabi arm-cortexa9-linux-gnueabi

SUBDIRS-ALL = $(addsuffix -all, ${SUBDIRS})
SUBDIRS-CLEAN = $(addsuffix -clean, ${SUBDIRS})
SUBDIRS-INSTALL = $(addsuffix -install, ${SUBDIRS})
SUBDIRS-DISTCLEAN = $(addsuffix -distclean, ${SUBDIRS})

all: ${DOWNLOAD_DIR} ${SUBDIRS-ALL}

install: ${SUBDIRS-INSTALL}

clean: ${SUBDIRS-CLEAN}

distclean: ${SUBDIRS-DISTCLEAN}

${SUBDIRS-ALL}:
		$(MAKE) -C $(@:-all=) -f $(@:-all=).mk all

${SUBDIRS-CLEAN}:
	$(MAKE) -C $(@:-clean=) -f $(@:-clean=).mk clean

${SUBDIRS-INSTALL}:
	$(MAKE) -C $(@:-install=) -f $(@:-install=).mk install

${SUBDIRS-DISTCLEAN}:
	$(MAKE) -C $(@:-distclean=) -f $(@:-distclean=).mk distclean
	rm -rf ${BUILD_ROOT}/compilers

${DOWNLOAD_DIR}:
	mkdir -p ${DOWNLOAD_DIR}

.PHONY: ${SUBDIRS-ALL} ${SUBDIRS-CLEAN} ${SUBDIRS-INSTALL} ${SUBDIRS_DISTCLEAN}
