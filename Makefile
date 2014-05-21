CC=gcc
CFLAGS=-O3 -std=c99 -lexpat

.PHONY: all clean
all: publicfeed.huge.xml expat

clean:
	rm -f publicfeed.pretty.xml publicfeed.raw.xml publicfeed.huge.xml expat

URL=http://produktfeed.getaccess.dk/feeds/publicfeed

publicfeed.pretty.xml:
	curl $(URL) | xmllint --format - > $@

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
