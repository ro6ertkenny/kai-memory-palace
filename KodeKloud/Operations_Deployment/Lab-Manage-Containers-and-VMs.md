# Lab - Manage Containers and VMs

## Task:

What does this command do?

#### virsh destroy TestMachine

A. It deletes the virtual machine called TestMachine.

B. It forces a power off for the virtual machine called TestMachine.

C. It destroys all data stored in the virtual machine called TestMachine.

D. It deletes both the virtual machine called TestMachine and the data stored on it.

<details><summary>Answer</summary>
It forces a power off for the virtual machine called TestMachine.

### Explanation:
- virsh → manage virtual machines via libvirt
- destroy → forcefully stop (power off) a VM
- TestMachine → target virtual machine
- force off → similar to pulling power, not graceful shutdown

👉 `virsh` = **Virtualization Shell**

## 🧠 BREAKDOWN

    vir = virtualization
    sh  = shell

👉 So:

> 🗣️ “virsh = shell to manage virtual machines”


👉 `virsh` is a command-line tool to manage:

- virtual machines (VMs)
- networks
- storage

👉 usually with:

    libvirt

</details>

---

## Task:

Which of the following commands would you use to set the virtual machine called VM1 to automatically start up at boot?

<details><summary>Answer</summary>
You can use virsh autostart VM1 command to set the virtual machine called VM1 to automatically start up at boot.

    virsh autostart VM1

### Explanation:
- virsh → manage VMs
- autostart → enable VM to start automatically at system boot
- VM1 → target virtual machine

</details>

---

## Task:

Which of the following commands is used to list all docker containers (including stopped containers) present on a system?

<details><summary>Answer</summary>

#### docker ps -a

### Explanation:
- docker ps -a → list all containers including stopped ones
- docker → container management tool
- ps → list running containers
- -a → include all containers

👉 `ps` = **processes**

👉 Even though Docker shows containers…

👉 Containers = running processes

👉 `-a` = **all**

👉 Think:

> 🗣️ “-a = all containers”

</details>

---

## Task:

Create and run a new Docker container based on the docker.io/library/nginx image. Three command line options should be used:

A. The option to detach from this container's input/output (so you're not stuck inside the container once you run your command)

B. The option to map port 1234 on the host to port 80 on the container

C. The option to name this new container as website

Is the container called website created and running?

Is the correct PORT mapped?

<details><summary>Answer</summary>
Execute the below command to run the docker container:

#### docker run -d -p 1234:80 --name website docker.io/library/nginx

### Explanation:
- docker run → create and start a container
- -d → run container in detached mode
- -p 1234:80 → map host port 1234 to container port 80
- --name website → assign name to container
- docker.io/library/nginx → image used

Another task to:

Pull docker.io/library/nginx image on this system.

docker pull docker.io/library/nginx

</details>

---

## Task:

Remove the docker.io/library/nginx docker image.

Has the image been removed?

<details><summary>Answer</summary>
First, check if that image is being used by any running container. If so, then first stop that container and remove it.

#### docker images
#### docker ps -a
#### docker stop $CONTAINER_ID
#### docker rm $CONTAINER_ID

Now, remove the image.

#### docker rmi $IMAGE_ID

Or you can force remove the image:

#### docker rmi $IMAGE_ID -f

### Explanation:
- docker images → list images
- docker ps -a → list containers
- docker stop → stop running container
- docker rm → remove container
- docker rmi → remove image
- -f → force removal even if in use

</details>

---

## Task:

Remove all docker containers (including running, stopped containers) from this system.

Have all docker containers been removed?

<details><summary>Answer</summary>
Using below mentioned command, check all docker containers present on the system:

#### docker ps -a

Delete the running containers if any:

#### docker stop <container-id>
#### docker rm <container-id>

Delete the stopped/exited containers if any:

#### docker rm <container-id>

### Explanation:
- docker ps -a → list all containers
- docker stop → stop running containers
- docker rm → remove containers
- 'container-id' → identifier for each container

Docker needs container IDs (or names), not just a flag.

👉 There is no single argument like --all for docker stop or docker rm

👉 You must pass ALL container IDs

✅ One-Liner (THIS is what you want)
docker rm -f $(docker ps -aq)

Inner command:

    docker ps -aq

-a → all containers (running + stopped)
-q → only IDs

👉 returns:

    cbb4ee7d3846
    abc123...
    xyz789...

Outer command:

    docker rm -f

rm → remove container
-f → force (stop if running, then remove)

</details>

---

## Task:

Use the image called httpd to create and run an Apache web server. Bind port 9080 on the host to port 80 of the container. Set the restart policy so that this container always restarts if it stops unexpectedly or the system reboots. Name the container webinstance1.

Is webinstance1 container up and running?

Are ports configured correctly?

Is the restart policy configured as mentioned?

<details><summary>Answer</summary>
Run the below command to complete the task.

#### docker run --detach --publish 9080:80 --restart always --name webinstance1 httpd

Check for containers using the below command.

#### docker ps

### Explanation:
- docker run → create and start container
- --detach → run container in background
- --publish 9080:80 → map host port 9080 to container port 80
- --restart always → always restart container
- --name webinstance1 → assign container name
- httpd → Apache image
- docker ps → verify running containers

👉 Think:

> 🗣️ “detach = don’t tie up my terminal”

## ⚠️ LFCS REALITY

👉 Exam may NOT explicitly say `--detach`

