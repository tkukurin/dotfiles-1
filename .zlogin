#
# startup file read in interactive login shells
#
# Re-create cached files if needed
(compileAllTheThings) &!

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
