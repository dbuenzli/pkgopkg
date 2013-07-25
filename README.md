pkgopkg — Tools for distributing OCaml software on erratique.ch
-------------------------------------------------------------------------------

Ad-hoc tools to develop and distribute OCaml software.

## Installation

This repo is both an opam repo and an opam package. To install:

    opam repo add pkgopkg http://erratique.ch/repos/pkgopkg.git
    opam update 
    opam install pkgopkg
    
The installed tools are described in the `bin` section below.

## bin

These tool must be invoked in the root directory of a project.


* [`pkg-doc`](bin/pkg-doc) generate the documentation of package. 
* [`reload-browser`](bin/reload-browser) reload an URI in a browser
  tab.
* [`pkg-update-support`](bin/pkg-update-support) update the package
  independent support file in the `pkg` of a project.
* [`pkg-distrib`](bin/pkg-distrib) make a distribution tarball in
  `/tmp`.
* [`pkg-www-release`](bin/pkg-www-release) publish the distribution
  tarball created by `pkg-distrib` on erratique.ch.
* [`pkg-www-doc`](bin/pkg-www-demos) publish the documentation 
  of the project on erratique.ch.
* [`pkg-www-demos`](bin/pkg-www-demos) publish the jsoo demos of the
  project on erratique.ch.

## pkg

To packagify a project.

1. Copy `pkg` directory to root directory of the distribution. 
2. Add `pkg/config` with at least `$NAME`, `$VERSION` and `$MAINTAINER`. E.g.

   ```
   NAME=example
   VERSION=`git describe master | sed "s/^.//"`
   MAINTAINER="Daniel Bünzli <daniel.buenzl i\\\@erratique.ch>"
   ```
3. Add `pkg/META` describing the library.
4. Add `pkg/build` describing what to install using 
   [pkg-builder](pkg/pkg-builder)
5. Add an `opam` file describing the library.

## jsoo

* [jsoo/jsoo-build](jsoo/jsoo-build) simple `js_of_ocaml` project
  builder.
