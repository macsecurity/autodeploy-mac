[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"
typeset -f OSX__GET_COMPILE_FLAGS >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/osx.zsh"

#####################################################################

function READ() {
	read -k $1
	[[ $1 == '\n' ]] || echo
}

#####################################################################

function GET_USER_CREDENTIALS() {
	while true
	do
		[ ! $FIRST_NAME ] && { USER_PROMPT 'enter your first name : '; read FIRST_NAME }
		[ ! $LAST_NAME ] && { USER_PROMPT 'enter your last name : '; read LAST_NAME }
		[ ! $EMAIL_ADDRESS ] && { USER_PROMPT 'enter your Rent Dynamics email address : '; read EMAIL_ADDRESS }

		[ $FIRST_NAME ] && [ $LAST_NAME ] && [ $EMAIL_ADDRESS ] || { WARNING 'Missing required fields!'; continue }

		STATUS 'confirm user details'
		echo '----------------------------'
		echo "   first name : $FIRST_NAME"
		echo "    last name : $LAST_NAME"
		echo "email address : $EMAIL_ADDRESS"
		echo '----------------------------'
		MENU '(a)ccept all as correct'
		MENU 'change (f)irst name'
		MENU 'change (l)ast name'
		MENU 'change (e)mail address'
		echo
		USER_PROMPT 'make a selection [A/f/l/e]'
		READ yn
		case $yn in
			f | F ) unset FIRST_NAME ;;
			l | L ) unset LAST_NAME ;;
			e | E ) unset EMAIL_ADDRESS ;;
			* ) break ;;
		esac
	done
}

function SETUP_USER_ENV() {
	local BUILD_DIR="$1"
	[ $FIRST_NAME ] && [ $LAST_NAME ] && [ $EMAIL_ADDRESS ] || GET_USER_CREDENTIALS

	FIRST_NAME=$(echo $FIRST_NAME | sed 's/.*/\L&/; s/^./\U&/; s/ //g')
	LAST_NAME=$(echo $LAST_NAME | sed 's/.*/\L&/; s/^./\U&/; s/^Mc\(.\)/Mc\U\1/; s/ //g')
	EMAIL_ADDRESS=$(echo $EMAIL_ADDRESS | sed 's/.*/\L&/; s/ //g')

	RD_BUILD=$(echo "$BUILD_DIR" | sed 's/\//\\\//g')

	local CONFIG_FILE="$HOME/.config/rentdynamics/env.zsh"
	STATUS "inserting provided credentials to rentdynamics config ($CONFIG_FILE)"
	{
		sed "s/RD_MY_FIRST_NAME=/&'$FIRST_NAME'/; s/RD_MY_LAST_NAME=/&'$LAST_NAME'/; s/RD_MY_EMAIL_ADDRESS=/&'$EMAIL_ADDRESS'/; s/RD_TOOLS_BUILD_DIR=/&'$RD_BUILD'/" config/env.zsh
		OSX__GET_COMPILE_FLAGS
	} > $CONFIG_FILE
}
