#!/bin/zsh
#####################################################################

source $HOME/.config/rentdynamics/env.zsh
[ -d $RD_TOOLS_BIN ] && export PATH="$RD_TOOLS_BIN:$PATH"

#####################################################################

autoload -Uz compinit >/dev/null 2>&1 && compinit

RD_ZSH_PLUGINS=(
	"$RD_TOOLS_BUILD_DIR/fzf-tab/fzf-tab.plugin.zsh"
	"$RD_ZSH_PLUGIN/rentdynamics.zsh"
	)

for plugin in $RD_ZSH_PLUGINS
do
	[ -f $plugin ] && source $plugin
done

#####################################################################

[ $STARSHIP_CONFIG ] && eval $(starship init zsh)
