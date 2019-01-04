#!/usr/bin/env bash

export BOOK_PATH=$HOME/code/pydata-book-source

function book_sync {
	pushd $BOOK_PATH
	git pull --ff-only
	git submodule foreach git pull --ff-only origin master
	popd
}
