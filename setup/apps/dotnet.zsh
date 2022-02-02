[ ! $SETUP_HOME_DIR ] && SETUP_HOME_DIR="${0:a:h}/.."
typeset -f CONSOLE_COLOR_OUT >/dev/null 2>&1 || source "$SETUP_HOME_DIR/utils/color.zsh"

#####################################################################

function DOTNET__INSTALL() {
	local ERROR=0

	CHECK 'checking .NET Core (3.1) install'
	dotnet --list-sdks 2>&1 | grep -q '^3\.1' && OK || { WARN; ERROR=1 } 

	CHECK 'checking .NET 5 install'
	dotnet --list-sdks 2>&1 | grep -q '^5\.0' && OK || { WARN; ERROR=1 }

	[[ $ERROR -eq 1 ]] && {
		WARNING
		WARNING 'unfortunately, no automated .NET installer exists at this time'
		WARNING 'please visit the Microsoft website to perfom manual install'
		WARNING
		WARNING 'dotnet.microsoft.com/download'
		WARNING
	}
}
