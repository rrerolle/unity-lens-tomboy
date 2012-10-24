test -n "$srcdir" || srcdir=$(dirname "$0")
test -n "$srcdir" || srcdir=.
(
  cd "$srcdir" &&
  intltoolize --force --automake --copy &&
  autoreconf -fiv -Wall
) || exit
test -n "$NOCONFIGURE" || "$srcdir/configure" --enable-maintainer-mode "$@"
