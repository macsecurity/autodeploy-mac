OSX__RUN_SCRIPT_IN_NEW_TERMINAL() {
	local script="$1"
	local terminal="$2"
	[ ! $terminal ] && terminal='Terminal'

	osascript -e "tell app \"$terminal\"
		do script \"$script\"
	end tell" >/dev/null 2>&1 \
		&& osascript -e "tell app \"$terminal\" to activate" >/dev/null 2>&1
}

OSX__GET_COMPILE_FLAGS() {
	FLAGS=(openssl bzip2 zlib)

	BREW_CFLAGS=''
	BREW_CPPFLAGS=''
	BREW_LDFLAGS=''

	for flag in $FLAGS
	do
		PREFIX="$(brew --prefix $flag)"
		BREW_CFLAGS="-I$PREFIX/include $BREW_CFLAGS"
		BREW_CPPFLAGS="-I$PREFIX/include $BREW_CPPFLAGS"
		BREW_LDFLAGS="-L$PREFIX/lib $BREW_LDFLAGS"
	done

	echo "export LDFLAGS='$BREW_LDFLAGS'"
	echo "export CPPFLAGS='$BREW_CPPFLAGS'"
	echo "export CPPFLAGS='$BREW_CFLAGS'"
	echo "export PKG_CONFIG_PATH='$(brew --prefix openssl)/lib/pkgconfig'"
	echo "export PYCURL_SSL_LIBRARY=openssl"
}
