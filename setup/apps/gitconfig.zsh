[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"
typeset -f READ >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/user-input.zsh"

#####################################################################

function GITCONFIG__CONFIGURE() {
	CHECK 'checking gitconfig'
	[ -f "$HOME/.gitconfig" ] && {
		grep -q 'vimdiff' "$HOME/.gitconfig" && OK || {
			WARN
			STATUS 'new gitconfig settings preview'
			echo '----------------------------'
			GET_GITCONFIG
			echo '----------------------------'
			USER_PROMPT 'I see you have your own settings; would you like to try mine? [Y/n]'
			READ yn
			[[ $yn =~ ^[nN] ]] && { STATUS 'preserving user gitconfig settings' } || {
				CHECK 'backing up user settings'
				mv "$HOME/.gitconfig" "$HOME/.gitconfig.bak" >>$LOG 2>&1 && {
					OK; GET_GITCONFIG > "$HOME/.gitconfig"
				} || {
					WARN 'failed to back up user gitconfig; aborting'
				}
			}
		}
	} || {
		GET_GITCONFIG > "$HOME/.gitconfig" && OK || WARN 'failed to set up gitconfig'
	}
}

function GET_GITCONFIG() {
	sed "s/FIRST/$FIRST_NAME/; s/LAST/$LAST_NAME/; s/EMAIL/$EMAIL_ADDRESS/" "$SETUP_HOME_DIR/config/gitconfig"
}
