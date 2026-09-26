#! /bin/sh

alias stowcmd='stow -t $HOME --verbose=2'

# this needs to be the directory the dotfiles subdirectories are in.
DOTFILES=$(pwd)

pushd "$DOTFILES" 

echo "beginning the deployment process !"

stowcmd --no-folding pi
echo
stowcmd scripts
echo
stowcmd zsh
echo
stowcmd misc
echo
stow -t "$HOME/.config" --verbose=2 config
echo

case "$(hostname)" in
  skinny)
    stow -t "$HOME" --verbose=2 host-skinny
    echo
    ;;
esac

unzip "$(ls fonts/*.zip)" -d fonts -f
mkdir -pv ~/.local/share/fonts
stow --verbose=2 -t "$HOME/.local/share/fonts" fonts


# mkdir -pv vim/.vim/backup
# mkdir -pv vim/.vim/undo
# mkdir -pv vim/.vim/swap
# mkdir -pv vim/.vim/netrw
# 
# vim +PlugInstall +qall!

# ZPLUGIN="$HOME/dotfiles/zsh/.zplugin/bin"
# if [ ! -d "$ZPLUGIN" ]; then
#   echo "Setting up zplugin first-time install"
#   git clone https://github.com/zdharma/zplugin.git "$ZPLUGIN"
# fi

popd
