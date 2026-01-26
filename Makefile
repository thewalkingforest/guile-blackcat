GUILE ?= guile
GUILD ?= guild

PREFIX ?= /usr/local
datarootdir ?= $(PREFIX)/share
libdir ?= $(PREFIX)/lib

GUILE_SITE ?= $(datarootdir)/guile/site/3.0
GUILE_OBJ_DIR ?= $(libdir)/guile/site/3.0/site-ccache

SOURCES = \
	blackcat/config.scm \
	blackcat/utils.scm \
	blackcat/shepherd-utils.scm \
	blackcat.scm

GOBJECTS = $(SOURCES:.scm=.go)

GUILE_WARNINGS = -Wunbound-variable -Warity-mismatch -Wformat
GUILD_FLAGS = $(GUILE_WARNINGS) -L .

.PHONY: all clean install uninstall

all: $(GOBJECTS)

blackcat/config.go: blackcat/config.scm
	$(GUILD) compile $(GUILD_FLAGS) -o $@ $<

blackcat/utils.go: blackcat/utils.scm blackcat/config.go
	$(GUILD) compile $(GUILD_FLAGS) -o $@ $<

blackcat/shepherd-utils.go: blackcat/shepherd-utils.scm blackcat/utils.go
	$(GUILD) compile $(GUILD_FLAGS) -o $@ $<

blackcat.go: blackcat.scm blackcat/config.go blackcat/shepherd-utils.go
	$(GUILD) compile $(GUILD_FLAGS) -o $@ $<

clean:
	rm -f $(GOBJECTS)

install: all
	@echo "Installing Guile source files to $(GUILE_SITE)"
	install -d $(GUILE_SITE)
	install -d $(GUILE_SITE)/blackcat
	install -m 644 blackcat.scm $(GUILE_SITE)/
	install -m 644 blackcat/config.scm $(GUILE_SITE)/blackcat/
	install -m 644 blackcat/utils.scm $(GUILE_SITE)/blackcat/
	install -m 644 blackcat/shepherd-utils.scm $(GUILE_SITE)/blackcat/
	@echo "Installing compiled files to $(GUILE_OBJ_DIR)"
	install -d $(GUILE_OBJ_DIR)
	install -d $(GUILE_OBJ_DIR)/blackcat
	install -m 644 blackcat.go $(GUILE_OBJ_DIR)/
	install -m 644 blackcat/config.go $(GUILE_OBJ_DIR)/blackcat/
	install -m 644 blackcat/utils.go $(GUILE_OBJ_DIR)/blackcat/
	install -m 644 blackcat/shepherd-utils.go $(GUILE_OBJ_DIR)/blackcat/

uninstall:
	rm -f $(GUILE_SITE)/blackcat.scm
	rm -f $(GUILE_SITE)/blackcat/config.scm
	rm -f $(GUILE_SITE)/blackcat/utils.scm
	rm -f $(GUILE_SITE)/blackcat/shepherd-utils.scm
	rm -f $(GUILE_OBJ_DIR)/blackcat.go
	rm -f $(GUILE_OBJ_DIR)/blackcat/config.go
	rm -f $(GUILE_OBJ_DIR)/blackcat/utils.go
	rm -f $(GUILE_OBJ_DIR)/blackcat/shepherd-utils.go
	-rmdir $(GUILE_SITE)/blackcat
	-rmdir $(GUILE_OBJ_DIR)/blackcat

check:
	$(GUILE) -L . -c "(use-modules (blackcat config)) (display %blackcat-version) (newline)"
	$(GUILE) -L . -c "(use-modules (blackcat utils))"
	$(GUILE) -L . -c "(use-modules (blackcat shepherd-utils))"
