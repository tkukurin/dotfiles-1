#!/usr/bin/env zsh
# vim:ft=zsh
# @see prompt_tuurlijk_help

local -A symbols
local -A colours
local newSymbol
local newColour

symbols=(
	'branch' ''
	'error' '✘'
	'flip' '❨╯°益°❩╯彡┻━┻'
	'hash' '#'
	'left' ''
	'root' ' '
	'right' ''
)

# Use extended color palette if available
if [[ -n ${terminfo[colors]} && ${terminfo[colors]} -ge 256 ]]; then
	colours=(
	'pwd' 250
	'pwdBg' 238
	'userHost' 16
	'userHostBg' 254
	'exit' 124
	'exitBg' 245
	'root' 245
	'rootBg' 52
	'exec' 208
	'vcs' 244
	'vcsBg' 236
	'vcsClean' 28
	'vcsDirty' 124
	)
else
	colours=(
	'pwd' white
	'pwdBg' blue
	'userHost' black
	'userHostBg' cyan
	'exit' red
	'exitBg' cyan
	'root' red
	'rootBg' yellow
	'exec' yellow
	'vcs' white
	'vcsBg' blue
	'vcsClean' green
	'vcsDirty' red
	)
fi

# Set symbols from user preferences (zstyle ':theme:tuurlijk:branch' symbol '')
for symbol in ${(@k)symbols}; do
	zstyle -s ":theme:tuurlijk:$symbol" symbol newSymbol && symbols[$symbol]=$newSymbol
done

# Set colours from user preferences (zstyle ':theme:tuurlijk:pwd' colour 250)
for colour in ${(@k)colours}; do
	zstyle -s ":theme:tuurlijk:$colour" colour newColour && colours[$colour]=$newColour
done

# Define prompts
prompt_tuurlijk_setup() {
	if ! type shrink_path > /dev/null; then
		echo -e " \033[1;31m✖\033[0m Please install the 'shrink-path' plugin:"
		echo "   https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/shrink-path"
		echo "   This prompt uses it to generate a short readable path."
	fi

	# Load required modules
	autoload -Uz vcs_info

	# vcs_info format strings, formatted using zformat
	# See: man zshmodules
	#
	# max-exports: Defines the maximum number of vcs_info_msg_*_ variables vcs_info will set.
	# %b: branch
	# %a: action (rebase/merge)
	# %i: revision number or identifier
	# %s: version control system
	# %r: name of the root directory of the repository
	# %S: path relative to the repository root directory
	# %m: in case of Git, show information about stashes
	# %u: unstaged changes in the repository
	# %c: staged changes in the repository
	#
	zstyle ':vcs_info:*' enable git hg
	zstyle ':vcs_info:*' check-for-changes true
	zstyle ':vcs_info:*' get-revision true
	zstyle ':vcs_info:*' max-exports 5
	zstyle ':vcs_info:*:*' unstagedstr '!'
	zstyle ':vcs_info:*:*' stagedstr '+'
	zstyle ':vcs_info:*:*' formats \
		"%F{$colours[vcsBg]}${symbols[left]}%K{$colours[vcsBg]}%F{$colours[vcs]}%F{$colours[vcsClean]}${symbols[branch]} %F{$colours[vcs]}%1.25b" \
		"%F{$colours[vcsBg]}${symbols[left]}%K{$colours[vcsBg]}%F{$colours[vcs]}%F{$colours[vcsDirty]}${symbols[branch]} %F{$colours[vcs]}%1.25b" \
		"%7.7i" \
		"%r" \
		"%u%c"
	zstyle ':vcs_info:*:* actionformats' \
		"%F{$colours[vcsBg]}${symbols[left]}%K{$colours[vcsBg]}%F{$colours[vcs]}%F{$colours[vcsClean]}${symbols[branch]} %F{$colours[vcs]}%1.25b" \
		"%F{$colours[vcsBg]}${symbols[left]}%K{$colours[vcsBg]}%F{$colours[vcs]}%F{$colours[vcsDirty]}${symbols[branch]} %F{$colours[vcs]}%1.25b" \
		"%7.7i" \
		"%r" \
		"%u%c (%a)"
	autoload -Uz colors && colors
	autoload -Uz add-zsh-hook

	prompt_opts=(percent subst)

	add-zsh-hook preexec _prompt_tuurlijk_preexec
	add-zsh-hook precmd _prompt_tuurlijk_precmd

	# Prompt format strings
	#
	# %F: foreground color dict
	# %f: reset foreground color
	# %K: background color dict
	# %k: reset background color
	# %~: current path
	# %*: time
	# %n: username
	# %m: shortname host
	# %(?..): prompt conditional - %(condition.true.false)
	PROMPT_PWD=' $(shrink_path -l -t)'
	PROMPT_EXIT="%K{$colours[exitBg]}%F{$colours[exit]}%(?.. ${symbols[flip]} %? %K{$colours[pwdBg]}%F{$colours[exitBg]}${symbols[right]})%K{$colours[pwdBg]}%F{$colours[pwd]}"
	PROMPT_SU="%(!.%k%F{$colours[pwdBg]}%K{$colours[rootBg]}${symbols[right]} ⚡ %F{$colours[rootBg]}%k.%k%F{$colours[pwdBg]})${symbols[right]}%{%f%k%b%} "
	PROMPT='${PROMPT_EXIT}${(e)${PROMPT_PWD}}${PROMPT_SU}'

	RPROMPT_HOST="%F{$colours[userHostBg]}${SSH_TTY:+${symbols[left]}}%K{$colours[userHostBg]}%F{$colours[userHost]}${SSH_TTY:+ %n@%m }%{%f%k%b%}"
	RPROMPT_EXEC_COLOUR="%F{$colours[exec]}"
	RPROMPT='$(_prompt_tuurlijk_vcs_path_and_branch)${RPROMPT_EXEC_COLOUR}$(_prompt_tuurlijk_cmd_exec_time)${RPROMPT_HOST}'
}

