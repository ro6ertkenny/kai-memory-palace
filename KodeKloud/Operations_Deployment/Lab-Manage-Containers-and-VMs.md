# Lab - Manage Containers and VMs

## Task:

What does this command do?

#### virsh destroy TestMachine

A. It deletes the virtual machine called TestMachine.

B. It forces a power off for the virtual machine called TestMachine.

C. It destroys all data stored in the virtual machine called TestMachine.

D. It deletes both the virtual machine called TestMachine and the data stored on it.

## Solution:

It forces a power off for the virtual machine called TestMachine.


## Task:

Which of the following commands would you use to set the virtual machine called VM1 to automatically start up at boot?

## Solution:

You can use virsh autostart VM1 command to set the virtual machine called VM1 to automatically start up at boot.


## Task:

Which of the following commands is used to list all docker containers (including stopped containers) present on a system?

## Solution:

Pull docker.io/library/nginx image on this system.

Is the required docker image pulled?


## Task:

Create and run a new Docker container based on the docker.io/library/nginx image. Three command line options should be used:

A. The option to detach from this container's input/output (so you're not stuck inside the container once you run your command)

B. The option to map port 1234 on the host to port 80 on the container

C. The option to name this new container as website

Is the container called website created and running?

Is the correct PORT mapped?

## Solution:

Execute the below command to run the docker container:

#### docker run -d -p 1234:80 --name website docker.io/library/nginx


## Task:

Remove the docker.io/library/nginx docker image.

Has the image been removed?

## Solution:

First, check if that image is being used by any running container. If so, then first stop that container and remove it.

#### docker images
#### docker ps -a
#### docker stop $CONTAINER_ID
#### docker rm $CONTAINER_ID

Now, remove the image.

#### docker rmi $IMAGE_ID

Or you can force remove the image:

#### docker rmi $IMAGE_ID -f


## Task:

Remove all docker containers (including running, stopped containers) from this system.

Have all docker containers been removed?

## Solution:

Using below mentioned command, check all docker containers present on the system:

#### docker ps -a

Delete the running containers if any:

#### docker stop <container-id>
#### docker rm <container-id>

Delete the stopped/exited containers if any:

#### docker rm <container-id>


## Task:

Use the image called httpd to create and run an Apache web server. Bind port 9080 on the host to port 80 of the container. Set the restart policy so that this container always restarts if it stops unexpectedly or the system reboots. Name the container webinstance1.

Is webinstance1 container up and running?

Are ports configured correctly?

Is the restart policy configured as mentioned?

## Solution:

Run the below command to complete the task.

#### docker run --detach --publish 9080:80 --restart always --name webinstance1 httpd

Check for containers using the below command.

#### docker ps


## Task:

We have virsh utility installed that lets us interact with virtual machines and qemu-kvm installed that lets us create and run them.

Check if any virtual machine is present on this system (stopped or running). If yes, then save its name in the /home/bob/vm file.

Is the /home/bob/vm file updated as needed?

## Solution:

Execute the below command to list out the VMs:

#### virsh list --all

Look for the value(s) under Name and save it in /home/bob/vm file:

#### vi /home/bob/vm

So, if the VM name is VM1, then the file content should be:

#### VM1


## Task:

In the previous question, you might have noticed that VM1 is in shut off state; start this VM.

Has VM1 been started?

## Solution:

Execute the below command:

#### virsh start VM1


## Task:

Now, completely remove the VM1 virtual machine.

Has VM1 been deleted?

## Solution:

Execute the below commands:

#### virsh destroy VM1
#### virsh undefine VM1


## Task:

We have a configuration file /opt/testmachine2.xml on this system.

Create a virtual machine using this configuration file, and make sure to start it.

Is the virtual machine created from the "/opt/testmachine2.xml" configuration and is it running?

## Solution:

Execute the below commands:

#### virsh define /opt/testmachine2.xml

Now, list out the virtual machines:

#### virsh list --all

Identify the name of the VM from the above command and start it. Let's say, if VM name is VM2:

#### virsh start VM2


## Task:

Right now, when we start up or reboot this system, the virtual machines on it have to be manually started.
But we want VM2 virtual machine to start up automatically at boot.

Is VM2 virtual machine set to autostart at boot?

## Solution:

Execute the below command:

#### virsh autostart VM2


## Task:

Change the memory size for VM2; set its value to 80M.

Make sure the changes are in effect; you can verify the same using sudo virsh dominfo VM2 command.

Has the memory size for VM2 been set to 80M?

## Solution:

Execute the below command to change the maximum memory size:

#### virsh setmaxmem VM2 80M --config

Execute the below command to change the memory size as needed:

#### virsh setmem VM2 80M --config

Shutdown the VM:

#### virsh shutdown VM2

Or
force a power off in our case since we have no operating system in there:

#### virsh destroy VM2

Start the VM again:

#### virsh start VM2


## Task:

There is a cloud image available in /var/lib/libvrt/images/ folder use that image to spin up the virtual machine with the following details

Name - kk-ubuntu
Memory - 1024 
vcpus - 1 
disk path - /var/lib/libvirt/images/ubuntu-22.04-minimal-cloudimg-amd64.img
os-variant - ubuntu22.04 
graphics -  none 
network - default

Note: It will take some time for the process to be completed.

Is virtual machine kk-ubuntu is in running state?

## Solution:

virt-install \
    --name kk-ubuntu \
    --memory 1024 \
    --vcpus 1 \
    --disk path=/var/lib/libvirt/images/ubuntu-22.04-minimal-cloudimg-amd64.img\
    --import \
    --os-variant ubuntu22.04 \
    --graphics none \
    --network network=default

