#!/usr/bin/env sh

source requirements.sh

DEPS=""
function read_deps() {
	for dep in "${deps[@]}"; do
		DEPS+="$dep "
	done
}

if [ "$EUID" -eq 0 ]; then
	echo "This script should not be run as root." 1>&2
	exit 1
fi
if [ "$PWD" -eq "$HOME/.config/dotfiles" ]; then
	echo "You have installed this in the wrong directory." 1>&2
	echo "Please reinstall into $HOME/.config/dotfiles." 1>&2
	exit 1
fi

if [ -e /etc/fedora-release ]; then
	FEDORA=$(cut /etc/fedora-release -d \' \' -f 3)
	if [ "$FEDORA" -ne "23" ]; then
		echo "Fedora $FEDORA is not suppored. " 1>&2
		echo "Installing anyways ..." 1>&2
	fi
	read_deps()
	sudo dnf install --assumeyes $DEPS
	ln -s $HOME/.config/dotfiles/tmux/tmux.conf $HOME/.tmux.conf
	ln -s $HOME/.config/dotfiles/vim $HOME/.vim
	ln -s $HOME/.vim/vimrc $HOME/.vimrc
else
	echo "You are not running Fedora. " 1>&2
	echo "Please upgrade to the superior OS." 1>&2
fi

