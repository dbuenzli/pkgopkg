#!/bin/sh

# Usage: pkg-www-doc
# Publishes the project's api docs on the www. Invoke from the root directory
# of the project.

set -e
LOC=`pwd`
ORIGINALREPO=`pwd`

if [ ! -f "$LOC/pkg/config" ]
then
    echo "The file \`$LOC/pkg/config' does not exist."
    exit 1
fi

. $LOC/pkg/config

PKGWWWROOT=${PKGWWWROOT:="$HOME/sync/erratique/maps/software/$NAME"}
CLONEDIR=${CLONEDIR:="/tmp/$NAME-$VERSION"}
BUILDDIR=${BUILDDIR:="_build"}

git clone -b master . $CLONEDIR
cd $CLONEDIR

. pkg/pkg-varsubsts

if [ -f pkg/hook-pkg-www-doc-pre ]; then
    . pkg/hook-pkg-www-doc-pre
fi

if [ ! -f doc/api.odocl ]; then 
    echo "The file \`$CLONEDIR/doc/api.docdir' does not exist."
    exit 1
fi
  
pkg-doc doc/api.docdir
cp $BUILDDIR/doc/api.docdir/* $PKGWWWROOT/doc/

rm -R -f $CLONEDIR
