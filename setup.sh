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

if [ ! -L ~/.config/ghostty ]; then
    ln -s ~/dotfiles/.config/ghostty ~/.config/ghostty
    echo "✓ Created ghostty symlink"
fi

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

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✓ Homebrew already installed"
fi

# Add third-party taps
if ! brew tap | grep -q "daipeihust/tap"; then
    brew tap daipeihust/tap
else
    echo "✓ daipeihust/tap already tapped"
fi

# Install packages via Homebrew
PACKAGES=(neovim tmux font-jetbrains-mono-nerd-font fzf ripgrep ghostty jq)

for package in "${PACKAGES[@]}"; do
    if brew list "$package" &> /dev/null || brew list --cask "$package" &> /dev/null; then
        echo "✓ $package already installed"
    else
        brew install "$package"
    fi
done

# Claude Code: hook scripts
mkdir -p ~/.claude/hooks ~/.claude/skills
for hook in ~/dotfiles/.claude-global/hooks/*.sh; do
    target=~/.claude/hooks/$(basename "$hook")
    if [ ! -L "$target" ]; then
        ln -s "$hook" "$target"
        echo "✓ Created Claude hook symlink: $(basename "$hook")"
    fi
done

# Claude Code: register hooks from .claude-global/hooks.json into settings.json
# (merges only missing entries; other settings in settings.json are kept)
CLAUDE_SETTINGS=~/.claude/settings.json
[ -f "$CLAUDE_SETTINGS" ] || echo '{}' > "$CLAUDE_SETTINGS"
merged=$(jq -s '
  .[0] as $s | .[1].hooks as $add
  | $s | .hooks = reduce ($add | to_entries[]) as $e ($s.hooks // {};
      .[$e.key] = ((.[$e.key] // []) as $cur
        | $cur + [$e.value[] | select(. as $x | $cur | any(. == $x) | not)]))
' "$CLAUDE_SETTINGS" ~/dotfiles/.claude-global/hooks.json) || { echo "✗ Failed to merge Claude hooks"; exit 1; }
if [ "$merged" != "$(jq . "$CLAUDE_SETTINGS")" ]; then
    cp "$CLAUDE_SETTINGS" "$CLAUDE_SETTINGS.bak"
    printf '%s\n' "$merged" > "$CLAUDE_SETTINGS"
    echo "✓ Registered Claude hooks in settings.json (backup: settings.json.bak)"
else
    echo "✓ Claude hooks already registered"
fi

# Claude Code: apply settings from .claude-global/settings.json (deep merge; dotfiles values win)
merged=$(jq -s '.[0] * .[1]' "$CLAUDE_SETTINGS" ~/dotfiles/.claude-global/settings.json) || { echo "✗ Failed to merge Claude settings"; exit 1; }
if [ "$merged" != "$(jq . "$CLAUDE_SETTINGS")" ]; then
    cp "$CLAUDE_SETTINGS" "$CLAUDE_SETTINGS.bak"
    printf '%s\n' "$merged" > "$CLAUDE_SETTINGS"
    echo "✓ Applied Claude settings to settings.json (backup: settings.json.bak)"
else
    echo "✓ Claude settings already applied"
fi

# Claude Code: skills bundled with Hunk (installed separately)
for skill in hunk-review hunk-extensions; do
    if [ -d ~/.hunk/skills/$skill ] && [ ! -L ~/.claude/skills/$skill ]; then
        ln -s ~/.hunk/skills/$skill ~/.claude/skills/$skill
        echo "✓ Created Claude skill symlink: $skill"
    fi
done
if ! command -v hunk &> /dev/null && [ ! -x ~/.hunk/bin/hunk ]; then
    echo "⚠ hunk is not installed: Hunk review hooks/skills will not work until it is"
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
