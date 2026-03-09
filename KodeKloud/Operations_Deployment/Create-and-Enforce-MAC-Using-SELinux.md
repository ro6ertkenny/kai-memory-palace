# Create and Enforce MAC Using SELinux

> This article explains how to enforce Mandatory Access Control using SELinux on Ubuntu systems, including installation, configuration, and policy management.

In this lesson, we'll explore how to enforce Mandatory Access Control (MAC) using the SELinux security module. SELinux is enabled by default on Red Hat and CentOS systems, while Ubuntu uses AppArmor as its default security module. Before installing or configuring SELinux on a system set up by others, always verify which security module is active. In this guide, we assume that your Ubuntu system does not have SELinux enabled. We'll walk you through disabling AppArmor, installing SELinux tools, and configuring SELinux from scratch.

***

## Disabling AppArmor

Since AppArmor is enabled by default on Ubuntu systems, you must stop its service to avoid conflicts with SELinux:

```bash  theme={null}
sudo systemctl stop apparmor.service
```

After stopping the service, ensure that AppArmor does not automatically start on boot

#### sudo systemctl disable apparmor.service

***

## Installing SELinux and AuditD

To get started with SELinux, install the SELinux utilities along with the AuditD package. The SELinux package includes essential tools and default security policies, and AuditD logs system events—a critical resource when building custom SELinux policies.

#### sudo apt install selinux-basics auditd

Below is a sample installation output. Your output may vary:

```bash  theme={null}
Selecting previously unselected package libgfortran5:amd64.
Preparing to unpack .../04-libgfortran5_14-20240412-0ubuntu1_amd64.deb ...
Unpacking libgfortran5:amd64 (14-20240412-0ubuntu1) ...
...
Progress: [ 28%] [##############################.....................]
```

Similarly, when AuditD is configured, you might observe:

```bash  theme={null}
Setting up python3-semanage (3.5-1build5) ...
...
Progress: [ 78%] [#########################.........................]
```

***

## Verifying and Activating SELinux

To verify whether SELinux is enabled on your system, run:

```bash  theme={null}
sestatus
```

If SELinux is disabled, the output will resemble:

```bash  theme={null}
jeremy@kodekLOUD:~$ sestatus
SELinux status:             disabled
jeremy@kodekLOUD:~$
```

You can also verify the current SELinux context assignments in the root directory:

```bash  theme={null}
jeremy@kodekLOUD:~$ ls -Z /
?      bin              ?   lib64           ?   mnt             ?   run
?      boot             ?   home            ?   lost+found      ?   proc
...
```

To enable SELinux, execute:

```bash  theme={null}
sudo selinux-activate
```

This command modifies the GRUB bootloader to include the parameter necessary to load the SELinux module at boot. The output will inform you about generating the GRUB configuration and activate SELinux—after which a system reboot is recommended.

***

## Configuring the Bootloader

After activating SELinux, verify the bootloader settings. In the `/etc/default/grub` file, you should see the following line instructing the kernel to load SELinux:

#### cat /etc/default/grub

```bash  theme={null}
GRUB_CMDLINE_LINUX="security=selinux"
```

Once you confirm the configuration, note the presence of an autorelabel file in the root filesystem. This file tells SELinux to relabel every file upon reboot. For example, listing the root directory including hidden files shows:

```bash  theme={null}
jeremy@kodekLOUD:~$ ls -a /
.              bin.usr-is-merged  etc               lib.usr-is-merged  opt   sbin    swap.img  var
..             boot                home              lost+found        proc  sbin.usr-is-merged  root  snap
.autolabel    cdrom               lib               media             mnt   run     srv       tmp    usr
```
## There should have been a file called .autorelabel ?

Now, reboot your system to allow SELinux to relabel the filesystem. The relabeling process might take some time depending on the number of files:

```bash  theme={null}
sudo reboot
```

During the first boot after enabling SELinux, the bootloader pauses for 30 seconds to allow intervention if necessary. Once complete, subsequent boots will operate normally. After rebooting, verify SELinux status by running:

#### ls -Z /

```bash  theme={null}

sestatus
```

Expected output:

```bash  theme={null}
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             default
Current mode:                   permissive
Mode from config file:          permissive
...
```

***

## Understanding SELinux Modes

SELinux operates in two primary modes:

* **Permissive:** In this mode, SELinux logs policy violations without enforcing them. It is ideal for "training" your policies.
* **Enforcing:** Here, SELinux actively enforces policies and may deny actions that do not comply with the defined rules.

To check the current mode, run:

```bash  theme={null}
getenforce
```

When operating in permissive mode, actions that should be blocked are only logged. For instance, accessing via SSH may trigger AVC (Access Vector Cache) messages in the audit log. To inspect these messages, use:

```bash  theme={null}
sudo audit2why --all | less
```

The output might include entries like:

