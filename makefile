CC = gcc
CFLAGS = -g -Wall -std=c17 -O3 -fPIC -fPIE
SOVERSION = 0

prefix = /usr/local
bindir = $(prefix)/bin
includedir = $(prefix)/include
libdir = $(prefix)/lib

all: lib getval.out

lib: libbesic.so libbesic.a


.PHONY: test
test: test.out
	LD_LIBRARY_PATH="$$LD_LIBRARY_PATH:." ./test.out


install: all
	install -m 0755 -d $(DESTDIR)$(includedir)
	install -m 0644 besic.h $(DESTDIR)$(includedir)
	install -m 0755 -d $(DESTDIR)$(libdir)
	install -m 0755 libbesic.so $(DESTDIR)$(libdir)/libbesic.so.$(SOVERSION)
	cd $(DESTDIR)$(libdir) && ln -fs libbesic.so.$(SOVERSION) libbesic.so
	install -m 0755 -d $(DESTDIR)$(bindir)
	install -m 0755 getval.out $(DESTDIR)$(bindir)/besic-getval
	# man

getval.out: getval.c libbesic.so
	$(CC) $(CFLAGS) -pie $^ -o $@

test.out: test.c libbesic.so
	$(CC) $(CFLAGS) -pie $^ -o $@

libbesic.so: besic.o
	$(CC) $(CFLAGS) -shared -Wl,-soname,$@.$(SOVERSION) $^ -o $@
	ln -fs $@ $@.$(SOVERSION)

libbesic.a: besic.o
	$(AR) rcs $@ $^

besic.o: besic.c besic.h


clean:
	rm -f *.o *.out *.so *.so.* *.a