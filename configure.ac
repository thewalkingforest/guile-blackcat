AC_INIT([guile-blackcat], [0.1.0])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([-Wall -Wno-portability foreign])
AM_SILENT_RULES([yes])

dnl Require Guile 3.0 and locate the guile/guild binaries + effective version.
GUILE_PKG([3.0])
GUILE_PROGS

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
