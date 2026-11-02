# Shell history under XDG state, with dedupe and shared append.
hist_dir="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
mkdir -p "$hist_dir"
HISTFILE="$hist_dir/history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY INC_APPEND_HISTORY
unset hist_dir
