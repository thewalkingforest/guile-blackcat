GUILE ?= guile
GUILD ?= guild

DESTDIR =
PREFIX ?= /usr/local
datarootdir ?= $(DESTDIR)$(PREFIX)/share
libdir ?= $(DESTDIR)$(PREFIX)/lib

GUILE_EFFECTIVE_VERSION ?= $(shell $(GUILE) -c "(display (effective-version))")
GUILE_SITE ?= $(datarootdir)/guile/site/$(GUILE_EFFECTIVE_VERSION)
GUILE_OBJ_DIR ?= $(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache

SOURCES := blackcat.scm $(shell find blackcat -name '*.scm' | sort)
GOBJECTS = $(SOURCES:.scm=.go)

GUILE_WARNINGS = -Wunbound-variable -Warity-mismatch -Wformat
GUILD_FLAGS = $(GUILE_WARNINGS) -L .

.PHONY: all clean install uninstall check

all: $(GOBJECTS)

blackcat.go: blackcat/config.go
blackcat/scripts/autoload.go: blackcat/shepherd/defaults.go blackcat/watch.go
blackcat/shepherd.go: blackcat/shepherd/defaults.go
blackcat/shepherd/utils.go: blackcat/utils.go
blackcat/utils.go: blackcat/config.go
blackcat/watch.go: blackcat/inotify.go

%.go: %.scm
	GUILE_LOAD_COMPILED_PATH=. $(GUILD) compile $(GUILD_FLAGS) -o $@ $<

clean:
	rm -f $(GOBJECTS)

install: $(GOBJECTS)
	@echo "Installing Guile source files to $(GUILE_SITE)"
	@for f in $(SOURCES); do \
		install -Dm644 $$f $(GUILE_SITE)/$$f; \
	done
	@echo "Installing compiled files to $(GUILE_OBJ_DIR)"
	@for f in $(GOBJECTS); do \
		install -Dm644 $$f $(GUILE_OBJ_DIR)/$$f; \
	done

uninstall:
	@for f in $(SOURCES); do rm -f $(GUILE_SITE)/$$f; done
	@for f in $(GOBJECTS); do rm -f $(GUILE_OBJ_DIR)/$$f; done
	-find $(GUILE_SITE)/blackcat $(GUILE_OBJ_DIR)/blackcat \
		-depth -type d -empty -delete 2>/dev/null

check:
	$(GUILE) -L . -c "(use-modules (blackcat config)) (display %blackcat-version) (newline)"
	$(GUILE) -L . -c "(use-modules (blackcat utils))"
	$(GUILE) -L . -c "(use-modules (blackcat shepherd utils))"
