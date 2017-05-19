# List of vcs_info format strings:
#
# %b => current branch
# %a => current action (rebase/merge)
# %s => current version control system
# %r => name of the root directory of the repository
# %S => current path relative to the repository root directory
# %m => in case of Git, show information about stashes
# %u => show unstaged changes in the repository
# %c => show staged changes in the repository
#
# List of prompt format strings:
#
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

# Fastest possible way to check if repo is dirty
_git_dirty() {
	# Check if we're in a git repo
	command git rev-parse --is-inside-work-tree &>/dev/null || return
	# Check if it's dirty
	command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo "*"
}

# Display information about the current repository
_repo_information() {
	echo "%F{blue}${vcs_info_msg_0_%%/.} %F{8}$vcs_info_msg_1_`_git_dirty` $vcs_info_msg_2_%f"
}

# Displays the exec time of the last command if set threshold was exceeded
_prompt_lala_cmd_exec_time() {
	local stop=`date +%s`
	local start=${_cmd_timestamp:-$stop}
	let local elapsed=$stop-$start
	[ $elapsed -gt 5 ] && echo ${elapsed}s
}

# Get the initial timestamp for cmd_exec_time
_prompt_lala_preexec() {
	_cmd_timestamp=`date +%s`
}

# Output additional information about paths, repos and exec time
_prompt_lala_precmd() {
	vcs_info # Get version control info before we start outputting stuff
}

_prompt_lala_set_colour () {
	local colour
	if zstyle -s ":theme:tuurlijk:$1" colour colour; then
		zstyle -s ":theme:tuurlijk:$1" colour colour
		colours[$1]=$colour
	fi
}

# Define prompts
prompt_lala_setup() {
	# Load required modules
	autoload -Uz vcs_info

	# Set vcs_info parameters
	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:*:*' unstagedstr '!'
	zstyle ':vcs_info:*:*' stagedstr '+'
	zstyle ':vcs_info:*:*' formats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%%u%c"
	zstyle ':vcs_info:*:*' actionformats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%u%c (%a)"
	zstyle ':vcs_info:*:*' nvcsformats "" "" ""

	autoload -Uz colors && colors
	autoload -Uz add-zsh-hook

	prompt_opts=(percent subst)

	add-zsh-hook preexec _prompt_lala_preexec
	add-zsh-hook precmd _prompt_lala_precmd

	PROMPT_PWD=' $(shrink_path -f) '
	PROMPT_EXIT="%K{$colours[exitBg]}%F{$colours[exit]}%(?.. ✘ %K{$colours[pwdBg]}%F{$colours[exitBg]})%K{$colours[pwdBg]}%F{$colours[pwd]}"
	PROMPT_SU="%(!.%k%F{$colours[pwdBg]}%K{$colours[rootBg]} ⚡ %F{$colours[rootBg]}%k.%k%F{$colours[pwdBg]})%{%f%k%b%} "
	PROMPT='${PROMPT_EXIT}${(e)${PROMPT_PWD}}${PROMPT_SU}'

	RPROMPT_HOST="%k%F{$colours[userHostBg]}${SSH_TTY:+}%K{$colours[userHostBg]}%F{$colours[userHost]}${SSH_TTY:+ %n@%m }%{%f%k%b%}"
	RPROMPT='$(_repo_information)%F{yellow}$(_prompt_lala_cmd_exec_time) ${RPROMPT_HOST}'
}

local -A colours
# Use extended color palette if available
if [[ -n ${terminfo[colors]} && ${terminfo[colors]} -ge 256 ]]; then
	colours=(
	'pwd' 253
	'pwdBg' 31
	'userHost' 245
	'userHostBg' 238
	'exit' 124
	'exitBg' 74
	'root' 235
	'rootBg' 235
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
	)
fi

# Set colours from user preferences
local newColour
for colour in ${(@k)colours}; do
	zstyle -s ":theme:tuurlijk:$colour" colour newColour && colours[$colour]=$newColour
done

prompt_lala_setup "$@"

