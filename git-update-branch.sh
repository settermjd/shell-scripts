#!/usr/bin/env bash

#
# This script simplifies the process of updating a branch to the latest version
# from the remote.  At this stage, it's rather simplistic, in that it assumes
# that the branch exists. It doesn't perform any branch validation.
#

set -e
set -o noclobber
set -o errexit
set -o pipefail
set -o nounset

ERR_INSUFFICIENT_ARGS=85

function usage()
{
    echo "Usage: update-branch <branch name>[, <branch name>...]"
}

function get_current_branch_name()
{
    echo $(git rev-parse --abbrev-ref HEAD)
}

function update_branch()
{
    local branch_name="$1"

    if [[ "$(get_current_branch_name)" != "${branch_name}" ]]; then
        git checkout "${branch_name}"
    fi 

    git reset --hard origin/"${branch_name}"
}

(( $# == 0 )) && usage && exit $ERR_INSUFFICIENT_ARGS

# Update the local clone of the repository
git fetch origin

for branch in "${@:1}"
do
    echo "Updating branch -> $branch"
    update_branch $branch
    echo
done
