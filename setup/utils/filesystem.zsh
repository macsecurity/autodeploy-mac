[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

function FILESYSTEM__SETUP() {
	local BUILD_DIR="$1"
	STATUS 'verifying rentdynamics required build filesystem'
	DIRECTORIES=(
		"$BUILD_DIR"
		"$BUILD_DIR/bin"
		"$HOME/.config"
		"$HOME/.config/rentdynamics"
		)

	FILES=(
		"$HOME/.zprofile"
		"$HOME/.zshrc"
		"$HOME/.config/rentdynamics/env.zsh"
		)

	for D in $DIRECTORIES; do mkdir $D >/dev/null 2>&1; done
	for F in $FILES; do touch $F >/dev/null 2>&1; done
	SUCCESS 'filesystem setup complete'
}

