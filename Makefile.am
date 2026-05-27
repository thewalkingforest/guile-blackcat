ACLOCAL_AMFLAGS = -I m4

# Install paths follow the configured prefix/libdir, not pkg-config system dirs.
guilemoduledir = $(datadir)/guile/site/$(GUILE_EFFECTIVE_VERSION)
guileccachedir = $(libdir)/guile/$(GUILE_EFFECTIVE_VERSION)/site-ccache

# Source .scm files — distributed and installed preserving subdirectory structure.
nobase_dist_guilemodule_DATA = \
  blackcat.scm \
  blackcat/config.scm \
  blackcat/inotify.scm \
  blackcat/utils.scm \
  blackcat/watch.scm \
  blackcat/shepherd.scm \
  blackcat/shepherd/defaults.scm \
  blackcat/shepherd/utils.scm \
  blackcat/shepherd/services.scm \
  blackcat/shepherd/services/core.scm \
  blackcat/shepherd/services/desktop.scm \
  blackcat/shepherd/services/network.scm \
  blackcat/shepherd/services/session.scm \
  blackcat/shepherd/services/system.scm \
  blackcat/scripts/autoload.scm \
  blackcat/scripts/hello.scm

# Compiled .go bytecode objects — installed to the site-ccache tree.
GOBJECTS = $(nobase_dist_guilemodule_DATA:.scm=.go)

nobase_guileccache_DATA = $(GOBJECTS)

GUILE_WARNINGS = -Wunbound-variable -Warity-mismatch -Wformat

# GNU Make pattern rule: compile each .scm to a .go in the build directory.
# GUILE_LOAD_COMPILED_PATH=. lets guild find already-built deps in the build dir.
%.go: %.scm
	$(AM_V_GEN)GUILE_LOAD_COMPILED_PATH=. \
	  $(GUILD) compile $(GUILE_WARNINGS) -L $(srcdir) -o $@ $<

# Inter-module dependencies (mirrors the existing Makefile).
blackcat.go: blackcat/config.go
blackcat/scripts/autoload.go: blackcat/shepherd/defaults.go blackcat/watch.go
blackcat/shepherd.go: blackcat/shepherd/defaults.go
blackcat/shepherd/services.go: blackcat/shepherd/defaults.go
blackcat/shepherd/utils.go: blackcat/utils.go
blackcat/utils.go: blackcat/config.go
blackcat/watch.go: blackcat/inotify.go

all-local: $(GOBJECTS)
CLEANFILES = $(GOBJECTS)

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
