#!/bin/sh
#
# package.sh
#
# Build deb and rpm packages using fpm after setting up a build directory
#
BUILD_DIR="./build"
PUPPETMASTER_MODULE_DIR="${BUILD_DIR}/modules/puppetmaster"

# Do minimal sanity checking
test -r package.sh || (echo "ERROR: you must run from the directory where package.sh is located!" ; exit 1)

echo "Updating puppet modules"
CWD=$(pwd)
cd ..
librarian-puppet install || (echo "ERROR: librarian-puppet failed, cannot continue!" ; cd $CWD; exit 1)
cd $CWD

echo "Loading package version information from version.sh"
. ./version.sh

echo "Removing old fpm build directory"
rm -rf $BUILD_DIR

echo "Preparing build directory for fpm"
mkdir $BUILD_DIR
cp -r ../bin $BUILD_DIR/
cp -r ../config $BUILD_DIR/
cp -r ../modules $BUILD_DIR/
mkdir $PUPPETMASTER_MODULE_DIR
cp -r ../manifests ../files ../metadata.json ../LICENSE ../README.md $PUPPETMASTER_MODULE_DIR
