#!/bin/sh

# Usage: pkg-update-support
# Updates the package independent support files in the pkg/ directory. Invoke
# from the root directory of the project.

set -e
LOC=`pwd`

if [ ! -f "$LOC/pkg/config" ]; then
    echo "The file \`$LOC/pkg/config' does not exist."
    exit 1
fi

. $LOC/pkg/config

if [ "`git status --porcelain`" != "" ]; then 
    echo "The repository is dirty. Commit or stash your changes." 
    exit 1
fi

SRC=${SRC:=$HOME/sync/repos/pkgopkg}

cp $SRC/pkg/* $LOC/pkg/

if [ -f $LOC/pkg/jsoo-build ]; then
    cp $SRC/jsoo/jsoo-build $LOC/pkg/jsoo-build
fi

git commit -a
