#!/usr/bin/make

all: build switch remove move remove1 add

build: 
	foundation build

switch:
	git checkout master

remove:
	rm -r assets blog

move:
	mkdir assets; mkdir blog; \
		mv dist/index.html .; \
		mv dist/blog.html .; \
		mv dist/blog/*.html blog/.; \
		mv dist/assets/* assets/.; \
		rm -r dist

remove1:
	sed -i '1d' index.html

add:
	git add index.html blog.html blog/* assets/*
