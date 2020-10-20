#!/bin/sh
########################
###Hugo Deploy To GitHub
###Salvydas Lukosius
########################
# If a command fails then the deploy
set -e
printf "\033[0;32mStarted Hugo Build Process\033[0m\n"

# build hugo
    hugo

 cd public
 
printf "\033[0;32mGit Deploy Initialised\033[0m\n"

# make repository
# git init
# git remote add origin $url
 git add .
 
 msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
 git commit -m "$msg"
 git push -u origin master

 printf "\033[0;32mSuccesfull\033[0m\n"
 
