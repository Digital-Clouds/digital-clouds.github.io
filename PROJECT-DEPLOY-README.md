GitHub Project Pages



Make sure your baseURL key-value in your site configuration reflects the full URL of your GitHub pages repository if you’re using the default GH Pages URL (e.g., <USERNAME>.github.io/<PROJECT>/) and not a custom domain.

Deployment of Project Pages from /docs folder on master branch



As described in the GitHub Pages documentation, you can deploy from a folder called docs/ on your master branch. To effectively use this feature with Hugo, you need to change the Hugo publish directory in your site’s config.toml and config.yaml, respectively:



publishDir = "docs"



publishDir: docs



After running hugo, push your master branch to the remote repository and choose the docs/ folder as the website source of your repo. Do the following from within your GitHub project:



    Go to Settings → GitHub Pages

    From Source, select “master branch /docs folder”. If the option isn’t enabled, you likely do not have a docs/ folder in the root of your project.



The docs/ option is the simplest approach but requires you set a publish directory in your site configuration. You cannot currently configure GitHub pages to publish from another directory on master, and not everyone prefers the output site live concomitantly with source files in version control.

Deployment of Project Pages From Your gh-pages branch



You can also tell GitHub pages to treat your master branch as the published site or point to a separate gh-pages branch. The latter approach is a bit more complex but has some advantages:



    It keeps your source and generated website in different branches and therefore maintains version control history for both.

    Unlike the preceding docs/ option, it uses the default public folder.



Preparations for gh-pages Branch



These steps only need to be done once. Replace upstream with the name of your remote; e.g., origin:

Add the public Folder



First, add the public folder to your .gitignore file at the project root so that the directory is ignored on the master branch:



echo "public" >> .gitignore



Initialize Your gh-pages Branch



You can now initialize your gh-pages branch as an empty orphan branch:



git checkout --orphan gh-pages

git reset --hard

git commit --allow-empty -m "Initializing gh-pages branch"

git push upstream gh-pages

git checkout master



Build and Deployment



Now check out the gh-pages branch into your public folder using git’s worktree feature. Essentially, the worktree allows you to have multiple branches of the same local repository to be checked out in different directories:



rm -rf public

git worktree add -B gh-pages public upstream/gh-pages



Regenerate the site using the hugo command and commit the generated files on the gh-pages branch:

commit-gh-pages-files.sh





hugo

cd public && git add --all && git commit -m "Publishing to gh-pages" && cd ..



If the changes in your local gh-pages branch look alright, push them to the remote repo:



git push upstream gh-pages



Set gh-pages as Your Publish Branch



In order to use your gh-pages branch as your publishing branch, you’ll need to configure the repository within the GitHub UI. This will likely happen automatically once GitHub realizes you’ve created this branch. You can also set the branch manually from within your GitHub project:



    Go to Settings → GitHub Pages

    From Source, select “gh-pages branch” and then Save. If the option isn’t enabled, you likely have not created the branch yet OR you have not pushed the branch from your local machine to the hosted repository on GitHub.



After a short while, you’ll see the updated contents on your GitHub Pages site.

Put it Into a Script



To automate these steps, you can create a script with the following contents:

publish_to_ghpages.sh





#!/bin/sh



if [ "`git status -s`" ]

then

    echo "The working directory is dirty. Please commit any pending changes."

    exit 1;

fi



echo "Deleting old publication"

rm -rf public

mkdir public

git worktree prune

rm -rf .git/worktrees/public/



echo "Checking out gh-pages branch into public"

git worktree add -B gh-pages public upstream/gh-pages



echo "Removing existing files"

rm -rf public/*



echo "Generating site"

hugo



echo "Updating gh-pages branch"

cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"



#echo "Pushing to github"

#git push --all



This will abort if there are pending changes in the working directory and also makes sure that all previously existing output files are removed. Adjust the script to taste, e.g. to include the final push to the remote repository if you don’t need to take a look at the gh-pages branch before pushing.

Deployment of Project Pages from Your master Branch



To use master as your publishing branch, you’ll need your rendered website to live at the root of the GitHub repository. Steps should be similar to that of the gh-pages branch, with the exception that you will create your GitHub repository with the public directory as the root. Note that this does not provide the same benefits of the gh-pages branch in keeping your source and output in separate, but version controlled, branches within the same repo.



You will also need to set master as your publishable branch from within the GitHub UI:



    Go to Settings → GitHub Pages

    From Source, select “master branch” and then Save.



Use a Custom Domain



If you’d like to use a custom domain for your GitHub Pages site, create a file static/CNAME. Your custom domain name should be the only contents inside CNAME. Since it’s inside static, the published site will contain the CNAME file at the root of the published site, which is a requirements of GitHub Pages.



Refer to the official documentation for custom domains for further information.