# Fastest possible way to check if repo is dirty
_prompt_tuurlijk_vcs_is_git_dirty() {
	if [[ $(command git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then
		return true
	else
		return false
	fi
}

# Display information about the current path and branch
_prompt_tuurlijk_vcs_path_and_branch() {
	local segment
	if [[ -n "$vcs_info_msg_2_" ]]; then
		if [[ -z $vcs_info_msg_4_ ]]; then
			segment+=( "$vcs_info_msg_0_" )
		else
			segment+=( "$vcs_info_msg_1_" )
			segment+=( "$vcs_info_msg_4_" )
		fi
		segment+=( "$vcs_info_msg_2_" )
		[[ -n "$vcs_info_msg_3_" ]] && segment+=( "|$vcs_info_msg_3_ " )
	fi
	echo $segment
}

# Display information about the current repository
_prompt_tuurlijk_vcs_repository() {
	echo "${vcs_info_msg_0_}"
}

# Displays the exec time of the last command if set threshold was exceeded
_prompt_tuurlijk_cmd_exec_time() {
	local stop=`date +%s`
	local start=${_cmd_timestamp:-$stop}
	let local elapsed=$stop-$start
	[ $elapsed -gt 5 ] && echo "${elapsed}s "
}

# Get the initial timestamp for cmd_exec_time
_prompt_tuurlijk_preexec() {
	_cmd_timestamp=`date +%s`
}

# Get version control info before we start outputting stuff
_prompt_tuurlijk_precmd() {
	vcs_info
}

prompt_tuurlijk_help () {
	cat <<EOH
	Tuurlijk's lightweight prompt

	You will need a Powerline capable font:
	https://github.com/powerline/powerline

	And the 'shrink-path' plugin:
	https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/shrink-path

	You can style this prompt using zstyles in your .zshrc:

	# Set custom prompt colours
	zstyle ':theme:tuurlijk:pwd' colour 250
	zstyle ':theme:tuurlijk:pwdBg' colour 238
	zstyle ':theme:tuurlijk:exit' colour 124
	zstyle ':theme:tuurlijk:exitBg' colour 245
	zstyle ':theme:tuurlijk:root' colour 234
	zstyle ':theme:tuurlijk:rootBg' colour 52
	zstyle ':theme:tuurlijk:userHost' colour 16
	zstyle ':theme:tuurlijk:userHostBg' colour 245
	zstyle ':theme:tuurlijk:exec' colour 220
	zstyle ':theme:tuurlijk:vcs' colour 250
	zstyle ':theme:tuurlijk:vcsBg' colour 238
	zstyle ':theme:tuurlijk:vcsClean' colour 28
	zstyle ':theme:tuurlijk:vcsDirty' colour 124

	# Set custom prompt symbols
	zstyle ':theme:tuurlijk:branch' symbol 
	zstyle ':theme:tuurlijk:hash' symbol ➦

EOH
}

prompt_tuurlijk_setup "$@"

