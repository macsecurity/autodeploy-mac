[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

source "$SETUP_HOME_DIR/apps/dotnet.zsh"
source "$SETUP_HOME_DIR/apps/fzf.zsh"
source "$SETUP_HOME_DIR/apps/git-zsh-plugin.zsh"
source "$SETUP_HOME_DIR/apps/gitconfig.zsh"
source "$SETUP_HOME_DIR/apps/gnu.zsh"
source "$SETUP_HOME_DIR/apps/kitty.zsh"
source "$SETUP_HOME_DIR/apps/pyenv.zsh"
source "$SETUP_HOME_DIR/apps/wryipts.zsh"

#####################################################################

function APPS__SETUP() {
	local BUILD_DIR="$1"

	PYENV__INSTALL $BUILD_DIR
	DOTNET__INSTALL
	GNU__INSTALL $BUILD_DIR

	GITCONFIG__CONFIGURE
	KITTY__INSTALL
	WRYIPTS__INSTALL $BUILD_DIR

	FZF__INSTALL
	GIT_ZSH_PLUGIN__INSTALL $BUILD_DIR 'fzf-tab' 'https://github.com/Aloxaf/fzf-tab'
	GIT_ZSH_PLUGIN__INSTALL $BUILD_DIR 'zsh-plugin' 'git@github.com:rentdynamics/zsh'
	[ $RD_PATH ] && [ ! -d $RD_PATH ] && mkdir $RD_PATH >>$LOG 2>&1
}
