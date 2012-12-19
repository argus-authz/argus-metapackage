Argus metapackage
=================

The EMI Argus metapackage `emi-argus` depends on:
 - Argus PAP service: `argus-pap`
 - Argus PDP service: `argus-pdp`
 - Argus PEP Server service: `argus-pep-server`
 - Argus `pepcli` command (for testing purpose): `argus-pepcli`
 - YAIM configuration for Argus services: `glite-yaim-argus-server`

Building
--------

Debian and Fedora compatible packages can be build.

To build source RPM package: `make srpm`
To build binary RPM package: `make rpm`

To build Debian source package: `make deb-src`
To build Debian binary package: `make deb`

Packages
--------

Prebuild packages are available at http://argus-authz.github.com/argus-metapackage
