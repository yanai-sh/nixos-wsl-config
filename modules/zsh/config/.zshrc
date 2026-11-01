# Conventional user-authored Zsh configuration.

ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

for file in "$ZSH_CONFIG_DIR"/rc.d/*.zsh(N); do
  source "$file"
done

unset file ZSH_CONFIG_DIR
