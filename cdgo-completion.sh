#!/bin/sh
_cdgo_completion() {
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  projects=$(ls $GOPATH/src/github.com/sujaykumarsuman)

  COMPREPLY=($(compgen -W "${projects}" -- "${COMP_WORDS[1]}"))
}

complete -F _cdgo_completion cdgo
