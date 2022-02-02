[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

function VALIDATE__GIT_TARGET_IS_MASTER() {
	local target="$1"
	command -v git >/dev/null && {
		CHECK 'validating setup script'
		# git fetch origin master >/dev/null 2>&1
		# git diff --exit-code origin/master -- "$target" >/dev/null 2>&1 || {
		# 	WARN "'$target' does not match master"
		# 	WARNING 'attempting to update to master'
		# 	git rebase origin/master && {
		# 		SUCCESS 'successfully updated to master; re-run this script' 
		# 		exit 2
		# 	} || {
		# 		git rebase --abort >/dev/null 2>&1
		# 		FAIL 'failed to update branch to master; fix your git state'
		# 	}
		# }
		OK
	}
}

function VALIDATE__OSX_IS_LATEST() {
	CHECK 'validating OS'
	[[ $OSTYPE =~ ^darwin ]] && OK \
		|| FAIL 'OSX required'

	CHECK 'validating OSX version is latest'
	sudo softwareupdate -l 2>&1 | grep -q '^No new software available\.$' && OK || {
		WARN 'software update detected! attempting to install'
		WARNING 'your system can reboot during this process'

		USER_PROMPT 'continue? [Y/n]'
		READ yn
		[[ $yn =~ ^[Nn] ]] && FATAL 'user abort'

		sudo softwareupdate --verbose --install --all --restart && {
			SUCCESS 'successfully installed osx update'
		} || {
			WARNING 'failed to install software update'
			WARNING 'setup is not guaranteed to work on old versions of OSX'
			WARNING 'be sure to install all the latest software versions for your machine'
		}
	}

	CHECK 'validating/installing xcode-select tools'
	xcode-select -p >/dev/null 2>&1 && OK || {
		sudo xcode-select --install >/dev/null 2>&1 && OK \
			|| FAIL 'failed to install xcode CLI tools (try `sudo xcode-select --install` manually)'
	}
}
