#!/bin/zsh

mkdir -p ~/.config

if [ ! -L ~/.aerospace.toml ]; then
    ln -s ~/dotfiles/.aerospace.toml ~/.aerospace.toml
    echo "✓ Created aerospace symlink"
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "⚠ Homebrew is not installed. Please run setup.sh first or install Homebrew manually."
    exit 1
else
    echo "✓ Homebrew is installed"
fi

# Install window manager packages via Homebrew
PACKAGES=(nikitabobko/tap/aerospace felixkratz/formulae/borders)

for package in "${PACKAGES[@]}"; do
    if brew list "$package" &> /dev/null || brew list --cask "$package" &> /dev/null; then
        echo "✓ $package already installed"
    else
        brew install "$package"
    fi
done

echo ""
echo "  ██╗    ██╗███╗   ███╗    ███████╗███████╗████████╗██╗   ██╗██████╗     ██████╗  ██████╗ ███╗   ██╗███████╗"
echo "  ██║    ██║████╗ ████║    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗    ██╔══██╗██╔═══██╗████╗  ██║██╔════╝"
echo "  ██║ █╗ ██║██╔████╔██║    ███████╗█████╗     ██║   ██║   ██║██████╔╝    ██║  ██║██║   ██║██╔██╗ ██║█████╗  "
echo "  ██║███╗██║██║╚██╔╝██║    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝     ██║  ██║██║   ██║██║╚██╗██║██╔══╝  "
echo "  ╚███╔███╔╝██║ ╚═╝ ██║    ███████║███████╗   ██║   ╚██████╔╝██║         ██████╔╝╚██████╔╝██║ ╚████║███████╗"
echo "   ╚══╝╚══╝ ╚═╝     ╚═╝    ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝"
echo ""
echo "  Window manager setup complete!"
echo "  Please restart AeroSpace or log out and back in for changes to take effect."
echo ""