👉 But you should:
- use it when running services
- especially when you need to verify after

</details>

---

## Task:

We have virsh utility installed that lets us interact with virtual machines and qemu-kvm installed that lets us create and run them.

Check if any virtual machine is present on this system (stopped or running). If yes, then save its name in the /home/bob/vm file.

Is the /home/bob/vm file updated as needed?

<details><summary>Answer</summary>
Execute the below command to list out the VMs:

#### virsh list --all

Look for the value(s) under Name and save it in /home/bob/vm file:

#### vi /home/bob/vm

So, if the VM name is VM1, then the file content should be:

#### VM1

### Explanation:
- virsh list --all → list all VMs (running and stopped)
- Name → VM identifier
- vi → manually save VM name
- /home/bob/vm → destination file

</details>

---

## Task:

In the previous question, you might have noticed that VM1 is in shut off state; start this VM.

Has VM1 been started?

<details><summary>Answer</summary>
Execute the below command:

#### virsh start VM1

### Explanation:
- virsh start → start a virtual machine
- VM1 → target VM

</details>

---

## Task:

Now, completely remove the VM1 virtual machine.

Has VM1 been deleted?

<details><summary>Answer</summary>
Execute the below commands:

#### virsh destroy VM1
#### virsh undefine VM1

### Explanation:
- virsh destroy → force stop VM
- virsh undefine → remove VM definition
- VM1 → target VM
- combination → fully removes VM from system

</details>

---

## Task:

We have a configuration file /opt/testmachine2.xml on this system.

Create a virtual machine using this configuration file, and make sure to start it.

Is the virtual machine created from the "/opt/testmachine2.xml" configuration and is it running?

<details><summary>Answer</summary>
Execute the below commands:

#### virsh define /opt/testmachine2.xml

Now, list out the virtual machines:

#### virsh list --all

Identify the name of the VM from the above command and start it. Let's say, if VM name is VM2:

#### virsh start VM2

### Explanation:
- virsh define → create VM from XML config
- /opt/testmachine2.xml → VM configuration file
- virsh list --all → verify VM creation
- virsh start → start VM

</details>

---

## Task:

Right now, when we start up or reboot this system, the virtual machines on it have to be manually started.
But we want VM2 virtual machine to start up automatically at boot.

Is VM2 virtual machine set to autostart at boot?

<details><summary>Answer</summary>
Execute the below command:

#### virsh autostart VM2

### Explanation:
- virsh autostart → enable VM auto-start at boot
- VM2 → target VM

</details>

---

## Task:

Change the memory size for VM2; set its value to 80M.

Make sure the changes are in effect; you can verify the same using sudo virsh dominfo VM2 command.

Has the memory size for VM2 been set to 80M?

<details><summary>Answer</summary>
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

### Explanation:
- virsh setmaxmem → set maximum memory
- virsh setmem → set current memory allocation
- 80M → memory size
- --config → persist configuration
- virsh shutdown → graceful shutdown
- virsh destroy → force stop
- virsh start → restart VM

👉 `virsh dominfo` = **show info about a virtual machine**

### `dominfo`
👉 **domain info**

👉 In libvirt:
- “domain” = virtual machine (VM)

## Why BOTH `setmaxmem` and `setmem` Are Used

## Commands
    virsh setmaxmem VM2 80M --config
    virsh setmem VM2 80M --config

- **maximum memory (ceiling)**
- **current memory (actual usage)**

Think of it like:

    max memory = limit  
    current memory = what it's using right now  

## 🔍 What Each Command Does

## 1️⃣ `setmaxmem`

    virsh setmaxmem VM2 80M --config

👉 sets:
> the MAXIMUM memory the VM is allowed to use

## 2️⃣ `setmem`

    virsh setmem VM2 80M --config

👉 sets:
> the CURRENT memory assigned to the VM

## ⚠️ Important Rule

> You CANNOT set current memory higher than max memory 

👉 keeps them aligned

## ⚙️ What `--config` Means

    --config

👉 make change **persistent** (survives reboot)

    VM memory has TWO states:
    - allowed maximum
    - currently assigned

👉 both must be managed

</details>

---

## Task:

There is a cloud image available in /var/lib/libvrt/images/ folder use that image to spin up the virtual machine with the following details

    Name - kk-ubuntu
    Memory - 1024 
    vcpus - 1 
    **virtual CPU** disk path - /var/lib/libvirt/images/ubuntu-22.04-minimal-cloudimg-amd64.img
    os-variant - ubuntu22.04 
    graphics -  none 
    network - default

Note: It will take some time for the process to be completed.

Is virtual machine kk-ubuntu is in running state?

<details><summary>Answer</summary>

### The following was throwing errors ... needs to be corrected:

virt-install \
    
    --name kk-ubuntu \
    --memory 1024 \
    --vcpus 1 \
    --disk path=/var/lib/libvirt/images/ubuntu-22.04-minimal-cloudimg-amd64.img\
    --import \
    --os-variant ubuntu22.04 \
    --graphics none \
    --network network=default

### Explanation:
- virt-install → create virtual machines
- --name kk-ubuntu → VM name
- --memory 1024 → allocate 1024 MB RAM
- --vcpus 1 → assign 1 CPU
- --disk path=... → disk image path
- --import → use existing disk image
- --os-variant ubuntu22.04 → OS type
- --graphics none → disable graphical output
- --network network=default → attach default network

</details>
