#!/bin/sh

# Usage: pkg-www-release
# Publishes the tarball in /tmp on the www with webglue. Invoke from the 
# root directory of the project.

WEBGLUE=${WEBGLUE:="webglue"}
TAR=${TAR:="tar"}

set -e
LOC=`pwd`

if [ ! -f "$LOC/pkg/config" ]
then
    echo "The file \`$LOC/pkg/config' does not exist."
    exit 1
fi

. $LOC/pkg/config

WWWROOT=${WWWROOT:="$HOME/sync/erratique"}
PKGWWWROOT=${PKGWWWROOT:="$WWWROOT/maps/software/$NAME"}

PKGDIR=$NAME-$VERSION
ARCHIVE=/tmp/$PKGDIR.tbz

# Add the release tarball 
cp $ARCHIVE $PKGWWWROOT/releases/

# Update the doc
rm -R $PKGWWWROOT/doc
$TAR -C $PKGWWWROOT --strip-components=1 -xvjf $ARCHIVE $PKGDIR/doc

# Update the demos
if [ "$WWWDEMOS" != "" ]
then
    pkg-www-demos
fi

# Update the webpage
cd $WWWROOT
echo "$VERSION" | $WEBGLUE set --replace $NAME s-last-version
$WEBGLUE get timestamp utc | $WEBGLUE set --replace $NAME s-updated

if [ -f $LOC/pkg-www-release-hook ]; then
    . $LOC/pkg-www-release-hook
fi
