GUILE ?= guile
GUILD ?= guild

DESTDIR=
PREFIX ?= /usr/local
datarootdir ?= $(DESTDIR)$(PREFIX)/share
libdir ?= $(DESTDIR)$(PREFIX)/lib

GUILE_SITE ?= $(datarootdir)/guile/site/3.0
GUILE_OBJ_DIR ?= $(libdir)/guile/3.0/site-ccache

SOURCES = \
	blackcat.scm \
	blackcat/config.scm \
	blackcat/inotify.scm \
	blackcat/shepherd.scm \
	blackcat/shepherd/defaults.scm \
	blackcat/shepherd/utils.scm \
	blackcat/utils.scm \
	blackcat/watch.scm

GOBJECTS = $(SOURCES:.scm=.go)

GUILE_WARNINGS = -Wunbound-variable -Warity-mismatch -Wformat
GUILD_FLAGS = $(GUILE_WARNINGS) -L .

.PHONY: all clean install uninstall check

all: $(GOBJECTS)

blackcat.go: blackcat/config.go
blackcat/shepherd.go: blackcat/shepherd/defaults.go
blackcat/shepherd/utils.go: blackcat/utils.go
blackcat/utils.go: blackcat/config.go
blackcat/watch.go: blackcat/inotify.go

%.go: %.scm
	GUILE_LOAD_COMPILED_PATH=. $(GUILD) compile $(GUILD_FLAGS) -o $@ $<

clean:
	rm -f $(GOBJECTS)

install:
	@echo "Installing Guile source files to $(GUILE_SITE)"
	install -d $(GUILE_SITE)
	install -m 644 blackcat.scm $(GUILE_SITE)/
	install -d $(GUILE_SITE)/blackcat
	install -m 644 blackcat/config.scm $(GUILE_SITE)/blackcat/
	install -m 644 blackcat/shepherd.scm $(GUILE_SITE)/blackcat/
	install -m 644 blackcat/utils.scm $(GUILE_SITE)/blackcat/
	install -m 644 blackcat/inotify.scm $(GUILE_SITE)/blackcat/
	install -m 644 blackcat/watch.scm $(GUILE_SITE)/blackcat/
	install -d $(GUILE_SITE)/blackcat/shepherd
	install -m 644 blackcat/shepherd/utils.scm $(GUILE_SITE)/blackcat/shepherd
	install -m 644 blackcat/shepherd/defaults.scm $(GUILE_SITE)/blackcat/shepherd
	@echo "Installing compiled files to $(GUILE_OBJ_DIR)"
	install -d $(GUILE_OBJ_DIR)
	install -m 644 blackcat.go $(GUILE_OBJ_DIR)/
	install -d $(GUILE_OBJ_DIR)/blackcat
	install -m 644 blackcat/config.go $(GUILE_OBJ_DIR)/blackcat/
	install -m 644 blackcat/shepherd.go $(GUILE_OBJ_DIR)/blackcat/
	install -m 644 blackcat/utils.go $(GUILE_OBJ_DIR)/blackcat/
	install -m 644 blackcat/inotify.go $(GUILE_OBJ_DIR)/blackcat/
	install -m 644 blackcat/watch.go $(GUILE_OBJ_DIR)/blackcat/
	install -d $(GUILE_OBJ_DIR)/blackcat/shepherd
	install -m 644 blackcat/shepherd/utils.go $(GUILE_OBJ_DIR)/blackcat/shepherd/
	install -m 644 blackcat/shepherd/defaults.go $(GUILE_OBJ_DIR)/blackcat/shepherd/

uninstall:
	rm -f $(GUILE_SITE)/blackcat.scm
	rm -f $(GUILE_SITE)/blackcat/config.scm
	rm -f $(GUILE_SITE)/blackcat/utils.scm
	rm -f $(GUILE_SITE)/blackcat/shepherd.scm
	rm -f $(GUILE_SITE)/blackcat/shepherd/utils.scm
	rm -f $(GUILE_SITE)/blackcat/shepherd/defaults.scm
	rm -f $(GUILE_OBJ_DIR)/blackcat.go
	rm -f $(GUILE_OBJ_DIR)/blackcat/config.go
	rm -f $(GUILE_OBJ_DIR)/blackcat/utils.go
	rm -f $(GUILE_OBJ_DIR)/blackcat/inotify.go
	rm -f $(GUILE_OBJ_DIR)/blackcat/watch.go
	rm -f $(GUILE_OBJ_DIR)/blackcat/shepherd.go
	rm -f $(GUILE_OBJ_DIR)/blackcat/shepherd/utils.go
	rm -f $(GUILE_SITE)/blackcat/shepherd/defaults.go
	-rmdir $(GUILE_SITE)/blackcat
	-rmdir $(GUILE_SITE)/blackcat/shepherd
	-rmdir $(GUILE_OBJ_DIR)/blackcat
	-rmdir $(GUILE_OBJ_DIR)/blackcat/shepherd

check:
	$(GUILE) -L . -c "(use-modules (blackcat config)) (display %blackcat-version) (newline)"
	$(GUILE) -L . -c "(use-modules (blackcat utils))"
	$(GUILE) -L . -c "(use-modules (blackcat shepherd utils))"
