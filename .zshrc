# 补全系统
autoload -Uz compinit && compinit

# 历史设置
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS

# 快捷键
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^F' forward-word
bindkey '^B' backward-word

# 插件
ZSH_CUSTOM="$HOME/.config/zsh"
source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_CUSTOM/plugins/z/z.plugin.zsh
source $ZSH_CUSTOM/plugins/git/git.plugin.zsh
source $ZSH_CUSTOM/plugins/sudo/sudo.plugin.zsh
source $ZSH_CUSTOM/plugins/history/history.plugin.zsh

# 主题
source $ZSH_CUSTOM/themes/bureau.zsh-theme

# autosuggest 样式
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#666666'

# PATH
export PATH="/home/zcx0217/.opencode/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

# 别名
alias clear='clear && zsh'
alias zfresh='clear && source ~/.zshrc'
alias zfetch='fastfetch --disable-linewrap true && bash ~/.config/fastfetch/hitokoto.sh'
alias oc='opencode'
zfetch

# Make / CMake / Ninja
export MAKEFLAGS="-j8"
export CMAKE_BUILD_PARALLEL_LEVEL=8
export NINJAFLAGS="-j8"

# fnm
FNM_PATH="/home/zcx0217/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

# pnpm
export PNPM_HOME="/home/zcx0217/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# clash
export CLASHCTL_HOME=~/.local/applications/clash
. $CLASHCTL_HOME/scripts/cmd/clashctl.sh
