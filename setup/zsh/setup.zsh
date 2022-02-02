[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

function ZSH__SETUP() {
	ZSH__SET_DEFAULT_SHELL
	ZSH__SETUP_DOTFILE 'zprofile'
	ZSH__SETUP_DOTFILE 'zshrc'
}

#####################################################################

function ZSH__SET_DEFAULT_SHELL() {
	local DEFAULT_SHELL=$(awk -F: -v user="$USER" '$1 == user {print $NF}' /etc/passwd)
	CHECK 'setting zsh as default shell'
	sudo chsh -s $(which zsh) $(whoami)>>$LOG 2>&1 && OK \
		|| WARN 'failed to set zsh as default shell'
}

function ZSH__SETUP_DOTFILE() {
	local DOTFILE="$1"
	local SOURCE_LINE="source $SETUP_HOME_DIR/zsh/$DOTFILE.zsh"

	grep -q "^$SOURCE_LINE$" "$HOME/.$DOTFILE" && {
		STATUS "$DOTFILE already set up"
	} || {

		[[ $(cat "$HOME/.$DOTFILE" | wc -l) -gt 1 ]] && {
			CHECK "discovered $DOTFILE; creating backup ('$HOME/.$DOTFILE.bak')"
			mv "$HOME/.$DOTFILE" "$HOME/.$DOTFILE.bak" >>$LOG 2>&1 && {
				OK 
				WARNING "Your previous $DOTFILE has been moved to '$HOME/.$DOTFILE.bak'"
			} || {
				WARN "failed to back up $DOTFILE; proceeding with existing $DOTFILE"
				WARNING "this may cause problems with your dev environment"
			}
		}
		CHECK "setting up $DOTFILE"
		echo $SOURCE_LINE >> "$HOME/.$DOTFILE" && {
			OK
			source "$HOME/.$DOTFILE"
		} || {
			WARN "failed to set up $DOTFILE"
			WARNING "add the following line to ~/.$DOTFILE"
			echo $SOURCE_LINE
		}
	}
}
