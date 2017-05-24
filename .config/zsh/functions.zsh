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
	zcompare ${ZDOTDIR:-${HOME}}/.secrets.zsh

	# zcompile .zshrc
	zcompare ${ZDOTDIR:-${HOME}}/.zshrc

	zsh_mods=${ZDOTDIR:-${HOME}}/.config/zsh/
	# zcompile all .zsh files in the zsh config dir
	for file in ${zsh_mods}/**/${~zsh_glob}; do
		zcompare ${file}
	done

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
	pushd "${ZDOTDIR:-${HOME}}/dotfiles/"
	git pull
	if (( $? )) then
		echo
		git status --short
		echo
		e_error "(ノ°Д°）ノ︵ ┻━┻)"
		popd
		return 1
	else
		./setup.sh
	fi
	popd
}

# Load all custom settings from one cached file
recreateCachedSettingsFile() {
	setopt EXTENDED_GLOB
	local cachedSettingsFile=${ZDOTDIR:-${HOME}}/.config/zsh/cache/settings.zsh
	local ohMyGlob='(alias|completion|env|functions|style).zsh(D)'
	local recreateCache=false
	if [[ ! -s ${cachedSettingsFile} ]]; then
		recreateCache=true
	else
		for rcFile in ${ZDOTDIR:-${HOME}}/.config/zsh/${~ohMyGlob}; do
			if [[ -s $rcFile && $rcFile -nt $cachedSettingsFile ]]; then
				recreateCache=true
			fi
		done
	fi
	if [[ "$recreateCache" = true ]]; then
		touch $cachedSettingsFile
		echo > $cachedSettingsFile
		for rcFile in ${ZDOTDIR:-${HOME}}/.config/zsh/${~ohMyGlob}; do
			echo "# $rcFile:" >> $cachedSettingsFile
			echo "#"          >> $cachedSettingsFile
			cat $rcFile       >> $cachedSettingsFile
		done
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

