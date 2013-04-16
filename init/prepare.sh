#!/bin/bash

set -x 
set -e

if [ -z "$SOURCE_DIR" ] ; then
    echo "Expected SOURCE_DIR in environment"
    exit 1
fi
if [ -z "$BUILD_DIR" ] ; then
    echo "Expected BIULD_DIR in environment"
    exit 1
fi

if test -d $BUILD_DIR ; then
    rm -rf $BUILD_DIR/*
fi

GO_VERSION=go1.0.3.linux-386.tar.gz

[ -f $GO_VERSION ] || curl -O https://go.googlecode.com/files/$GO_VERSION
[ -d go ] || tar xzf $GO_VERSION

export GOROOT=$SOURCE_DIR/go
export GOPATH=$SOURCE_DIR/m-lab.pipeline/standalone
PATH=$SOURCE_DIR/go/bin:$PATH
go get github.com/gorilla/mux
go build pipeline

install -D -m 0755 $SOURCE_DIR/pipeline $BUILD_DIR/pipeline
install -D -m 0755 $SOURCE_DIR/m-lab.pipeline/standalone/start.sh $BUILD_DIR/init/start.sh
install -D -m 0755 $SOURCE_DIR/m-lab.pipeline/standalone/stop.sh $BUILD_DIR/init/stop.sh
