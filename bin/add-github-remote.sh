#!/bin/sh

set -ex

if [ $# -ne 1 ] ; then
    echo "Need one argument"
    exit 1
fi

git remote add $1 https://github.com/$1/arrow.git
git remote set-url --push $1 git@github.com:$1/arrow.git
