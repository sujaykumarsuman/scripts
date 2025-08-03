#!/bin/sh
# cdgo.sh - A script to change directories to specific Go projects

# cdsk sujaykumarsuman
cdsk() {
  if [ $# -eq 0 ]; then
    echo "Please provide repository name"
    return
  fi
  cd $GOPATH/src/github.com/sujaykumarsuman/$1
}

_cdsk_completion() {
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  projects=$(ls $GOPATH/src/github.com/sujaykumarsuman)

  COMPREPLY=($(compgen -W "${projects}" -- "${COMP_WORDS[1]}"))
}

complete -F _cdsk_completion cdsk

# skriptvalley
cdvalley() {
  if [ $# -eq 0 ]; then
    echo "Please provide repository name"
    return
  fi
  cd $GOPATH/src/github.com/skriptvalley/$1
}

_cdvalley_completion() {
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  projects=$(ls $GOPATH/src/github.com/skriptvalley)

  COMPREPLY=($(compgen -W "${projects}" -- "${COMP_WORDS[1]}"))
}

complete -F _cdvalley_completion cdvalley
