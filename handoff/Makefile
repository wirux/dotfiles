PREFIX ?= $(HOME)/.local
HIDAPI ?= /opt/homebrew/opt/hidapi

mxbolt: mxbolt.c
	clang -O2 -o $@ $< -I$(HIDAPI)/include -L$(HIDAPI)/lib -lhidapi

install: mxbolt
	install -d $(PREFIX)/bin
	install -m 755 mxbolt $(PREFIX)/bin/mxbolt

clean:
	rm -f mxbolt

.PHONY: install clean
