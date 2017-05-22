#
# startup file read in interactive login shells
#
# The following code helps us by optimizing the existing framework.
# This includes zcompile, zcompdump, etc.
#

(
# Function to determine the need of a zcompile. If the .zwc file
# does not exist, or the base file is newer, we need to compile.
# These jobs are asynchronous, and will not impact the interactive shell
zcompare() {
	if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
		zcompile ${1}
	fi
}

setopt EXTENDED_GLOB
local zsh_glob='^(.git*|LICENSE|README.md|*.zwc)(.)'

# zcompile the completion cache; siginificant speedup.
for file in ${ZDOTDIR:-${HOME}}/.zcomp${~zsh_glob}; do
	zcompare ${file}
done

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

) &!
