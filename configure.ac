# configure.ac

AC_INIT([unity-lens-tomboy],[0.1])
AC_CONFIG_SRCDIR([src])
AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([no-dist-gzip dist-bzip2])

# Enable silent rules is available
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AM_MAINTAINER_MODE

AC_PROG_CC
AC_PROG_CC_STDC
AM_PROG_VALAC([0.7.0])
AC_PROG_INSTALL
IT_PROG_INTLTOOL([0.35])

pkg_modules="glib-2.0 >= 2.26 unity >= 4.0.0"
LENS_DAEMON_PACKAGES="--pkg glib-2.0 --pkg unity"
PKG_CHECK_MODULES(LENS_DAEMON, [$pkg_modules])
AC_SUBST(LENS_DAEMON_CFLAGS)
AC_SUBST(LENS_DAEMON_LIBS)
AC_SUBST(LENS_DAEMON_PACKAGES)

GETTEXT_PACKAGE="$PACKAGE"
AC_SUBST(GETTEXT_PACKAGE)
AC_SUBST([CONFIG_STATUS_DEPENDENCIES],['$(top_srcdir)/po/LINGUAS'])
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE, "$GETTEXT_PACKAGE", [gettext domain])
AM_GLIB_GNU_GETTEXT

localedir='${prefix}/${DATADIRNAME}/locale'
AC_SUBST(localedir)

#IT_PROG_INTLTOOL([0.40.0])

AC_DEFINE_UNQUOTED(LOCALE_DIR, "${PREFIX}/${DATADIRNAME}/locale",[Locale directory])
AC_DEFINE_UNQUOTED(DATADIR, "${PREFIX}/${DATADIRNAME}",[Data directory])
AC_DEFINE_UNQUOTED(PREFIXDIR, "${PREFIX}",[Prefix directory])

INTLTOOL_LENS_RULE='%.lens: %.lens.in $(INTLTOOL_MERGE) $(wildcard $(top_srcdir)/po/*.po) ; LC_ALL=C $(INTLTOOL_MERGE) -d -u -c $(top_builddir)/po/.intltool-merge-cache $(top_srcdir)/po $< [$]@'
AC_SUBST(INTLTOOL_LENS_RULE)

AC_CONFIG_FILES([
	Makefile
	po/Makefile.in
	data/Makefile
	src/Makefile
	vapi/Makefile
])
AC_OUTPUT
