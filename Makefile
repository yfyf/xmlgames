CC=gcc
CFLAGS=-O3 -std=c99 -lexpat
RPYTHON ?= rpython
RUSTC?=rustc
GO=go

.PHONY: all clean
all: publicfeed.huge.xml expat rpython

clean:
	rm -f publicfeed.pretty.xml publicfeed.raw.xml publicfeed.huge.xml \
		expat rpython hexpat get_producturl_rs get_product_url_go

URL=http://produktfeed.getaccess.dk/feeds/publicfeed

publicfeed.pretty.xml:
	curl $(URL) | xmllint --format - > $@

.INTERMEDIATE: publicfeed.raw.xml
publicfeed.raw.xml: publicfeed.pretty.xml
	sed -e '1,2d; $$d' $< > $@

publicfeed.huge.xml: publicfeed.raw.xml
	echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	echo ' <Products>' >> $@
	for i in `seq 1 90`; do \
		cat publicfeed.raw.xml >> $@; \
	done
	echo '</Products>' >> $@

expat: expat.c
	$(CC) $(CFLAGS) expat.c -o $@

rpython: get_producturl.py
	$(RPYTHON) $<
	mv get_producturl-c $@

go: get_producturl.go
	$(GO) build -o get_producturl_go $<

hexpat: get_producturl.hs
	ghc -O3 $< -o $@
	rm *.hi *.o

rust: get_producturl_rs
get_producturl_rs: get_producturl.rs
	$(RUSTC) -O -o $@ $<
