libexec_PROGRAMS = unity-tomboy-daemon

unity_tomboy_daemon_SOURCES = \
	main.vala \
	daemon.vala

AM_CPPFLAGS = \
	-include config.h \
	$(LENS_DAEMON_CFLAGS) \
	-DLOCALEDIR=\""$(localedir)"\" \
	-DPKGDATADIR=\""$(pkgdatadir)"\" \
	-DPKGLIBDIR=\""$(pkglibdir)"\"

VALAFLAGS = \
	--vapidir=$(srcdir)/../vapi --pkg config \
	@LENS_DAEMON_PACKAGES@

unity_tomboy_daemon_LDADD = \
	$(LENS_DAEMON_LIBS)

