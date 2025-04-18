#!/bin/bash -e

. ../../include/depinfo.sh
. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf _build$ndk_suffix
	exit 0
else
	exit 255
fi

[ -f waf ] || ./bootstrap.py

PKG_CONFIG="pkg-config --static" \
./waf configure \
	--enable-lgpl \
	--disable-cplayer \
	--disable-vulkan \
	--disable-libplacebo \
	--disable-lua \
	--disable-iconv \
	--enable-libmpv-shared \
	--disable-manpage-build \
	-o "`pwd`/_build$ndk_suffix"

./waf build -j$cores
./waf install --destdir="$prefix_dir"

ln -sf "$prefix_dir"/lib/libmpv.so "$native_dir"
