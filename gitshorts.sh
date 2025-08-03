#!/bin/sh

# gclone takes a repository ssh url and clones it into the $HOME/go/src/<remote>/<repo> directory.
# This also creates the necessary directories if they do not exist like remote, for ex if github.com does not exist
# it will create it.
# Usage: gclone <repository ssh url>

gclone() {
    if [ $# -eq 0 ]; then
        echo "Please provide repository ssh url"
        return
    fi
    
    repo_url=$1
    remote=$(echo $repo_url | cut -d':' -f1)
    # remove git@ from the remote
    remote=$(echo $remote | sed 's/git@//g')

    repo=$(echo $repo_url | cut -d':' -f2-)
    # remove the .git suffix if it exists
    repo=$(echo $repo | sed 's/\.git$//')
    
    # Create the necessary directories if they do not exist
    mkdir -p $HOME/go/src/$remote
    
    # Clone the repository
    git clone $repo_url $HOME/go/src/$remote/$repo
    echo "Cloned $repo into $HOME/go/src/$remote/$repo"
    cd $HOME/go/src/$remote/$repo
}
