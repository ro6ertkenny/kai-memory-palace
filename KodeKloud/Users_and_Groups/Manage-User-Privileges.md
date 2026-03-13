# Manage User Privileges

> This article explores managing user privileges on Linux systems using sudo and user groups for effective access control.

In this article, we explore how to manage user privileges on Linux systems. By understanding how sudo works and how user groups are associated with administrative rights, you can effectively grant and fine-tune access on your server.

## Using Sudo and User Groups

For critical system changes, you typically prepend your commands with sudo. Since only the root user is allowed to modify sensitive parts of the system, sudo temporarily elevates privileges to execute commands as the superuser.

A user is permitted to use sudo if they belong to the sudo group. To verify your group memberships, run:

```bash  theme={null}
$ groups
aaron family sudo
```

Since Aaron is a member of the sudo group, he can execute administrative tasks using sudo. To grant another user sudo privileges (for example, to add Trinity), execute the following:

```bash  theme={null}
$ groups
aaron family sudo
$ sudo gpasswd -a trinity sudo
```

At this point, the user Trinity will have administrator privileges, meaning she can execute any command using sudo. However, granting full sudo rights enables complete control over the system, which might not always be desirable.

## Fine-Tuning Sudo Privileges

For more granular control over user privileges, you can define specific sudo policies using the sudoers file located at `/etc/sudoers`. It is important not to edit this file directly; instead, always use the `visudo` utility. Visudo opens the file in an editor, checks for syntax errors before saving, and thus prevents misconfigurations.

Before proceeding with customization, remove Trinity from the sudo group to avoid granting her full sudo privileges:

```bash  theme={null}
$ sudo gpasswd -d trinity sudo
$ sudo visudo
```

When you open the file with visudo, you might encounter a section like this:

```bash  theme={null}
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
```

This line consists of:

1. User/Group: `%sudo` indicates that the policy applies to all users in the sudo group.
2. Host: `ALL` specifies that the rule applies on any host.
3. Run as user and group: `(ALL:ALL)` means that commands can be executed as any user and any group.
4. Command list: The final `ALL` grants permission to execute any command.

The general syntax for an entry in the sudoers file is:

```plaintext  theme={null}
user_or_group   host=(run_as_user:run_as_group) command_list
```

### Example Policies

To define a policy that allows Trinity to run any sudo command as any user, add an entry like this:

```bash  theme={null}
trinity   ALL=(ALL)       ALL
```

If you prefer to grant permissions to a whole group (for example, the developers group), prepend the group name with a percent sign:

```bash  theme={null}
%developers ALL=(ALL)     ALL
```

These entries allow the specified user or all members of the developers group to execute any command using sudo.

It is also possible to restrict the commands that a user can execute. For instance, if you want Trinity to run only specific commands such as ls or stat, you can limit her permissions accordingly. Consider the following example:

```bash  theme={null}
$ sudo -u trinity ls /home/trinity
Desktop  Documents  Downloads  Music  Pictures
```

With a restricted sudoers entry, if Trinity attempts to execute an unauthorized command, she might receive an error message like:

```bash  theme={null}
$ sudo echo "Test passed?"
Sorry, user trinity is not allowed to execute '/bin/echo Test passed?' as root on kodekloud.
```

<Callout icon="lightbulb" color="#1CB2FE">
  By default, sudo commands run as root. To run a command as a different user, specify the desired user with the `-u` option.
</Callout>

For example, to run a command as Trinity herself:

```bash  theme={null}
$ sudo -u trinity ls /home/trinity
```

If the run-as field is set to `ALL`, the policy permits execution as any user. However, to restrict Trinity so she can only execute commands as specific users (for example, Aaron or John), list those names in the sudoers file.

Additionally, the first time a sudo command is executed in a session, it prompts for the current user’s password. The sudoers file also provides options to disable this password prompt for specific users if configured appropriately.

<Callout icon="triangle-alert" color="#FF6B6B">
  Always back up your sudoers file before making changes. Use the visudo utility to edit this file, ensuring that syntax errors do not lock you out of administrative privileges.
</Callout>

By carefully setting these policies, you can secure your system with fine-tuned administrative rights rather than granting universal sudo access.

For more detailed guidance on managing user privileges in Linux, consider exploring [Linux Administration Best Practices](https://www.linux.com/).

<CardGroup>
  <Card title="Watch Video" icon="video" cta="Learn more" href="https://learn.kodekloud.com/user/courses/linux-foundation-certified-system-administrator-lfcs/module/b36d272b-24e2-44e1-82cb-20a5cfa93635/lesson/1f6adaa6-ada5-47f3-add4-8c2c0861fa69" />

  <Card title="Practice Lab" icon="installation" cta="Learn more" href="https://learn.kodekloud.com/user/courses/linux-foundation-certified-system-administrator-lfcs/module/b36d272b-24e2-44e1-82cb-20a5cfa93635/lesson/b9cd8286-ad81-4652-99c2-34dc337a10d1" />
</CardGroup>


Built with [Mintlify](https://mintlify.com).
