[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

function PYENV__INSTALL() {
	local BUILD_DIR="$1"
	STATUS 'checking pyenv install'
	[ -d "$BUILD_DIR/pyenv" ] && STATUS 'pyenv already installed' || {
		CHECK 'installing pyenv'
		git clone https://github.com/pyenv/pyenv.git "$BUILD_DIR/pyenv" >>$LOG 2>&1 \
			&& OK || INSTALL_WARN
	}

	eval $(pyenv init --path)

	for V in $(cat "$SETUP_HOME_DIR/config/python-versions.txt")
	do
		PYTHON_VERSION_INSTALL $V
	done
}

function PYTHON_VERSION_INSTALL() {
	local version=$(pyenv install --list | sed 's/^\s\+//' | grep "^$1" | tail -n1)
	CHECK "installing python $version"
	[ -d "$BUILD_DIR/pyenv/versions/$version" ] && OK || {
		yes | pyenv install $version >>$LOG 2>&1 && OK || INSTALL_WARN
	}
	CHECK "linking to 'python$1'"
	rm "$BUILD_DIR/bin/python$1" >/dev/null 2>&1
	ln -s "$BUILD_DIR/pyenv/versions/$version/bin/python" "$BUILD_DIR/bin/python$1" >/dev/null 2>&1 \
		&& OK || WARN 'failed to link'
}

