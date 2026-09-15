# Bureau Theme (standalone, %F{} syntax)

### Git [±master ▾●]

ZSH_THEME_GIT_PROMPT_PREFIX="[%B%F{green}±%f%F{white}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f]"
ZSH_THEME_GIT_PROMPT_CLEAN="%B%F{green}✓%f"
ZSH_THEME_GIT_PROMPT_AHEAD="%F{cyan}▴%f"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{magenta}▾%f"
ZSH_THEME_GIT_PROMPT_STAGED="%B%F{green}●%f"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%B%F{yellow}●%f"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%B%F{red}●%f"
ZSH_THEME_GIT_PROMPT_STASHED="(%B%F{blue}✹%f)"

bureau_git_info () {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

bureau_git_status() {
  local result gitstatus
  gitstatus="$(command git status --porcelain -b 2>/dev/null)"

  local gitfiles="$(tail -n +2 <<< "$gitstatus")"
  if [[ -n "$gitfiles" ]]; then
    if [[ "$gitfiles" =~ $'(^|\n)[AMRD]. ' ]]; then
      result+="$ZSH_THEME_GIT_PROMPT_STAGED"
    fi
    if [[ "$gitfiles" =~ $'(^|\n).[MTD] ' ]]; then
      result+="$ZSH_THEME_GIT_PROMPT_UNSTAGED"
    fi
    if [[ "$gitfiles" =~ $'(^|\n)\\?\\? ' ]]; then
      result+="$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    fi
    if [[ "$gitfiles" =~ $'(^|\n)UU ' ]]; then
      result+="$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi
  else
    result+="$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  local gitbranch="$(head -n 1 <<< "$gitstatus")"
  if [[ "$gitbranch" =~ '^## .*ahead' ]]; then
    result+="$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if [[ "$gitbranch" =~ '^## .*behind' ]]; then
    result+="$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if [[ "$gitbranch" =~ '^## .*diverged' ]]; then
    result+="$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  if command git rev-parse --verify refs/stash &> /dev/null; then
    result+="$ZSH_THEME_GIT_PROMPT_STASHED"
  fi

  echo $result
}

bureau_git_prompt() {
  if ! command git rev-parse --git-dir &> /dev/null; then
    return
  fi

  local gitinfo=$(bureau_git_info)
  if [[ -z "$gitinfo" ]]; then
    return
  fi

  local output="${gitinfo:gs/%/%%}"
  local gitstatus=$(bureau_git_status)

  if [[ -n "$gitstatus" ]]; then
    output+=" $gitstatus"
  fi

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${output}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}


_PATH="%B%F{white}%~%f"

if [[ $EUID -eq 0 ]]; then
  _USERNAME="%B%F{red}%n"
  _LIBERTY="%F{red}#%f"
else
  _USERNAME="%B%F{white}%n"
  _LIBERTY="%F{green}$%f"
fi

_USERNAME="%f$_USERNAME%f@%m"
_LIBERTY="$_LIBERTY"

_1LEFT="$_USERNAME $_PATH"

bureau_precmd () {
  print
  print -rP "$_1LEFT"

  local gitinfo=$(bureau_git_prompt)

  if [[ -n "$gitinfo" ]]; then
    print -rP "$gitinfo"
  fi
}

setopt prompt_subst

PROMPT='> $_LIBERTY '

RPROMPT=''

autoload -U add-zsh-hook
add-zsh-hook precmd bureau_precmd
