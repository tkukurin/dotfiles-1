# Fastest possible way to check if repo is dirty
#
_git_dirty() {
	# Check if we're in a git repo
	command git rev-parse --is-inside-work-tree &>/dev/null || return
	# Check if it's dirty
	command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo "*"
}

# Display information about the current repository
#
_repo_information() {
	echo "%F{blue}${vcs_info_msg_0_%%/.} %F{8}$vcs_info_msg_1_`_git_dirty` $vcs_info_msg_2_%f"
}

# Begin a segment. Takes two arguments, background color and contents of the
# new segment.
_prompt_lala_segment() {
	print -n "%K{$1}"
	local promptStartBg
	zstyle -s ':zim:prompt:tuurlijk:promptStartBg' colour promptStartBg
	if [[ -n ${promptStartBg} ]]; then
		print -n "%F{${promptStartBg}}"
	fi
	print -n "$2"
	zstyle ':zim:prompt:tuurlijk:promptStartBg' colour $1
}

# End the prompt, closing last segment.
_prompt_lala_end() {
	local promptStartBg
	zstyle -s ':zim:prompt:tuurlijk:promptStartBg' colour promptStartBg
	print -n "%k%F{${promptStartBg}}%f "
}

# Status:
_prompt_lala_status() {
	local segment='' jobsColour rootColour statusColour userHostColourBg
	zstyle -s ':zim:prompt:tuurlijk:jobs' colour jobsColour
	zstyle -s ':zim:prompt:tuurlijk:root' colour rootColour
	zstyle -s ':zim:prompt:tuurlijk:status' colour statusColour
	zstyle -s ':zim:prompt:tuurlijk:userHostBg' colour userHostColourBg
	# Show if last command returned an error
	segment+='%(?.. %F{$statusColour}✘ %f)'
	# Are we root?
	segment+=' %(UID..⚡ )'
	# Are there any jobs running?
	(( $(jobs -l | wc -l) > 0 )) && segment+=' %F{$jobsColour}⚙ '
	# Are we in a ranger spawned shell?
	(( ${+RANGER_LEVEL} )) && segment+=' %F{cyan}r'
	# show username@host if logged in through SSH
	segment+=' ${SSH_CLIENT:+%F{$userHostColour}%n@%m%f}'
	# show username@host if root
	segment+=' %(UID.. %F{$rootColour}%n@%m )'

	if [[ -n ${segment} ]]; then
		_prompt_lala_segment "${userHostColourBg}" "${segment} "
	fi
}

# Pwd: current working directory.
_prompt_lala_pwd() {
	local segmentColour segmentColourBg
	zstyle -s ':zim:prompt:tuurlijk:segment' colour segmentColour
	zstyle -s ':zim:prompt:tuurlijk:segmentBg' colour segmentColourBg
	_prompt_lala_segment "$segmentColourBg" " %F{$segmentColour}$(shrink_path -f) "
}

# Displays the exec time of the last command if set threshold was exceeded
#
_cmd_exec_time() {
	local stop=`date +%s`
	local start=${cmd_timestamp:-$stop}
	let local elapsed=$stop-$start
	[ $elapsed -gt 5 ] && echo ${elapsed}s
}

# Get the initial timestamp for cmd_exec_time
#
_prompt_lala_preexec() {
	cmd_timestamp=`date +%s`
}

# Output additional information about paths, repos and exec time
#
_prompt_lala_precmd() {
	RETVAL=$?
	vcs_info # Get version control info before we start outputting stuff
}

_prompt_lala_is_colour_set () {
	local colour
	zstyle -s ":zim:prompt:tuurlijk:$1" colour colour
	return $?
}

