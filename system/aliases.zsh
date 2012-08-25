# aliases for `ls`
LS=`(gls &>/dev/null && which gls) || which ls`
alias ls="$LS -F --color"
alias l="$LS -lAh --color"
alias ll="$LS -l --color"
alias la="$LS -A --color"
