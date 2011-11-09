dbus_servicesdir = $(datadir)/dbus-1/services

service_in_files =  unity-lens-tomboy.service.in
dbus_services_DATA = $(service_in_files:.service.in=.service)

%.service: %.service.in
	sed -e "s|\@libexecdir\@|$(libexecdir)|" $< > $@

lens_in_files = tomboy.lens.in
lensdir = $(LENSESDIR)/tomboy
lens_DATA = $(lens_in_files:.lens.in=.lens)

@INTLTOOL_LENS_RULE@

defaultdir = $(datadir)/tomboy/unity

EXTRA_DIST = \
  $(lens_DATA)	\
  $(lens_in_files) \
  $(service_in_files)

CLEANFILES = \
  $(dbus_services_DATA) \
  $(lens_DATA)