# Define prompts
#
prompt_lala_setup() {
	# Set required options
	#
	setopt prompt_subst

	# Load required modules
	#
	autoload -Uz vcs_info

	# Set vcs_info parameters
	#
	zstyle ':vcs_info:*' enable git

	zstyle ':vcs_info:*:*' unstagedstr '!'
	zstyle ':vcs_info:*:*' stagedstr '+'
	zstyle ':vcs_info:*:*' formats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%%u%c"
	zstyle ':vcs_info:*:*' actionformats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%u%c (%a)"
	zstyle ':vcs_info:*:*' nvcsformats "" "" ""

	autoload -Uz colors && colors
	autoload -Uz add-zsh-hook

	prompt_opts=(cr percent subst)

	add-zsh-hook preexec _prompt_lala_preexec
	add-zsh-hook precmd _prompt_lala_precmd

	local userHostColour userHostColourBg segmentColour segmentColourBg \
		gitColour gitCleanColourBg gitDirtyColourBg statusColour rootColour \
		rootColourBg jobsColour lastColourBg
	# Use extended color palette if available
	if [[ -n ${terminfo[colors]} && ${terminfo[colors]} -ge 256 ]]; then
		userHostColour=${1:-'232'}
		userHostColourBg=${2:-'74'}
		segmentColour=${3:-'253'}
		segmentColourBg=${4:-'31'}
		gitColour=${5:-'234'}
		gitCleanColourBg=${6:-'28'}
		gitDirtyColourBg=${7:-'214'}
		statusColour=${8:-'124'}
		rootColour=${9:-'235'}
		rootColourBg=${10:-'235'}
		jobsColour=${11:-'cyan'}
	else
		userHostColour=${1:-'black'}
		userHostColourBg=${2:-'cyan'}
		segmentColour=${3:-'white'}
		segmentColourBg=${4:-'blue'}
		gitColour=${5:-'black'}
		gitCleanColourBg=${6:-'green'}
		gitDirtyColourBg=${7:-'yellow'}
		statusColour=${8:-'red'}
		rootColour=${9:-'red'}
		rootColourBg=${10:-'yellow'}
		jobsColour=${11:-'cyan'}
	fi

	if ! _prompt_lala_is_colour_set 'userHost'; then
		zstyle ':zim:prompt:tuurlijk:userHost' colour $userHostColour
	fi
	if ! _prompt_lala_is_colour_set 'userHostBg'; then
		zstyle ':zim:prompt:tuurlijk:userHostBg' colour $userHostColourBg
	fi
	if ! _prompt_lala_is_colour_set 'segment'; then
		zstyle ':zim:prompt:tuurlijk:segment' colour $segmentColour
	fi
	if ! _prompt_lala_is_colour_set 'segmentBg'; then
		zstyle ':zim:prompt:tuurlijk:segmentBg' colour $segmentColourBg
	fi
	if ! _prompt_lala_is_colour_set 'git'; then
		zstyle ':zim:prompt:tuurlijk:git' colour $gitColour
	fi
	if ! _prompt_lala_is_colour_set 'gitCleanBg'; then
		zstyle ':zim:prompt:tuurlijk:gitCleanBg' colour $gitCleanColourBg
	fi
	if ! _prompt_lala_is_colour_set 'gitDirtyBg'; then
		zstyle ':zim:prompt:tuurlijk:gitDirtyBg' colour $gitDirtyColourBg
	fi
	if ! _prompt_lala_is_colour_set 'status'; then
		zstyle ':zim:prompt:tuurlijk:status' colour $statusColour
	fi
	if ! _prompt_lala_is_colour_set 'root'; then
		zstyle ':zim:prompt:tuurlijk:root' colour $rootColour
	fi
	if ! _prompt_lala_is_colour_set 'rootBg'; then
		zstyle ':zim:prompt:tuurlijk:rootBg' colour $rootColourBg
	fi
	if ! _prompt_lala_is_colour_set 'jobs'; then
		zstyle ':zim:prompt:tuurlijk:jobs' colour $jobsColour
	fi
	#PROMPT='${(e)$(_prompt_lala_pwd)$(_prompt_lala_end)}'
	PROMPT='${(e)$(_prompt_lala_main)}'
	#print -P "\n$(_prompt_lala_status) $(_repo_information) %F{yellow}$(_cmd_exec_time)%f"
	RPROMPT='${(e)%F{8}${SSH_TTY:+%n@%m}%f $(_repo_information) %F{yellow}$(_cmd_exec_time)%f}'
}

# We need this to avoid 'Error bad subst'. When we inline these functions in
# RPOMPT, the _end seems to be evaluated before the _status. This breaks the
# prompt.
#
# Main prompt
_prompt_lala_main() {
	_prompt_lala_status
	_prompt_lala_pwd
	_prompt_lala_end
}

prompt_lala_setup "$@"
#
# ------------------------------------------------------------------------------
#
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
#---------------------------------------------------------------------------
