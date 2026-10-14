PREFIX ?= $(HOME)/.local
HIDAPI ?= /opt/homebrew/opt/hidapi

mxbolt: mxbolt.c
	clang -O2 -o $@ $< -I$(HIDAPI)/include -L$(HIDAPI)/lib -lhidapi

install: mxbolt install-mon
	install -d $(PREFIX)/bin
	install -m 755 mxbolt $(PREFIX)/bin/mxbolt

# Separate from install: mon needs no compiler and no hidapi, so a machine that
# only drives monitors can skip building mxbolt entirely.
install-mon:
	install -d $(PREFIX)/bin
	install -m 755 bin/mon $(PREFIX)/bin/mon

clean:
	rm -f mxbolt

.PHONY: install install-mon clean
