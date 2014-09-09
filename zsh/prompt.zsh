autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! git status --porcelain &>/dev/null)
  then
    echo ""
  else
    if [[ $(git status --porcelain) == "" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

rb_prompt(){
  if (( $+commands[rbenv] )); then
    local version=$(rbenv version | awk '{ print $1; }')
    [[ $version != 'system' ]] && version="v$version"
    echo "[%{$fg_bold[red]%}ruby: %{$fg_bold[yellow]%}$version%{$reset_color%}] "
  else
    echo ""
  fi
}

nodejs_prompt() {
  if which nvm 2>&1 >/dev/null; then
    echo "[%{$fg_bold[green]%}node: %{$fg_bold[yellow]%}$(nvm ls | grep 'current:' | awk '{ print $2; }')%{$reset_color%}] "
  else
    echo ""
  fi
}

directory_name(){
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

exit_value() {
  test $? -ne 0 && echo "[%{$fg_bold[red]%}%?%{$reset_color%}]"
}

export PROMPT=$'\n$(rb_prompt)$(nodejs_prompt)in $(directory_name) $(git_dirty)$(need_push)\n› '
set_prompt () {
  export RPROMPT='$(exit_value)'
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
