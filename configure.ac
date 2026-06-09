AC_INIT([guile-blackcat], [0.1.0])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([-Wall -Wno-portability foreign])
AM_SILENT_RULES([yes])

dnl Require Guile 3.0 and locate the guile/guild binaries + effective version.
GUILE_PKG([3.0])
GUILE_PROGS

dnl Check if the `usage` command is available
AC_PATH_PROG([USAGE], [usage])
AM_CONDITIONAL([HAVE_USAGE], [test -n "$usage"])

dnl Require the GNU Shepherd Guile library.
GUILE_MODULE_REQUIRED([shepherd])

dnl Require the mkusage library
GUILE_MODULE_REQUIRED([mkusage])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
