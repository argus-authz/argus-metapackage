Argus metapackage
=================

The Argus metapackage `argus-authz` depends on:
 - Argus PAP service: `argus-pap`
 - Argus PDP service: `argus-pdp`
 - Argus PEP Server service: `argus-pep-server`
 - Argus `pepcli` command (for testing purpose): `argus-pepcli`
 - BDII
 - `lcg-expiregridmapdir`
 - `fetch-crl`

Building
--------

Fedora compatible packages can be build.

To build source RPM package: `make srpm` and to build binary RPM package: `make rpm`


