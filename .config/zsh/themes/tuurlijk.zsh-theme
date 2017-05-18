# vim:ft=zsh
#
# Tuurlijk's Theme - fork of eriner
# A Powerline-inspired theme for ZSH
#
# In order for this theme to render correctly, you will need a font with
# powerline symbols. A simple way to add the powerline symbols is to follow the
# instructions here:
# https://simplyian.com/2014/03/28/using-powerline-symbols-with-your-current-font/
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.
#
# Requires the `git-info` zmodule to be included in the .zimrc file.

### Segment drawing
# Utility functions to make it easy and re-usable to draw segmented prompts.

prompt_tuurlijk_help () {
	cat <<EOH
	This prompt is color-scheme-able.  You can invoke it thus:

	prompt eriner [<fire1> [<fire2> [<fire3> [<userhost> [<date> [<cwd>]]]]]]

	where the parameters are the three fire colors, and the colors for the
	user@host text, date text, and current working directory respectively.
	The default colors are yellow, yellow, red, white, white, and yellow.
	This theme works best with a dark background.

	Recommended fonts for this theme: either UTF-8, or nexus or vga or similar.
	If you don't have any of these, the 8-bit characters will probably look
	stupid.
EOH
}

# Begin a segment. Takes two arguments, background color and contents of the
# new segment.
_prompt_tuurlijk_segment() {
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
_prompt_tuurlijk_end() {
	local promptStartBg
	zstyle -s ':zim:prompt:tuurlijk:promptStartBg' colour promptStartBg
	print -n "%k%F{${promptStartBg}}%f "
}

### Prompt components
# Each component will draw itself, or hide itself if no information needs to be
# shown.

# Status:
_prompt_tuurlijk_status() {
	local segment='' jobsColour rootColour statusColour userHostColourBg
	zstyle -s ':zim:prompt:tuurlijk:jobs' colour jobsColour
	zstyle -s ':zim:prompt:tuurlijk:root' colour rootColour
	zstyle -s ':zim:prompt:tuurlijk:status' colour statusColour
	zstyle -s ':zim:prompt:tuurlijk:userHostBg' colour userHostColourBg
	# Show if last command returned an error
	(( ${RETVAL} )) && segment+=' %F{$statusColour}✘ '
	# Are we root?
	(( ${+UID} == 0 )) && segment+=' %F{$rootColour}⚡ '
	# Are there any jobs running?
	(( $(jobs -l | wc -l) > 0 )) && segment+=' %F{$jobsColour}⚙ '
	# Are we in a ranger spawned shell?
	(( ${+RANGER_LEVEL} )) && segment+=' %F{cyan}r'
	# show username@host if logged in through SSH
	(( ${+SSH_CLIENT} )) && segment+=' %F{$userHostColour}%n@%m'
	# show username@host if root
	[[ $UID -eq 0 ]] && segment+=' %F{$rootColour}%n@%m'

	if [[ -n ${segment} ]]; then
		_prompt_tuurlijk_segment "${userHostColourBg}" "${segment} "
	fi
}

# Pwd: current working directory.
_prompt_tuurlijk_pwd() {
	local segmentColour segmentColourBg
	zstyle -s ':zim:prompt:tuurlijk:segment' colour segmentColour
	zstyle -s ':zim:prompt:tuurlijk:segmentBg' colour segmentColourBg
	_prompt_tuurlijk_segment "$segmentColourBg" " %F{$segmentColour}$(shrink_path -f) "
}

# Git: branch/detached head, dirty status.
_prompt_tuurlijk_git() {
	if [[ -n ${git_info} ]]; then
		local backgroundColor gitColour gitCleanColourBg gitDirtyColourBg
		zstyle -s ':zim:prompt:tuurlijk:git' colour gitColour
		zstyle -s ':zim:prompt:tuurlijk:gitCleanBg' colour gitCleanColourBg
		zstyle -s ':zim:prompt:tuurlijk:gitDirtyBg' colour gitDirtyColourBg
		if [[ -n ${git_info[isClean]} ]]; then
			backgroundColour=${gitCleanColourBg}
		fi
		if [[ -n ${git_info[isDirty]} ]]; then
			backgroundColour=${gitDirtyColourBg}
		fi
		print -n "%k%F{${backgroundColour}}%f"
		_prompt_tuurlijk_segment ${backgroundColour} ' %F{${gitColour}}${(e)git_info[prompt]}'
	fi
}

# Main prompt
_prompt_tuurlijk_main() {
	_prompt_tuurlijk_status
	_prompt_tuurlijk_pwd
	_prompt_tuurlijk_end
}

# Right prompt
_prompt_tuurlijk_right() {
	_prompt_tuurlijk_git
}

prompt_tuurlijk_precmd() {
	RETVAL=$?

	(( ${+functions[git-info]} )) && git-info
}

_prompt_tuurlijk_is_colour_set () {
	local colour
	zstyle -s ":zim:prompt:tuurlijk:$1" colour colour
	return $?
}

_prompt_tuurlijk_is_git_style_set () {
	local style
	zstyle -s ":zim:git-info:$1" format style
	return $?
}

_prompt_tuurlijk_setup_git_styles() {
	if ! _prompt_tuurlijk_is_git_style_set 'ahead'; then
		zstyle ':zim:git-info:ahead' format '⬆ %A'
	fi

	if ! _prompt_tuurlijk_is_git_style_set 'behind'; then
		zstyle ':zim:git-info:behind' format '⬇ %B'
	fi

	if ! _prompt_tuurlijk_is_git_style_set 'branch'; then
		zstyle ':zim:git-info:branch' format ' %b '
	fi

	if ! _prompt_tuurlijk_is_git_style_set 'commit'; then
		zstyle ':zim:git-info:commit' format '➦ %c'
	fi

	if ! _prompt_tuurlijk_is_git_style_set 'action'; then
		zstyle ':zim:git-info:action' format ' (%s)'
	fi

	if ! _prompt_tuurlijk_is_git_style_set 'keys'; then
		zstyle ':zim:git-info:keys' format \
			'prompt' '%b%c%s%A%B %C%D' \
			'isClean' '%C' \
			'isDirty' '%D'
	fi

	if ! _prompt_tuurlijk_is_git_style_set 'clean'; then
		zstyle ':zim:git-info:clean' format '✔ '
	fi

	if ! _prompt_tuurlijk_is_git_style_set 'dirty'; then
		zstyle ':zim:git-info:dirty' format '✘ '
	fi
}

prompt_tuurlijk_setup() {
	autoload -Uz colors && colors
	autoload -Uz add-zsh-hook

	prompt_opts=(cr percent subst)

	add-zsh-hook precmd prompt_tuurlijk_precmd

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

	if ! _prompt_tuurlijk_is_colour_set 'userHost'; then
		zstyle ':zim:prompt:tuurlijk:userHost' colour $userHostColour
	fi
	if ! _prompt_tuurlijk_is_colour_set 'userHostBg'; then
		zstyle ':zim:prompt:tuurlijk:userHostBg' colour $userHostColourBg
	fi
	if ! _prompt_tuurlijk_is_colour_set 'segment'; then
		zstyle ':zim:prompt:tuurlijk:segment' colour $segmentColour
	fi
	if ! _prompt_tuurlijk_is_colour_set 'segmentBg'; then
		zstyle ':zim:prompt:tuurlijk:segmentBg' colour $segmentColourBg
	fi
	if ! _prompt_tuurlijk_is_colour_set 'git'; then
		zstyle ':zim:prompt:tuurlijk:git' colour $gitColour
	fi
	if ! _prompt_tuurlijk_is_colour_set 'gitCleanBg'; then
		zstyle ':zim:prompt:tuurlijk:gitCleanBg' colour $gitCleanColourBg
	fi
	if ! _prompt_tuurlijk_is_colour_set 'gitDirtyBg'; then
		zstyle ':zim:prompt:tuurlijk:gitDirtyBg' colour $gitDirtyColourBg
	fi
	if ! _prompt_tuurlijk_is_colour_set 'status'; then
		zstyle ':zim:prompt:tuurlijk:status' colour $statusColour
	fi
	if ! _prompt_tuurlijk_is_colour_set 'root'; then
		zstyle ':zim:prompt:tuurlijk:root' colour $rootColour
	fi
	if ! _prompt_tuurlijk_is_colour_set 'rootBg'; then
		zstyle ':zim:prompt:tuurlijk:rootBg' colour $rootColourBg
	fi
	if ! _prompt_tuurlijk_is_colour_set 'jobs'; then
		zstyle ':zim:prompt:tuurlijk:jobs' colour $jobsColour
	fi

	_prompt_tuurlijk_setup_git_styles

	# single quotes to prevent immediate execution
	PROMPT='${(e)$(_prompt_tuurlijk_main)}'
	RPROMPT='${(e)$(_prompt_tuurlijk_right)}'
	#RPROMPT='' # no initial prompt, set dynamically
}

prompt_tuurlijk_setup "$@"
