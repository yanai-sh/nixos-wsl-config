# Core utilities
alias cat='bat'
alias spf='superfile'

# Eza
alias ls='eza --group-directories-first --icons=auto --color=auto'

alias l='eza -blF --git --header --group-directories-first --icons=auto --color=auto'
alias ll='eza -la --git --header --octal-permissions --group-directories-first --icons=auto --color=auto'
alias la='eza -la --git --header --group-directories-first --icons=auto --color=auto'
alias lm='eza -l --git --header --sort=modified --reverse --group-directories-first --icons=auto --color=auto'

alias l1='eza --oneline --group-directories-first --icons=auto --color=auto'
alias lt='eza --tree --level=2 --group-directories-first --icons=auto --color=auto'
alias l.='eza -a --oneline --color=never | grep -E "^\."'

# Rollback is not `nh clean` and not `nh os switch --rollback`.
alias nh-rollback='nh os rollback'
