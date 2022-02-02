[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

GIT_ZSH_PLUGIN__INSTALL() {
	local BUILD_DIR="$1"
	local PACKAGE_NAME="$2"
	local HTTP_TARGET="$3"

	[ $BUILD_DIR ] && [ $PACKAGE_NAME ] && [ $HTTP_TARGET ] || return 1
	BUILD_DIR="$BUILD_DIR/$PACKAGE_NAME"

	[ ! -d $BUILD_DIR ] && {
		CHECK "installing $PACKAGE_NAME"
		git clone $HTTP_TARGET $BUILD_DIR >>$LOG 2>&1 \
			&& OK || { INSTALL_WARN; return 2 }
	}
	cd $BUILD_DIR

	CHECK "checking $PACKAGE_NAME install version"
	git pull $BUILD_DIR >>$LOG 2>&1 \
		&& OK || INSTALL_WARN
}
