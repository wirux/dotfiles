PREFIX ?= $(HOME)/.local
HIDAPI ?= /opt/homebrew/opt/hidapi

mxbolt: mxbolt.c
	clang -O2 -o $@ $< -I$(HIDAPI)/include -L$(HIDAPI)/lib -lhidapi

# Only mxbolt is installed: it has to be compiled, so it cannot be run from
# where it lives. bin/mon is a script and is run straight out of this repo.
install: mxbolt
	install -d $(PREFIX)/bin
	install -m 755 mxbolt $(PREFIX)/bin/mxbolt

clean:
	rm -f mxbolt

.PHONY: install clean
