#!/usr/bin/make

#all: remove fnd 
all: fnd move add

remove:
	git rm -r docs

fnd: 
	foundation build

move:
	mv dist docs

add:
	git add docs
