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

# grbup checks out to the given branch (or the repo's default branch if none is provided),
# pulls the latest commits, then checks out back to the working branch and rebases onto it.
# if there are conflicts it will stop and ask the user to resolve them, once resolved it will continue the rebase process
grbup() {
    target_branch=$1
    if [ -z "$target_branch" ]; then
        target_branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5) || {
            echo "Failed to determine default branch."
            return 1
        }
    fi

    current_branch=$(git rev-parse --abbrev-ref HEAD) || {
        echo "Failed to determine current branch."
        return 1
    }
    
    if [ "$current_branch" = "$target_branch" ]; then
        echo "Already on branch $target_branch, pulling latest changes..."
        git pull origin "$target_branch"
        return $?
    fi
    
    echo "Checking out to branch $target_branch..."
    git checkout "$target_branch" || return 1
    
    echo "Pulling latest changes from $target_branch..."
    git pull origin "$target_branch" || return 1
    
    echo "Checking out back to working branch $current_branch..."
    git checkout "$current_branch" || return 1
    
    echo "Rebasing with $target_branch..."
    git rebase "$target_branch"

    if [ $? -ne 0 ]; then
        echo "Rebase failed due to conflicts. Please resolve the conflicts and continue the rebase process."
        return 1
    fi
    
    echo "Rebase successful!"
}


# gbcleanup checks for local branches that have been merged into the default branch and deletes them, 
# this is useful for keeping the local repository clean and organized, it also fetches the latest changes from the remote 
# to ensure that it has the most up-to-date information about which branches have been merged.
gbcleanup() {
    echo "Cleaning up local branches that have been merged into the default branch..."
    default_branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
    
    # Fetch the latest changes from the remote
    git fetch --prune
    
    # Get a list of local branches that have been merged into the default branch
    merged_branches=$(git branch --merged $default_branch | grep -v "\*" | grep -v "$default_branch")
    
    if [ -z "$merged_branches" ]; then
        echo "No local branches to clean up."
        return
    fi
    
    echo "The following local branches have been merged into $default_branch and will be deleted:"
    echo "$merged_branches"
    
    # Delete the merged branches
    echo "$merged_branches" | xargs git branch -d
}
