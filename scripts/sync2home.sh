#!/bin/bash
bkp_path=$(dirname $(dirname "$(realpath "$0")"))
rsync -azP $bkp_path/.toprc $HOME/.toprc
rsync -azP $bkp_path/.vimrc $HOME/.vimrc
rsync -azP $bkp_path/.zshrc $HOME/.zshrc
rsync -azP $bkp_path/.tmux.conf $HOME/.tmux.conf
