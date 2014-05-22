CC=gcc
CFLAGS=-O3 -std=c99 -lexpat
RPYTHON ?= rpython

.PHONY: all clean
all: publicfeed.huge.xml expat rpython

clean:
	rm -f publicfeed.pretty.xml publicfeed.raw.xml publicfeed.huge.xml \
		expat rpython hexpat

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

hexpat: get_producturl.hs
	ghc -O3 $< -o $@
	rm *.hi *.o