```text  theme={null}
type=AVC msg=audit(1716410944.847:111): avc: denied { execute } for pid=922 comm="run-parts" name="1-landscape-sysinfo.wrapper" dev="dm-0" ino=284986 scontext=system_u:system_r:sshd_t:s0 tcontext=system_u:object_r:usr_t:s0 tclass=file permissive=1
        Was caused by:
                Missing type enforcement (TE) allow rule.
        You can use audit2allow to generate a loadable module to allow this access.
```

<Callout icon="lightbulb" color="#1CB2FE">
  Although similar audit entries might be repeated, a single occurrence generally provides enough insight into the issue.
</Callout>

***

## Examining Process and File Contexts

You can verify SELinux contexts for running processes and files. For example, to inspect the contexts of SSH daemons, run:

```bash  theme={null}
ps -eZ | grep sshd_t
```

Sample output:

```bash  theme={null}
system_u:system_r:sshd_t:s0       905 ?        00:00:00 sshd
system_u:system_r:sshd_t:s0       906 ?        00:00:00 sshd
system_u:system_r:sshd_t:s0       1020 ?       00:00:02 sshd
```

To view the context for the SSH daemon executable:

```bash  theme={null}
ls -Z /usr/sbin/sshd
```

Expected output:

```bash  theme={null}
system_u:object_r:sshd_exec_t:s0 /usr/sbin/sshd
```

When a file labeled with `sshd_exec_t` is executed, SELinux transitions the process into the `sshd_t` domain, where its type enforcement rules become active.

***

## Generating and Loading a Custom SELinux Policy

After operating in permissive mode and gathering necessary logs, you can generate a custom SELinux policy module from the audit logs. Run:

```bash  theme={null}
sudo audit2allow --all -M mymodule
```

#### the --all option tells the tool to inspect all logged events

#### -M option tells it to generate a "Module" or policy package ... this is a file that we can load into SELinux to create a security policy that would allow all of the previously logged actions ... and "mymodule" is just a name that was chosen for this security package file

The command output will include a message similar to:

```text  theme={null}
********************* IMPORTANT *********************
To make this policy package active, execute:
semodule -i mymodule.pp
```

To load the custom policy module, execute:

```bash  theme={null}
sudo semodule -i mymodule.pp
```

#### the -i option is used to tell the semodule command to install this module package into SELinux
<Callout icon="lightbulb" color="#1CB2FE">
  If you see a warning such as "libsemanage.add\_user: user sddm not in password file", it is a known issue. You can safely ignore it if you are not using sddm.
</Callout>

***

## Switching to Enforcing Mode

To temporarily switch SELinux from permissive to enforcing mode, execute:

```bash  theme={null}
sudo setenforce 1
getenforce
```

Expected output:

```bash  theme={null}
Enforcing
```

For initial testing, it is advisable to use temporary enforcement. Once you are sure that your custom policies cover all the necessary actions, make the change permanent by modifying `/etc/selinux/config`.

Open the configuration file with:

```bash  theme={null}
sudo vim /etc/selinux/config
```

Then change:

```ini  theme={null}
SELINUX=permissive
```

to:

```ini  theme={null}
SELINUX=enforcing
```

Save the file and reboot the system to apply the changes.

***

## Reviewing the Custom Policy Module

After loading the custom module, two files are created:

* A binary package (`mymodule.pp`)
* A human-readable policy file (`mymodule.te`)

The `.te` file contains the type enforcement rules. An excerpt might look like:

```plaintext  theme={null}
module mymodule 1.0;
require {
    type sshd_t;
    type tmp_t;
    type getty_t;
    type systemd_journal_init_t;
    type policykit_t;
    type mount_exec_t;
    type kmod_t;
    type var_t;
    type systemd_journal_t;
    type systemd_runtime_notify_t;
    type xdg_cache_t;
    type fixed_disk_device_t;
    type fsadm_exec_t;
    type mount_runtime_t;
    type var_lib_t;
    type mount_t;
    type systemd_hostnamed_t;
    type var_log_t;
    type etc_runtime_t;
    type lib_t;
    type system_dbusd_t;
    type usr_t;
};
class dir { add_name search watch write };
class dbus send_msg;
```

Review this file carefully before deploying the policies in production.

***

## Understanding and Reviewing SELinux Type Enforcement

The custom module includes specific rules for the `sshd_t` domain. For instance, it allows the SSH daemon to access files labeled with `var_log_t`:

```plaintext  theme={null}
allow sshd_t var_log_t:file { append create getattr ioctl open };
```

This rule ensures that processes running in the `sshd_t` domain, such as the SSH daemon, can write to log files like `/var/log/auth.log`, which are labeled as `var_log_t`.

You can verify these contexts with the following commands:

```bash  theme={null}
ps -eZ | grep sshd_t
ls -Z /var/log/auth.log
grep var_log_t:file mymodule.te
```

Expected outputs:

```bash  theme={null}
system_u:system_r:sshd_t:s0       905 ?        00:00:00 sshd
...
system_u:object_r:var_log_t:file /var/log/auth.log
...
allow sshd_t var_log_t:file { append create getattr ioctl open };
```

