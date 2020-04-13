#!/bin/sh
#
# package.sh
#
# Build deb and rpm packages using fpm after setting up a build directory
#
BUILD_DIR="./build"
PUPPETMASTER_MODULE_DIR="${BUILD_DIR}/modules/puppetmaster"
LICENSE="BSD-2-Clause"
VENDOR="Puppeteers_Oy"
MAINTAINER="info@puppeteers.fi"
URL="https://www.puppeteers.fi"

# Do minimal sanity checking
test -r package.sh || (echo "ERROR: you must run from the directory where package.sh is located!" ; exit 1)

echo "Updating puppet modules"
CWD=$(pwd)
cd ..
r10k puppetfile install --moduledir=modules --force || (echo "ERROR: r10k failed, cannot continue!" ; cd $CWD; exit 1)
cd $CWD

echo "Loading package version information from version.sh"
. ./version.sh

echo "Removing old fpm build directory"
rm -rf $BUILD_DIR

echo "Preparing build directory for fpm"
mkdir $BUILD_DIR
cp -r ../bin $BUILD_DIR/
cp -r ../config $BUILD_DIR/
cp -r ../hooks $BUILD_DIR/
cp -r ../modules $BUILD_DIR/

# Get rid of useless files
find $BUILD_DIR -name "ubuntu-*-cloudimg-console.log" -exec rm -f {} \;
rm -f $BUILD_DIR/config/installer-scenarios.d/last_scenario.yaml

# Ensure that populated answer files do not get pulled in into the packages
for ANSWER_FILE in `ls ../config/installer-scenarios.d/*-answers.yaml`; do
    BASENAME=`basename $ANSWER_FILE`
    git show HEAD:$ANSWER_FILE > $BUILD_DIR/config/installer-scenarios.d/$BASENAME
done

# Remove broken symbolic link to puppetmaster module, so that the files are
# copied there correctlyi
rm -f $BUILD_DIR/modules/puppetmaster
mkdir $PUPPETMASTER_MODULE_DIR
cp -r ../manifests ../files ../templates ../metadata.json ../LICENSE ../README.md $PUPPETMASTER_MODULE_DIR

echo "Removing .yardoc directories"
find $BUILD_DIR -type d -name ".yardoc"|xargs rm -rf

echo "Producing packages with fpm"
FPM_COMMON_OPTS="-C ./build -x modules/*/.git --force --prefix /usr/share/puppetmaster-installer --name puppetmaster-installer --version ${VERSION} --iteration ${ITERATION} --license ${LICENSE} --vendor \"${VENDOR}\" --maintainer \"<${MAINTAINER}>\" --url \"${URL}\" -s dir ."

echo "  Producing RPM package"
fpm -t rpm $FPM_COMMON_OPTS

echo "  Removing scenarios not yet supported on Ubuntu/Debian"
rm -f $BUILD_DIR/config/installer-scenarios.d/lcm.yaml
rm -f $BUILD_DIR/config/installer-scenarios.d/foreman-proxy.yaml

echo "  Producing Debian package"
fpm -t deb $FPM_COMMON_OPTS

