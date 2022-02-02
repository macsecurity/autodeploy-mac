[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

POSTGRESQL__SETUP() {
	CHECK 'validating postgres setup'
	psql -d postgres -c '\list' | grep -q rentplus && OK || {
		WARN 'first time postgres setup not yet run'
		CHECK 'running first-time postgres setup'
		local INIT_FILE="$SETUP_HOME_DIR/postgresql/init.sql"
		psql -d postgres -a -f $INIT_FILE >>$LOG 2>&1 \
			&& OK || WARN "failed to perform init (see '$INIT_FILE' for directions)"
	}
}
