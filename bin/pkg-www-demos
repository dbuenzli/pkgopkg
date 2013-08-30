#!/bin/sh

# Usage: pkg-www-demos
# Publishes the project's demos on the www. Invoke from the root directory
# of the project.

set -e
LOC=`pwd`

if [ ! -f "$LOC/pkg/config" ]
then
    echo "The file \`$LOC/pkg/config' does not exist."
    exit 1
fi

. $LOC/pkg/config

if [ "$WWWDEMOS" = "" ]
then
    echo "No \$WWWDEMOS variable found in $LOC/pkg/config"
    exit 1
fi

PKGWWWROOT=${PKGWWWROOT:="$HOME/sync/erratique/maps/software/$NAME"}
CLONEDIR=${CLONEDIR:="/tmp/$NAME-$VERSION"}
BUILDDIR=${BUILDDIR:="_build"}

git clone -b master . $CLONEDIR
cd $CLONEDIR

. pkg/pkg-varsubsts

for D in $WWWDEMOS; do
    ./build $D
    cp $BUILDDIR/test/$D.html $BUILDDIR/test/$D.js $PKGWWWROOT/demos/
done

rm -R -f $CLONEDIR

