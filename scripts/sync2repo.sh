#!/bin/bash
bkp_path=$(dirname $(dirname "$(realpath "$0")"))
rsync -azP $HOME/.config/procps/toprc $bkp_path/.toprc
rsync -azP $HOME/.vimrc $bkp_path
rsync -azP $HOME/.zshrc $bkp_path
rsync -azP $HOME/.tmux.conf $bkp_path
