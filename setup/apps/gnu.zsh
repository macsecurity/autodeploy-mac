[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

function GNU__INSTALL() {
	local BUILD_DIR="$1/bin"
	local GNU_APPS=(awk sed grep find)

	for app in $GNU_APPS
	do
		[ ! -f "$BUILD_DIR/$app" ] && {
			CHECK "linking GNU $app"
			ln -s $(which "g$app") $BUILD_DIR/$app >>$LOG 2>&1 \
				&& OK || INSTALL_WARN
		}
	done
}
