#
# Copyright (c) Members of the EGEE Collaboration. 2004-2010.
# See http://www.eu-egee.org/partners/ for details on the copyright holders. 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# RPM/Debian packaging
#
name = emi-argus
version = 1.6.0
release = 1

git_url = https://github.com/argus-authz/argus-metapackage.git
git_branch = master

spec_file = fedora/$(name).spec

rpmbuild_dir = $(CURDIR)/rpmbuild
debbuild_dir = $(CURDIR)/debbuild
tmp_dir = $(CURDIR)/tmp


all: 
	@echo "make srpm|rpm for RPM packages"
	@echo "make deb-src|deb for Debian packages"

clean:
	@echo "Cleaning..."
	rm -rf $(rpmbuild_dir) $(spec_file) *.rpm
	rm -rf $(debbuild_dir) *.deb
	rm -fr $(tmp_dir)
	rm -fr $(name)*

dist:
	@echo "Package the sources..."
	test ! -d $(tmp_dir) || rm -fr $(tmp_dir)
	mkdir -p $(tmp_dir)/$(name)-$(version)
	cp README.md $(tmp_dir)/$(name)-$(version)
	test ! -f $(name)-$(version).tar.gz || rm $(name)-$(version).tar.gz
	tar -C $(tmp_dir) -czf $(name)-$(version).tar.gz $(name)-$(version)
	rm -fr $(tmp_dir)

#
# RPM
#

spec:
	@echo "Setting version and release in spec file: $(version)-$(release)"
	sed -e 's#@@SPEC_VERSION@@#$(version)#g' -e 's#@@SPEC_RELEASE@@#$(release)#g' $(spec_file).in > $(spec_file)


pre_rpmbuild: spec
	@echo "Preparing for rpmbuild in $(rpmbuild_dir)"
	mkdir -p $(rpmbuild_dir)/BUILD $(rpmbuild_dir)/RPMS $(rpmbuild_dir)/SOURCES $(rpmbuild_dir)/SPECS $(rpmbuild_dir)/SRPMS
	#test -f $(rpmbuild_dir)/SOURCES/$(name)-$(version).tar.gz || wget -P $(rpmbuild_dir)/SOURCES $(dist_url)


srpm: pre_rpmbuild
	@echo "Building SRPM in $(rpmbuild_dir)"
	rpmbuild --nodeps -v -bs $(spec_file) --define "_topdir $(rpmbuild_dir)"
	cp $(rpmbuild_dir)/SRPMS/*.src.rpm .


rpm: pre_rpmbuild
	@echo "Building RPM/SRPM in $(rpmbuild_dir)"
	rpmbuild --nodeps -v -ba $(spec_file) --define "_topdir $(rpmbuild_dir)"
	find $(rpmbuild_dir)/RPMS -name "*.rpm" -exec cp '{}' . \;


#
# Debian
#

pre_debbuild:
	@echo "Prepare for Debian building in $(debbuild_dir)"
	mkdir -p $(debbuild_dir)/$(name)-$(version)
	test -f $(debbuild_dir)/$(name)_$(version).orig.tar.gz || make dist && cp $(name)-$(version).tar.gz $(debbuild_dir)/$(name)_$(version).orig.tar.gz
	tar -C $(debbuild_dir) -xzf $(debbuild_dir)/$(name)_$(version).orig.tar.gz
	cp -r debian $(debbuild_dir)/$(name)-$(version)


deb-src: pre_debbuild
	@echo "Building Debian source package in $(debbuild_dir)"
	cd $(debbuild_dir) && dpkg-source -b $(name)-$(version)
	find $(debbuild_dir) -maxdepth 1 -type f -exec cp '{}' . \;

deb: pre_debbuild
	@echo "Building Debian package in $(debbuild_dir)"
	cd $(debbuild_dir)/$(name)-$(version) && debuild -us -uc 
	find $(debbuild_dir) -maxdepth 1 -name "*.deb" -exec cp '{}' . \;

