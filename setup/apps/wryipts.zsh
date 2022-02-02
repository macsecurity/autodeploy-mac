[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

function WRYIPTS__INSTALL() {
	local BUILD_DIR="$1"
	local SRC="$BUILD_DIR/wryipts"
	local ENV="$SRC/env"

	CHECK 'installing wryipts'
	[ ! -d $ENV ] \
		&& virtualenv --python="$(which python3.9)" "$ENV" >>$LOG 2>&1

	source "$ENV/bin/activate" >>$LOG 2>&1 \
		&& yes 'N' | "$SRC/sync-env" >>$LOG 2>&1 \
		&& pip install -r "$SRC/py/requirements.txt" >>$LOG 2>&1 \
		&& OK || INSTALL_WARN 

	deactivate >>$LOG 2>&1
}
