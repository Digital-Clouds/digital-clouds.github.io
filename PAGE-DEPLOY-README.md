Step-by-step Instructions



    Create a <YOUR-PROJECT> (e.g. blog) repository on GitHub. This repository will contain Hugo’s content and other source files.

    Create a <USERNAME>.github.io GitHub repository. This is the repository that will contain the fully rendered version of your Hugo website.

    git clone <YOUR-PROJECT-URL> && cd <YOUR-PROJECT>

    Paste your existing Hugo project into the new local <YOUR-PROJECT> repository. Make sure your website works locally (hugo server or hugo server -t <YOURTHEME>) and open your browser to http://localhost:1313.

    Once you are happy with the results:

        Press Ctrl+C to kill the server

        Before proceeding run rm -rf public to completely remove the public directory

    git submodule add -b master https://github.com/<USERNAME>/<USERNAME>.github.io.git public. This creates a git submodule. Now when you run the hugo command to build your site to public, the created public directory will have a different remote origin (i.e. hosted GitHub repository).

    Make sure the baseURL in your config file is updated with: <USERNAME>.github.io

    Put it Into a Script



You’re almost done. In order to automate next steps create a deploy.sh script. You can also make it executable with chmod +x deploy.sh.



The following are the contents of the deploy.sh script:



#!/bin/sh



# If a command fails then the deploy stops

set -e



printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"



# Build the project.

hugo # if using a theme, replace with `hugo -t <YOURTHEME>`



# Go To Public folder

cd public



# Add changes to git.

git add .



# Commit changes.

msg="rebuilding site $(date)"

if [ -n "$*" ]; then

	msg="$*"

fi

git commit -m "$msg"



# Push source and build repos.

git push origin master



You can then run ./deploy.sh "Your optional commit message" to send changes to <USERNAME>.github.io. Note that you likely will want to commit changes to your <YOUR-PROJECT> repository as well.



That’s it! Your personal page should be up and running at https://<USERNAME>.github.io within a couple minutes.
