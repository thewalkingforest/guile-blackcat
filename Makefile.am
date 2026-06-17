ACLOCAL_AMFLAGS = -I m4

guilemoduledir = $(prefix)/share/guile/site/$(GUILE_EFFECTIVE_VERSION)
guileccachedir = $(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache

nobase_dist_guilemodule_DATA = \
  blackcat.scm \
  blackcat/config.scm \
  blackcat/inotify.scm \
  blackcat/utils.scm \
  blackcat/watch.scm \
  blackcat/shepherd.scm \
  blackcat/shepherd/utils.scm \
  blackcat/shepherd/services.scm \
  blackcat/shepherd/services/core.scm \
  blackcat/scripts/autoload.scm \
  blackcat/scripts/reload.scm \
  blackcat/scripts/hello.scm

TAGS_FILES = $(nobase_dist_guilemodule_DATA)

GOBJECTS = $(nobase_dist_guilemodule_DATA:.scm=.go)

nobase_guileccache_DATA = $(GOBJECTS)

GUILE_WARNINGS = -W3

%.go: %.scm
	$(AM_V_GEN)GUILE_LOAD_COMPILED_PATH=. \
	  $(GUILD) compile $(GUILE_WARNINGS) -L $(srcdir) -o $@ $<

# Inter-module dependencies (mirrors the existing Makefile).
blackcat.go: blackcat/config.go
blackcat/scripts/autoload.go: blackcat/shepherd/services.go blackcat/watch.go
blackcat/scripts/reload.go: blackcat/shepherd/services.go blackcat/watch.go
blackcat/shepherd.go: blackcat/shepherd/services.go
blackcat/shepherd/utils.go: blackcat/utils.go
blackcat/utils.go: blackcat/config.go
blackcat/watch.go: blackcat/inotify.go

if HAVE_USAGE
USAGE_RELOAD=docs-src/usage-reload.kdl

COMPLETIONS_DIR=docs/completions
COMPLETION_SHELLS = bash fish zsh nu
COMPLETIONS = $(COMPLETION_SHELLS:%=$(COMPLETIONS_DIR)/reload.%)

MAN_PAGES_DIR=docs/man
MAN_PAGES=docs/man/reload.1

$(COMPLETIONS_DIR) $(MAN_PAGES_DIR):
	mkdir -p $@

$(COMPLETIONS_DIR)/reload.%: $(USAGE_RELOAD) $(COMPLETIONS_DIR)
	$(USAGE) generate completion -f $< $* reload > $@

$(MAN_PAGES_DIR)/reload.1: $(USAGE_RELOAD) $(MAN_PAGES_DIR)
	$(USAGE) generate manpage -f $< -o $@

else
COMPLETIONS=
MAN_PAGES=
endif

all-local: $(GOBJECTS) $(COMPLETIONS) $(MAN_PAGES)
CLEANFILES = $(GOBJECTS) $(COMPLETIONS) $(MAN_PAGES)

# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

RUNTEST ?= runtest

check-local: check-modules check-dejagnu

check-modules:
	$(GUILE) -L $(srcdir) -c \
	  "(use-modules (blackcat config)) (display %blackcat-version) (newline)"
	$(GUILE) -L $(srcdir) -c "(use-modules (blackcat utils))"
	$(GUILE) -L $(srcdir) -c "(use-modules (blackcat shepherd utils))"

check-dejagnu:
	GUILE=$(GUILE) $(RUNTEST) --tool blackcat --srcdir $(abs_srcdir)/testsuite

.PHONY: check-modules check-dejagnu
