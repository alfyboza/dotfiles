if [[ ! -o interactive ]]; then
    return
elif (( $+commands[npm] )); then
  . <(npm completion)
fi

