#!/bin/sh
# cdgo.sh - A script to change directories to specific Go projects

# cdsk sujaykumarsuman
cdsk() {
  cd "$GOPATH/src/github.com/sujaykumarsuman/$1"
}

_cdsk_completion() {
  local projects
  projects=($(command ls "$GOPATH/src/github.com/sujaykumarsuman" 2>/dev/null))
  compadd -- "${projects[@]}"
}

_cdsk_bash_completion() {
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi
  local projects
  projects=$(command ls "$GOPATH/src/github.com/sujaykumarsuman" 2>/dev/null)
  COMPREPLY=($(compgen -W "${projects}" -- "${COMP_WORDS[1]}"))
}

# skriptvalley
cdvalley() {
  cd "$GOPATH/src/github.com/skriptvalley/$1"
}

_cdvalley_completion() {
  local projects
  projects=($(command ls "$GOPATH/src/github.com/skriptvalley" 2>/dev/null))
  compadd -- "${projects[@]}"
}

_cdvalley_bash_completion() {
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi
  local projects
  projects=$(command ls "$GOPATH/src/github.com/skriptvalley" 2>/dev/null)
  COMPREPLY=($(compgen -W "${projects}" -- "${COMP_WORDS[1]}"))
}

# Register completions
if [[ -n $ZSH_VERSION ]]; then
  compdef _cdsk_completion cdsk
  compdef _cdvalley_completion cdvalley
else
  complete -F _cdsk_bash_completion cdsk
  complete -F _cdvalley_bash_completion cdvalley
fi