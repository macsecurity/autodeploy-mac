[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

function FZF__INSTALL() {
	CHECK 'installing fzf command line tools'
	yes | $(brew --prefix)/opt/fzf/install >>$LOG 2>&1 \
		&& OK || INSTALL_WARN
}
