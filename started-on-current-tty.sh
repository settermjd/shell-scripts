#!/usr/bin/env bash

# This is a short script to wrap up the logic of determining if a process was
# started on the current tty or not. It's reasonably simplistic in that it
# only prints out the process name and if it was started on the current tty, or
# if it wasn't started on this tty, which one it was started on. It could be 
# more robust, but it's enough for what I need right now.

# I've been spawning a number of VIM processes of late and then dropping to the
# terminal only to walk off and find that I've spawned a number but am not sure
# from which terminal they were spawned and where to end them. My intent is
# that this script will make it trivial to know if the process was started in
# the current terminal/tty. Sure, I could use pkill, but I find a script like
# this helpful from time to time.

function usage()
{
    echo "Usage: $0 <process to find>"
}

# Check that at least one argument has been provided
[ $# != 1 ] && ( usage && exit -1 ) || process=$1;

# Get the current tty
current_tty=$(tty)

echo "Looking for $process:"
echo 
for i in $(ps | grep $process | awk '{ print $2 }'); 
do 
    [[ ${current_tty:5} == $i ]] \
        && echo " - $process was started on this tty (${current_tty:5})" \
        || echo " - $process was not started on this tty (${current_tty:5}). It was started on $i"
done;
