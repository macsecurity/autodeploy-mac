[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

function KITTY__INSTALL() {
	CHECK 'installing kitty-term'
	curl -sL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin >>$LOG 2>&1 && OK \
		|| INSTALL_WARN
}
