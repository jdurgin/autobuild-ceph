#!/bin/sh -x
set -e

[ ! -x autogen.sh ] || ./autogen.sh || exit 1
autoconf || true
[ ! -x configure ] || ./configure || exit 2

if [ ! -e Makefile ]; then
    echo "$0: no Makefile, aborting." 1>&2
    exit 3
fi

# Actually build the project
#make || exit 4

# The "make -q check" probe in build.sh.example is faulty in that
# screwups in Makefiles make it think there are no unit tests to
# run. That's unacceptable; use a dumber probe.
if [ -e src/gtest ]; then
    # run "make check", but give it a time limit in case a test gets stuck
    ../maxtime 1800 make check || exit 5
fi

exit 0