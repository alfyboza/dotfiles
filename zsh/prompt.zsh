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
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
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

# This keeps the number of todos always available the right hand side of my
# command line. I filter it to only count those tagged as "+next", so it's more
# of a motivation to clear out the list.
todo(){
  if (( $+commands[todo.sh] ))
  then
    num=$(echo $(todo.sh ls +next | wc -l))
    let todos=num-2
    if [ $todos != 0 ]
    then
      echo "$todos"
    else
      echo ""
    fi
  else
    echo ""
  fi
}

directory_name(){
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

export PROMPT=$'\n$(rb_prompt)$(nodejs_prompt)in $(directory_name) $(git_dirty)$(need_push)\n› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}$(todo)%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
