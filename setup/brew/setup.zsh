[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"
typeset -f READ >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/user-input.zsh"

#####################################################################

HOMEBREW_INSTALL_TARGET='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'

#####################################################################

function BREW__SETUP() {
	STATUS 'starting Homebrew setup'
	BREW__INSTALL_HOMEBREW
	BREW__TAP_REPOSITORIES
	BREW__UPDATE
	BREW__INSTALL_DEPENDENCIES
	BREW__INSTALL_CASK_DEPENDENCIES
	BREW__SERVICES_START
	SUCCESS 'finished Homebrew setup'
}

#####################################################################

function BREW__INSTALL_HOMEBREW() {
	CHECK 'checking homebrew install'
	command -v brew >/dev/null && OK || {
		WARN 'no homebrew found'
		CHECK 'installing homebrew (this will take a minute)'
		yes | /bin/bash -c "$(curl -fsSL $HOMEBREW_INSTALL_TARGET)" >>$LOG 2>&1 && OK \
			|| FAIL 'failed to install homebrew (see `https://brew.sh` for instructions)'
	}

	CHECK 'setting gnubin'
	export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH" && OK \
		|| WARN 'failed to set gnubin'
}

function BREW__TAP_REPOSITORIES() {
	STATUS 'updating brew repositories'
	for REPOSITORY in $(cat "$SETUP_HOME_DIR/brew/tap.txt")
	do
		CHECK "tapping $REPOSITORY"
		brew tap $(echo $REPOSITORY) >>$LOG 2>&1 && OK || TAP_WARN
	done
}

function BREW__UPDATE() {
	CHECK 'updating brew links and mirrors'
	brew update >>$LOG 2>&1 && OK \
		|| FAIL 'failed to update brew (try `brew update` manually)'
}

function BREW__INSTALL_DEPENDENCIES() {
	STATUS 'installing brew dependencies'
	local yesargs

	for DEPENDENCY in $(cat "$SETUP_HOME_DIR/brew/install.txt")
	do
		case $DEPENDENCY in 
			msodbcsql17 | mssql-tools )
				yesargs='YES' ;;
			* ) unset yesargs ;;
		esac
		CHECK "installing $DEPENDENCY"
		yes $yesargs | brew install $DEPENDENCY >>$LOG 2>&1 && OK || INSTALL_WARN
	done
}

function BREW__INSTALL_CASK_DEPENDENCIES() {
	local YES_ALL=0
	local NO_ALL=0
	local FORCE=0

	STATUS 'installing brew cask dependencies'
	for DEPENDENCY in $(cat "$SETUP_HOME_DIR/brew/cask.txt")
	do
		CHECK "installing $DEPENDENCY"
		[[ $YES_ALL == 1 ]] && {
			BREW__CHECK_CASK_DEPENDENCY "$DEPENDENCY" && FORCE=0 || FORCE=1
			BREW__CASK_INSTALL $DEPENDENCY $FORCE && OK || INSTALL_WARN
		} || {
			BREW__CASK_INSTALL $DEPENDENCY && OK || {
				WARN "maybe user install exists (target '$DEPENDENCY')?"
				[[ $NO_ALL == 1 ]] || {
					MENU 'yes to (a)ll'
					MENU '(y)es'
					MENU '(n)o'
					MENU 'n(o)ne'
					USER_PROMPT "allow homebrew to manage '$DEPENDENCY'? (recommended) [A/y/n/o]"
					READ yn
					case $yn in
						o | O | n | N )
							[[ $yn =~ [oO] ]] && NO_ALL=1
							WARNING "skipping '$DEPENDENCY'"
							continue
							;;
						* )
							[[ $yn =~ ^[yY] ]] || YES_ALL=1
							CHECK "switching $DEPENDENCY to homebrew"
							BREW__CASK_INSTALL $DEPENDENCY 1 && OK || INSTALL_WARN
							;;
					esac
				}
			}
		}
	done
}

function BREW__CASK_INSTALL() {
	local DEPENDENCY="$1"
	local FORCE="$2"

	[[ $FORCE == 1 ]] \
		&& yes | brew install --cask $DEPENDENCY --force >>$LOG 2>&1 \
		|| yes | brew install --cask $DEPENDENCY >>$LOG 2>&1 \
		;
}

function BREW__CHECK_CASK_DEPENDENCY() {
	local DEPENDENCY="$1"
	brew list --casks | grep -q $DEPENDENCY
}

function BREW__SERVICES_START() {
	STATUS 'starting brew services'
	for SERVICE in $(cat "$SETUP_HOME_DIR/brew/services.txt")
	do
		CHECK "starting $SERVICE"
		brew services restart $SERVICE >>$LOG 2>&1 && OK || SERVICE_WARN
	done
}
