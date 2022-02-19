cdgo() {
  if [ $# -eq 0 ]; then
    echo "Please provide repository name"
    return
  fi
  cd $GOPATH/src/github.com/sujaykumarsuman/$1
}
