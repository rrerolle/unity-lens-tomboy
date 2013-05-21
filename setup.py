#!/usr/bin/python
# -*- coding: utf-8 -*-
from distutils.core import setup
from DistUtilsExtra.command import build_extra, build_i18n

setup(
    name="unity-lens-tomboy",
    version="0.3",
    author="Rémi Rérolle",
    author_email="remi.rerolle@gmail.com",
    url="http://github.com/rrerolle/unity-lens-tomboy",
    license="GNU General Public License (GPL)",
    data_files=[
        ('lib/unity-lens-tomboy', ['src/unity-lens-tomboy']),
        ('share/dbus-1/services', ['unity-lens-tomboy.service']),
        ('share/pixmaps', ['tomboy-lens.svg']),
    ],
    cmdclass={
        "build":  build_extra.build_extra,
        "build_i18n": build_i18n.build_i18n,
    },
)
