#!/bin/sh

rdmd --build-only -ofbin/orb -m32 -Iorange -L-lruby.1.9.1-static -J./resources -L-LTango-D2 -ITango-D2 -L-ltango -L-lz "$@" orbit/orb/Orb.d