This level of fine-grained control helps restrict processes to specific files, reducing potential risks if a process (such as an NGINX web server) is compromised.

***

## Changing SELinux File Contexts with chcon and restorecon

A file's SELinux context is composed of three parts: user, role, and type. To manually change a file’s context, use the `chcon` command. For example, to view and modify the context of `/var/log/auth.log`:

```bash  theme={null}
ls -Z /var/log/auth.log
sudo chcon -u unconfined_u /var/log/auth.log
```

To change the role and type:

```bash  theme={null}
sudo chcon -r object_r /var/log/auth.log
sudo chcon -t user_home_t /var/log/auth.log
```

<Callout icon="triangle-alert" color="#FF6B6B">
  Manual changes made with `chcon` may be overridden during a complete filesystem relabel.
</Callout>

To restore the default context, use the `restorecon` command. For example, to fix the context of `/var/log/auth.log` based on `/var/log/dmesg` as a reference:

```bash  theme={null}
sudo chcon --reference=/var/log/dmesg /var/log/auth.log
```

## To find valid labels for security policies use command:

#### seinfo -u 
            users

#### seinfo -r 
            roles

#### seinfo -t 
            types

## Look at other labels in the var/log directory:

#### ls -Z /var/log 

## We can tell the chcon command to use another file as a reference and copy all the label parts from the good file to the bad file ... for this we use a dpkg log ... where you can tell the chcon command to use another file as a reference and copy all of the label parts from the good file to the bad file ... so the dmesg file is the good file that should be used as a reference:

#### sudo chcon --reference=/var/log/dmesg /var/log/auth.log

    Here we're using it as a reference and applying it to the auth.log file 

***

## Fixing Contexts for Web Content

If you create a new directory for your website under `/var/www` and add files, they may initially have an incorrect SELinux type (such as `var_t`). To correct this recursively:

```bash  theme={null}
sudo mkdir /var/www
sudo touch /var/www/{1..10}
ls -Z /var/www/
# Files may initially be labeled as:
# unconfined_u:object_r:var_t:s0
sudo restorecon -R /var/www/
ls -Z /var/www/
```

After running `restorecon -R /var/www/`, the files should be relabeled correctly (for example, as `httpd_sys_content_t`), which is appropriate for web content. Note that `restorecon` by default only restores the type, not the user or role. If needed, use the force option to restore all parts of the label.

To permanently assign a default label to a specific file (e.g., `/var/www/10`), add a rule with `semanage`:

```bash  theme={null}
sudo semanage fcontext --add --type var_log_t /var/www/10
# You might encounter:
# libsemanage.add_user: user sddm not in password file
sudo restorecon /var/www/10
```
Lookup this example:

#### sudo semanage fcontext --add --type var_log_t /var/www/10

Followed by this command to restore the default label:

#### sudo restorecon /var/www/10

For directories and their contents, remember to wrap the path in quotes if it contains special characters. Refer to the SELinux documentation for additional examples.

***

## SELinux Booleans and Port Bindings

SELinux booleans act as switches to enable or disable related security policies. To list supported booleans and their current settings, run:

```bash  theme={null}
getsebool -a | grep virt_use_nfs
```

To set the `virt_use_nfs` boolean, execute:

```bash  theme={null}
sudo setsebool virt_use_nfs 1
```

SELinux also manages which ports a daemon is allowed to bind to. To list all allowed port bindings:

```bash  theme={null}
sudo semanage port --list
```

For instance, SSH is typically restricted to port 22. To allow SSH to bind to an additional port (such as 2222), run:

```bash  theme={null}
sudo semanage port --add --type ssh_port_t --proto tcp 2222
```

To later remove this port binding:

```bash  theme={null}
sudo semanage port --delete --type ssh_port_t --proto tcp 2222
```

<Callout icon="lightbulb" color="#1CB2FE">
  Any warnings regarding the user sddm may be safely ignored if you are not using sddm.
</Callout>

***

## Conclusion

SELinux offers a robust mechanism for enforcing security policies by confining processes and controlling file access through detailed security contexts. While the setup and testing process can seem complex initially, running in permissive mode allows you to identify and adjust potential issues before switching to enforcing mode for full protection.

With continuous study and practice, you can develop tailored SELinux policies that significantly reduce the risk of common attacks. Enjoy your journey to a more secure system!

<CardGroup>
  <Card title="Watch Video" icon="video" cta="Learn more" href="https://learn.kodekloud.com/user/courses/linux-foundation-certified-system-administrator-lfcs/module/cb813f7f-73bd-40ee-a088-d31ba20c51de/lesson/c99f9a23-5fd8-44ac-ae35-97c88f7d21dc" />

  <Card title="Practice Lab" icon="installation" cta="Learn more" href="https://learn.kodekloud.com/user/courses/linux-foundation-certified-system-administrator-lfcs/module/cb813f7f-73bd-40ee-a088-d31ba20c51de/lesson/a019d670-0561-47cc-85a2-1ed68680aba1" />
</CardGroup>

