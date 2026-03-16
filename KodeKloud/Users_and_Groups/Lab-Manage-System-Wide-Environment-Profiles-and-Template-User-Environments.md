# Lab - Manage System-Wide Environment Profiles and Template User Environments

## Task:

How can we print the value of an environment variable?

## Solution:

We can print the value of an environment variable using echo $MYVAR command.


## Task:

Which of the following environment variables holds the value of user's home directory?

## Solution:

$HOME environment variable holds the value of user's home directory.


## Task:

Which of the following files can be used to set the globally available environment variables in a Linux-based system?

## Solution:

The /etc/environment file can be used to set the globally available environment variables in a Linux-based system.


## Task:

Print our current user's (bob) environment and save the output in the /home/bob/env file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/env

Check bob's env.

## Solution:

Execute the below command:

#### env > /home/bob/env


## Task:

Add an environment variable for user bob.

The variable name should be MYVAR and its value should be TRUE

Is the required environment variable set for user bob?

## Solution:

Edit .bashrc file:

#### vi ~/.bashrc

add the variable at the end of the file:

#### export MYVAR=TRUE

save the file and run:

#### source ~/.bashrc


## Task:

Identify the value of GLOBALENV environment variable and save it in the /home/bob/globalenv file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/globalenv

Is GLOBALENV environment variable value saved in the /home/bob/globalenv file?

## Solution:

Execute the below command:

#### echo $GLOBALENV > /home/bob/globalenv


## Task:

Whenever we add a new user to the system, some files are copied from a template directory to the user's home directory.

Manually copy those files into the /home/bob/default_data directory.

Is required data copied?


## Solution:

Execute the below command:

#### sudo cp /etc/skel/.bash* /home/bob/default_data/


## Task:

Modify the system-wide environment file and make sure that the variable GLOBALOPTION is set to this value: ON. Otherwise, after you modify that file, any user that logs in and types…

#### echo $GLOBALOPTION

should get this result:

#### ON

Is the required variable updated/added?

## Solution:

Edit the /etc/environment file:

#### sudo vi /etc/environment

Save the below line at the end of the file:

#### GLOBALOPTION=ON

Then execute the following command on the terminal for the changes to take effect:

#### source /etc/environment


## Task:

Make sure that this command gets executed for any user that logs in to the system:

#### echo Welcome to our server!

Are the required changes made?

## Solution:

Create a file with .sh extension at location /etc/profile.d/, for example:

#### sudo vi /etc/profile.d/welcome.sh

And save in it the line given below:

#### echo "Welcome to our server!"


## Task:

Make sure that every time a new user account is added to the system, a file called README is copied to the new user's home directory.

Are the required changes made?

## Solution:

Whenever we create a new user in Linux, the files in the /etc/skel directory get copied into the user's home. So, we can create a README in the /etc/skel directory so that it gets copied to the newly created user's home.
Execute the below command to do so:

#### sudo touch /etc/skel/README


## Task:

Set a variable named LFCS with value Welcome to the KodeKloud LFCS Labs! for every user that logs into this system.

Note: You may need to login again to make the changes take effect, so run sudo su - <current-user-name>.

Has LFCS variable been set?

## Solution:

Edit the /etc/environment file:

#### sudo vi /etc/environment

Add the below line at the end of the file:

#### LFCS=Welcome to the KodeKloud LFCS Labs!


## Task:

Add the value of $PATH variable for user bob to include $HOME/.config/bin location in the path.

Has PATH been updated for user bob?

## Solution:

Edit the .bashrc file:

#### vi /home/bob/.bashrc

Add the PATH variable value so that it looks similar to this and save it:

#### PATH="$HOME/.config/bin:$PATH"

Source .bashrc:

#### source ~/.bashrc
