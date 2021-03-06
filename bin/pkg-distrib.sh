#!/bin/sh

# Usage: pkg-distrib 
# Make a distribution tarball in /tmp. Invoke from the root directory
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

PKGDIR=$NAME-$VERSION
CLONEDIR=${CLONEDIR:="/tmp/$PKGDIR"}

OCAMLBUILD=${OCAMLBUILD:="ocamlbuild -classic-display -use-ocamlfind"}
TAR=${TAR:="tar"}

# Start from a checkout of master
git clone -b master . $CLONEDIR
cd $CLONEDIR

# Substitute a few things
. pkg/pkg-varsubsts

if [ -f pkg/hook-pkg-distrib-pre-build ]; then
    . pkg/hook-pkg-distrib-pre-build
fi

# Remove dev artefacts
rm -R -f .git .gitignore build $DEV_BUILD_ARTEFACTS

# Generate static API doc (if any)
if [ -f doc/api.odocl ]; then 
  pkg-doc doc/api.docdir
  cp _build/doc/api.docdir/*.html doc/
fi

# Build tests 
if [ -f test/tests.itarget ]; then
    $OCAMLBUILD test/tests.otarget
fi

if [ -f pkg/hook-pkg-distrib-post-build ]; then
    . pkg/hook-pkg-distrib-post-build
fi

# Cleanup any mess
$OCAMLBUILD -clean

rm -f pkg/hook-pkg-distrib-pre-build
rm -f pkg/hook-pkg-distrib-post-build

# Make tarball
cd ..
$TAR -cvjf $PKGDIR.tbz $PKGDIR
rm -R $PKGDIR
rm -R -f $CLONEDIR
