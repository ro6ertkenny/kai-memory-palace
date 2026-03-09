# Lab - Kernel Runtime Parameters and SELinux/AppArmor

## Task:

Find the SELinux labels of sshd process running on this system. Save its value in the /home/bob/sshd file.

Verify the SELinux context.

## Solution:

Execute the below command:

#### ps auxZ | grep sshd

Copy the SELinux context from the output and save it in the /home/bob/sshd file.

#### vi /home/bob/sshd

For example, if the context is system_u:system_r:initrc_t:s0, then the file contents should be:

#### system_u:system_r:initrc_t:s0


## Task:

Turn on kernel.modules_disabled kernel runtime parameter, so that loading new kernel modules will be disabled.

Check if the kernel.modules_disabled kernel runtime parameter is turned on.

## Solution:

Execute the below command:

#### sysctl -w kernel.modules_disabled=1


## Task:

Check out the SELinux label for the file stored at /bin/sudo. Ignore the SELinux user and role here.
What is the SELinux type used on this file? Save its value in /home/bob/selabel file.

Verify the label.

## Solution:

Execute the below command:

#### ls -Z /bin/sudo

You should see sudo_exec_t in the output. Save it in the /home/bob/selabel file:

#### vi /home/bob/selabel


## Task:

Use the sysctl command to make sure this kernel runtime parameter is actively enabling its settings:

#### net.ipv6.conf.lo.seg6_enabled

Is kernel runtime parameter enabled?

## Solution:

Use the below command:

#### sysctl -w net.ipv6.conf.lo.seg6_enabled=1


## Task:

Adjust the value of this kernel runtime parameter, vm.swappiness, to 10.

After you set this to 10, also make the change persistent so that it will be auto-set to this value on the next reboot.

Is the required value set for vm.swappiness?

## Solution:

Edit the /etc/sysctl.conf file:

#### vi /etc/sysctl.conf

Add the below code in this file and save it:

#### vm.swappiness=10

Apply the changes:

#### sysctl -p


## Task:

Change the SELinux context of /var/index.html file to httpd_sys_content_t

Is SELinux context updated for the /var/index.html file?

## Solution:

Use the below command:

#### chcon -t httpd_sys_content_t /var/index.html


## Task:

Temporarily change the SELinux status to Permissive on this system.

Check SELinux status.

## Solution:

Execute the below command:

#### sudo setenforce 0


## Task:

Identify the SELinux Roles for staff_u SELinux user and save the value(s) in /home/bob/serole file.

Verify the SELinux roles for "staff_u" user.

## Solution:

Execute the below command:

#### semanage user -l

Copy the SELinux Roles value for staff_u user and save it in the /home/bob/serole file:

#### vi /home/bob/serole


## Task:

The SELinux labels for the files in /var/log are wrong. Restore the correct (default) labels for every file and subdirectory in the /var/log directory. You only need to fix the SELinux type labels (user and role can be left as they are).

Default labels are restored for /var/log directory?

## Solution:

Run the below command to restore SELinux labels.

#### sudo restorecon -R /var/log/


