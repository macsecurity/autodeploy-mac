BLACK='0;30'
DARK_GRAY='1;30'
RED='0;31'
LIGHT_RED='1;31'
GREEN='0;32'
LIGHT_GREEN='1;32'
ORANGE='0;33'
YELLOW='1;33'
BLUE='0;34'
LIGHT_BLUE='1;34'
PURPLE='0;35'
LIGHT_PURPLE='1;35'
CYAN='0;36'
LIGHT_CYAN='1;36'
LIGHT_GRAY='0;37'
WHITE='1;37'

PREFIX_ERR='ERROR  '
PREFIX_FAT='FATAL  '
PREFIX_WRN='WARNING'
PREFIX_SCS='SUCCESS'
PREFIX_STS='STATUS '
PREFIX_USR='USER   '
PREFIX_BLK='       '
PREFIX_CHK='CHECK  '

function CONSOLE_COLOR_OUT() {
	local color="$1"
	local prefix="$2"

	local message="\\033[$color""m$prefix :: ${@:3}\\033[0m"

	[ ! $SINGLE_LINE ] && message="$message\n"

	printf $message
}

function ERROR() {
	CONSOLE_COLOR_OUT $RED $PREFIX_ERR $@
}

function FATAL() {
	ERROR $@
	CONSOLE_COLOR_OUT $RED $PREFIX_FAT 'exiting'
	exit 1
}

function WARNING() {
	CONSOLE_COLOR_OUT $ORANGE $PREFIX_WRN $@
}

function STATUS() {
	CONSOLE_COLOR_OUT $PURPLE $PREFIX_STS $@
}

function SUCCESS() {
	CONSOLE_COLOR_OUT $GREEN $PREFIX_SCS $@
}

function USER_PROMPT() {
	SINGLE_LINE=1 CONSOLE_COLOR_OUT $CYAN $PREFIX_USR $@
}

function MENU() {
	CONSOLE_COLOR_OUT $YELLOW $PREFIX_BLK $@
}

function CHECK() {
	SINGLE_LINE=1 CONSOLE_COLOR_OUT $WHITE $PREFIX_CHK $@'... '
}

function CHECK_RESULT() {
	local color="$1"
	local output="$2"
	printf "\\033[$color""m$output\\033[0m\n"
}

function OK()   { CHECK_RESULT $LIGHT_GREEN '✔ OK'; }
function WARN() { CHECK_RESULT $YELLOW '⚠ WARN'; [ $1 ] && WARNING $@; }
function FAIL() { CHECK_RESULT $LIGHT_RED '✖ FAIL'; FATAL $@; }

function TAP_WARN() { CHECK_RESULT $YELLOW '⚠ WARN :: tap failed' }
function INSTALL_WARN() { CHECK_RESULT $YELLOW '⚠ WARN :: install failed' }
function SERVICE_WARN() { CHECK_RESULT $YELLOW '⚠ WARN :: did not start service' }
function SERVICE_WARN() { CHECK_RESULT $YELLOW '⚠ WARN :: did not start service' }
