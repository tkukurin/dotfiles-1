# Function to determine the need of a zcompile. If the .zwc file
# does not exist, or the base file is newer, we need to compile.
# man zshbuiltins: zcompile
zcompare() {
	if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
		zcompile ${1}
	fi
}

# The following code helps us by optimizing the existing framework.
# This includes zcompile, zcompdump, etc.
compileAllTheThings () {
	setopt EXTENDED_GLOB
	local zsh_glob='^(.git*|LICENSE|README.md|*.zwc)(.)'

	# zcompile the completion cache; siginificant speedup.
	for file in ${ZDOTDIR:-${HOME}}/.zcomp${~zsh_glob}; do
		zcompare ${file}
	done

	# zcompile .zshrc
	zcompare ${ZDOTDIR:-${HOME}}/.zshrc

	# Zgen
	zgen_mods=${ZDOTDIR:-${HOME}}/.zgen/
	zcompare ${zgen_mods}init.zsh
	zcompare ${zgen_mods}zgen.zsh
	for dir ('/zsh-users/' '/zdharma/' '/robbyrussell/oh-my-zsh-master/plugins/shrink-path/'); do
		if [ -d "${zgen_mods}${dir}" ]; then
			for file in ${zgen_mods}${dir}**/*.zsh; do
				zcompare ${file}
			done
		fi
	done
}

# Update dotfiles
rd () {
	e_header "Updating dotfiles..."
	pushd -q "${ZDOTDIR:-${HOME}}/dotfiles/"
	git pull
	if (( $? )) then
		echo
		git status --short
		echo
		e_error "(ノ°Д°）ノ︵ ┻━┻)"
		popd -q
		return 1
	else
		./setup.sh
	fi
	popd -q
}

# Load all custom settings from one cached file
recreateCachedSettingsFile() {
	setopt EXTENDED_GLOB
	local cachedSettingsFile=${ZDOTDIR:-${HOME}}/.config/zsh/cache/settings.zsh
	local recreateCache=false
	local rcFiles
	if [[ ! -s ${cachedSettingsFile} ]]; then
		recreateCache=true
	else
		rcFiles=(${ZDOTDIR:-${HOME}}/.zgen/init.zsh)
		rcFiles+=(${ZDOTDIR:-${HOME}}/.config/zsh/*.zsh)
		rcFiles+=(${ZDOTDIR:-${HOME}}/.secrets.zsh)
		for rcFile in $rcFiles; do
			if [[ -s $rcFile && $rcFile -nt $cachedSettingsFile ]]; then
				recreateCache=true
			fi
		done
	fi
	if [[ "$recreateCache" = true ]]; then
		touch $cachedSettingsFile
		echo "# This file is generated automatically, do not edit by hand!" > $cachedSettingsFile
		echo "# Edit the files in ~/.config/zsh instead!" >> $cachedSettingsFile
		# Zgen
		if [[ -s ${ZDOTDIR:-${HOME}}/.zgen/init.zsh ]]; then
			echo ""               >> $cachedSettingsFile
			echo "#"              >> $cachedSettingsFile
			echo "# Zgen:"        >> $cachedSettingsFile
			echo "#"              >> $cachedSettingsFile
			cat ${ZDOTDIR:-${HOME}}/.zgen/init.zsh >> $cachedSettingsFile
		fi
		# Rc files
		for rcFile in ${ZDOTDIR:-${HOME}}/.config/zsh/*.zsh; do
			echo ""               >> $cachedSettingsFile
			echo "#"              >> $cachedSettingsFile
			echo "# ${rcFile:t}:" >> $cachedSettingsFile
			echo "#"              >> $cachedSettingsFile
			cat $rcFile           >> $cachedSettingsFile
		done
		# Secrets
		if [ -s ${ZDOTDIR:-${HOME}}/.secrets.zsh ]; then
			echo ""               >> $cachedSettingsFile
			echo "#"              >> $cachedSettingsFile
			echo "# Secrets:"     >> $cachedSettingsFile
			echo "#"              >> $cachedSettingsFile
			cat ${ZDOTDIR:-${HOME}}/.secrets.zsh >> $cachedSettingsFile
		fi
		zcompile $cachedSettingsFile
	fi
}

# Gather external ip address
exip () {
	e_header "Current External IP: "
	curl -s -m 5 http://ipv4.myip.dk/api/info/IPv4Address | sed -e 's/"//g'
}

# Determine local IP address
ips () {
	ifconfig | grep "inet " | awk '{ print $2 }'
}

# Create directory and cd into it
mkcd() {
	if [[ ! -n "$1" ]]; then
		echo "Usage: mkcd [directory]"
	elif [ -d $1 ]; then
		echo "'$1' already exists"
		cd "${1}"
	else
		mkdir -p "${1}" && cd "${1}"
	fi
}

# Remove last segment of path
backward-kill-dir () {
	local WORDCHARS=${WORDCHARS/\/}
	zle backward-kill-word
}
zle -N backward-kill-dir