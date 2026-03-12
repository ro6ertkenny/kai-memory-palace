# Manage Template User Environment

> Learn to manage the template user environment in Linux using the /etc/skel directory for consistent user configurations.

In this article, you'll learn how to manage the template user environment in Linux through the use of the /etc/skel directory. When a new user account is created, the content of /etc/skel is automatically copied into the user's home directory. This feature ensures that every user begins with a consistent set of configurations and files.

Imagine you want to inform every new user about a default policy while existing users are already familiar with it. To achieve this, you can add a custom file containing your policy message directly into /etc/skel.

<Callout icon="lightbulb" color="#1CB2FE">
  Adding a custom file in /etc/skel ensures that all new users automatically receive important information without manual intervention.
</Callout>

## Adding a Custom README

To add a custom README in /etc/skel, follow these steps:

1. Open the README file in your preferred text editor:

   ```bash  theme={null}
   $ sudo vim /etc/skel/README
   ```

2. Inside the file, add the following text:

   Please don't run CPU intensive processes between 8 AM and 10 PM.

3. Save the file.

Now, whenever you create a new user, the README file (along with other configuration files) will automatically be copied to the user’s home directory.

## Testing the Configuration by Creating a New User

Let's test the configuration by creating a new user named "trinity":

```bash  theme={null}
$ sudo adduser trinity
```

After creating the user, you can verify that all files from /etc/skel have been copied, including hidden files such as .bashrc. List all files in Trinity’s home directory with the following command:

```bash  theme={null}
$ sudo ls -a /home/trinity
.  ..  .bash_logout  .bash_profile  .bashrc  README
```

Trinity can review the content of the README with:

```bash  theme={null}
$ cat /home/trinity/README
```

## Understanding Environment Variables Setup

The file .bashrc in a user's home directory is responsible for setting up the shell environment. For instance, if you open Trinity's .bashrc:

```bash  theme={null}
$ sudo vim /home/trinity/.bashrc
```

you might notice that the PATH variable is configured to include local binary directories. To display the current PATH, you can run:

```bash  theme={null}
$ echo $PATH
/home/trinity/.local/bin:/home/trinity/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
```

## Modifying the PATH for Future Users

If you need to modify the PATH variable for all new users, update the .bashrc template located in /etc/skel. For example, suppose you want to include an additional directory (/opt/bin) in the PATH for every new user. Open the template file with:

```bash  theme={null}
$ sudo vim /etc/skel/.bashrc
```

Then, update the PATH variable as follows:

```bash  theme={null}
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$HOME/bin:/opt/bin:$PATH"
```

Any changes made to files in /etc/skel will be automatically applied when new user accounts are created, ensuring a standardized environment for all users.

For more detailed information on managing user environments and best practices, consider exploring the [Linux Documentation Project](https://www.tldp.org/) or related [system administration guides](https://www.linux.com/).

<CardGroup>
  <Card title="Watch Video" icon="video" cta="Learn more" href="https://learn.kodekloud.com/user/courses/linux-foundation-certified-system-administrator-lfcs/module/b36d272b-24e2-44e1-82cb-20a5cfa93635/lesson/69d90b4c-a1a1-4332-9e42-54eb9ebc05d1" />

  <Card title="Practice Lab" icon="installation" cta="Learn more" href="https://learn.kodekloud.com/user/courses/linux-foundation-certified-system-administrator-lfcs/module/b36d272b-24e2-44e1-82cb-20a5cfa93635/lesson/c6d0947e-990f-44b5-9918-21b28398d7e6" />
</CardGroup>


Built with [Mintlify](https://mintlify.com).
