dotfiles
========

My dotfiles `¯\_(ツ)_/¯`

Consist of:
* A `.vimrc` with all required [Plug](https://github.com/junegunn/vim-plug) modules.
* A `.zshrc` for use with [zim](https://github.com/Eriner/zim).
* A `.tmux.conf` for use with tmux
* And some other files

The entire setup is primarily meant for use with Mac OS X, but is set up to be generic, so it might benefit others as well.

An install script that generates the required symlinks and binaries is provided
for linux based systems. (Which may or may not work in your situation.)

## Prerequisites
* You have `zsh` installed
* You have `tmux` installed (`2.1`+ or you will have issues with the supplied
		`.tmux.conf` )
* You have `vim` installed (optionally compiled with `ruby` and `python` support)
* You have `ruby`, `ruby-devel`, `python` and `python-pip` installed - if you wish to use Command-T plugin in vim
* You will need a Powerline capable font: https://github.com/powerline/powerline
* `Exuberant Ctags`, as TagBar will not work with GNU ctags. On OSX: `brew install ctags`
* You have `UTF-8` locales installed, otherwise the `tmux` powerline setup will
fail.

## Installation
Installation on any Linux or OSX machine is pretty straightforward:

```
git clone https://github.com/tuurlijk/dotfiles "${ZDOTDIR:-$HOME}/dotfiles"
cd "${ZDOTDIR:-$HOME}/dotfiles"
./setup.sh

chsh -s /bin/zsh
```

This installer will also install `zim` for you.

On OSX you will also need a patched font for powerline to work right. The
required patched fonts are conveniently cloned along with this repository.
See the [font-installation manual for
powerline](https://powerline.readthedocs.org/en/latest/installation/linux.html#font-installation) for further instructions.

## Troubleshooting
It might be the case that the `Command-T` vim plugin causes a segfault on your system when you use the bootstrap script.
This is due to the fact that it was compiled for a different architecture than your vim.
See the [Command-T manual](http://git.wincent.com/command-t.git/blob_plain/HEAD:/doc/command-t.txt) for instructions.

Specifically:

````
 First you have to check the platform Vim was built for:

  vim --version
  ...
  Compilation: gcc ... -arch i386 ...
  ...

and make sure you use the correct ARCHFLAGS during compilation:

  export ARCHFLAGS="-arch i386"
  make
````
It also might be the case that powerline won't work in vim, showing:
````
An error occured while importing the Powerline package. This could be caused by an invalid sys.path setting, or by an incompatible Python version (Powerline requires Python 2.7 or 3.3+ to work). Please consult the troubleshooting section in the documentation for possible solutions.
````
In which case you'll have to run:
````
pip install --user -U git+git://github.com/Lokaltog/powerline
````
