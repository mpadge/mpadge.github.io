#!/usr/bin/make

all: build switch remove move add

build: 
	foundation build

swtich:
	git checkout master

remove:
	git rm -r assets blog

move:
	mkdir assets; mkdir blog; \
		mv dist/index.html index.html; \
		mv dist/blog.html .; \
		mv dist/blog/*.html blog/. \
		mv dist/assets/* assets/. \
		rm -r dist

add:
	git add index.html blog.html blog/* assets/*

