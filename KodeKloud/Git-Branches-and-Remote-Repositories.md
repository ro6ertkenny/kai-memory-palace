# Git - Branches and Remote Repositories

1.0 Branch <----> 1.1 Branch
           Merging

Master Branch is the 'default one' that Git works with

#### git branch 1.1-testing

#### git branch --delete (name of the branch)

#### git branch --list
#### git branch
    1.1-testing
    * master

The * shows us the one that is currently selected

To switch to the 1.1-testing branch run:

#### git checkout 1.1-testing


You can skip the add by doing the following:

#### git commit -a -m "some commit message here"


#### git log

Shows what other team members did in this project

#### git log --raw

Shows what files were actually changed

Has a commit hash that you can copy and paste to get more details

#### git show (the first few letters of the hash)

### (HEAD -> master)

To merge 1.1-testing branch into master run the following from master:

#### git checkout master

#### git merge 1.1-testing

## REMOTE REPOSITORIES

use ssh key login in GitHub

check the hidden git directory:

#### git remote -v

#### git remote add origin git@github.com:jeremykodekloud/kkproject.git

#### git remote -v
    origin git@github ... (fetch)
    origin git@github ... (push)

## Configure the SSH keys that will let you login to this repo:

#### ssh-keygen

#### cat ~/.ssh/id_ed25519.pub

    Copy the entire output of this text and paste it into GitHub (settings/SSH and GPG keys)

    New SSH Key

        Authentication Key

        Paste Key 

#### git push origin master

#### git pull origin master

** New member wants to start on a new project **

#### git clone git@github.com:jerem ...

Git is a powerful tool with a wide range of features. If you ever need assistance or a reminder of a command’s options, simply type “git” and press the tab key twice to see a list of commands. For in-depth information on any command, you can consult the manual pages:

#### man git-add

ro6ert@ro6bx:~/Documents/LINUX/KodeKloud/Git-Branches-and-Remote-Repositories$ ls
Git-Branches-10.png  Git-Branches-8.png       git-merge.png
Git-Branches-11.png  Git-Branches-9.png       git-push-origin-master.png
Git-Branches-1.png   git-clone.png            git-remote-add-origin.png
Git-Branches-2.png   git-github-ssh-key.png   git-show.png
Git-Branches-3.png   Git-Head.png             git-tab-key.png
Git-Branches-4.png   github-clone.png         ssh-keygen.png
Git-Branches-5.png   git-log-commit-hash.png  ssh-key-github-1.png
Git-Branches-6.png   git-log.png              ssh-key-github-2.png
Git-Branches-7.png   git-log-raw.png

