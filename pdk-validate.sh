#!/bin/sh
#
# Wrapper around "pdk validate" to prevent lots of false positives from
# dependency modules that are littered all around this project.
#
grep "\"name\": \"puppetfinland-puppetmaster\"," metadata.json > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "ERROR: run this script from the root of the repository!"
  exit 1
fi

# Create a temporary directory
TEMPDIR="/tmp/puppetmaster-installer"

if [ -d "$TEMPDIR" ]; then
    echo "NOTE: /tmp/puppetmaster-installer directory exits already."
    echo
    echo "Do you wish to restore modules from there after validation (Y/n)?"
    read yn
    if [ "$yn" = "n" ]; then
      rm -rf $TEMPDIR
    fi
fi

mkdir -p $TEMPDIR

# Move offending directories away
test -d modules && mv modules $TEMPDIR
test -d spec/fixtures && mkdir $TEMPDIR/spec && mv spec/fixtures $TEMPDIR/spec
test -d packaging/build && mkdir $TEMPDIR/packaging && mv packaging/build $TEMPDIR/packaging

# Validate
pdk validate

# Move offending directories back
test -d $TEMPDIR/modules && mv $TEMPDIR/modules .
test -d $TEMPDIR/spec/fixtures && mv $TEMPDIR/spec/fixtures spec && rm -rf $TEMPDIR/spec
test -d $TEMPDIR/packaging/build && mv $TEMPDIR/packaging/build packaging && rm -rf $TEMPDIR/packaging

rm -rf $TEMPDIR
