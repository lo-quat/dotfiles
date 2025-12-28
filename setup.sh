#!/bin/zsh

SOURCE_LINE="source ~/dotfiles/.zshrc"
ZSHRC_PATH="$HOME/.zshrc"

if [[ -f "$ZSHRC_PATH" ]] && grep -Fxq "$SOURCE_LINE" "$ZSHRC_PATH"; then
    echo "✓ $ZSHRC_PATH already sources dotfiles/.zshrc"
else
    echo "$SOURCE_LINE" >> "$ZSHRC_PATH"
    echo "✓ Added source line to $ZSHRC_PATH"
fi

mkdir -p ~/.config

if [ ! -L ~/.config/tmux ]; then
    ln -s ~/dotfiles/.config/tmux ~/.config/tmux
    echo "✓ Created tmux symlink"
fi

if [ ! -L ~/.config/nvim ]; then
    ln -s ~/dotfiles/.config/nvim ~/.config/nvim
    echo "✓ Created nvim symlink"
fi

if [ ! -L ~/.gitconfig ]; then
    ln -s ~/dotfiles/.gitconfig ~/.gitconfig
    echo "✓ Created gitconfig symlink"
fi

if [ ! -L ~/.aerospace.toml ]; then
    ln -s ~/dotfiles/.aerospace.toml ~/.aerospace.toml
    echo "✓ Created aerospace symlink"
fi

if [ ! -L ~/.config/wezterm ]; then
    ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm
    echo "✓ Created wezterm symlink"
fi

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✓ Homebrew already installed"
fi

# Install packages via Homebrew
PACKAGES=(neovim wezterm tmux font-jetbrains-mono-nerd-font fzf nodenv powerlevel10k ripgrep nikitabobko/tap/aerospace felixkratz/formulae/borders)

for package in "${PACKAGES[@]}"; do
    if brew list "$package" &> /dev/null || brew list --cask "$package" &> /dev/null; then
        echo "✓ $package already installed"
    else
        brew install "$package"
    fi
done

# Install Node.js 22.15.0 via nodenv if not already installed
if command -v nodenv &> /dev/null; then
    if nodenv versions | grep -q "22.15.0"; then
        echo "✓ Node.js 22.15.0 already installed"
    else
        nodenv install 22.15.0
    fi
else
    echo "⚠ nodenv not available, skipping Node.js installation"
fi

echo ""
echo ""
echo "  ███████╗███████╗████████╗██╗   ██╗██████╗     ██████╗  ██████╗ ███╗   ██╗███████╗"
echo "  ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗    ██╔══██╗██╔═══██╗████╗  ██║██╔════╝"
echo "  ███████╗█████╗     ██║   ██║   ██║██████╔╝    ██║  ██║██║   ██║██╔██╗ ██║█████╗  "
echo "  ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝     ██║  ██║██║   ██║██║╚██╗██║██╔══╝  "
echo "  ███████║███████╗   ██║   ╚██████╔╝██║         ██████╔╝╚██████╔╝██║ ╚████║███████╗"
echo "  ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝"
echo ""
echo "  Please restart your terminal or run 'source ~/.zshrc'"
