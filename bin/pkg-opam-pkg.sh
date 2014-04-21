#!/bin/sh

# Usage: pkg-opam-pkg [DIR]
# Makes in DIR (defaults to /tmp) a package for the tarball in /tmp. Invoke 
# from the root directory the project.

set -e
LOC=`pwd`
DIR=$1

if [ ! -f "$LOC/pkg/config" ]
then
    echo "The file \`$LOC/pkg/config' does not exist."
    exit 1
fi

. $LOC/pkg/config

if [ ! -d "$DIR" ]
then
    DIR=/tmp
fi

HTTPROOT=${HTTPROOT:="http://erratique.ch/software"}
PKGARCHIVE=$NAME-$VERSION.tbz
PKGHTTP=$HTTPROOT/$NAME/releases/$PKGARCHIVE

CHECKSUM=`md5sum /tmp/$PKGARCHIVE | cut -d" " -f 1`
if [ "$CHECKSUM" == "" ]
then 
    echo "Could not checksum archive /tmp/$PKGARCHIVE."
    exit 1
fi

DST=$DIR/$NAME.$VERSION
mkdir $DST
pkg-opam-descr > $DST/descr
cp opam $DST/
cat > $DST/url <<EOF
archive: "$PKGHTTP"
checksum: "$CHECKSUM"
EOF
