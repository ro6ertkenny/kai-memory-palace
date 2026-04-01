# Manage Containers & VMs — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: What does this command do?

    virsh destroy TestMachine

<details>
<summary>Answer</summary>

### Command
    virsh destroy TestMachine

### Explanation
- virsh destroy → force power off (like pulling the plug)
- does NOT delete VM or disk
- correct answer → forces shutdown of VM

</details>

---

## 🧪 Task 2

Task: Set VM1 to automatically start at boot.

<details>
<summary>Answer</summary>

### Command
    virsh autostart VM1

### Explanation
- autostart → enable VM to start on host boot

</details>

---

## 🧪 Task 3

Task: List all Docker containers (including stopped ones).

<details>
<summary>Answer</summary>

### Command
    docker ps -a

### Explanation
- docker ps → running containers
- -a → include stopped containers

</details>

---

## 🧪 Task 4

Task: Run nginx container with:
- detached mode
- port 1234 → 80
- name = website

<details>
<summary>Answer</summary>

### Command
    docker run -d -p 1234:80 --name website docker.io/library/nginx

### Explanation
- -d → detached (background)
- -p 1234:80 → host:container port mapping
- --name → container name

</details>

---

## 🧪 Task 5

Task: Remove docker.io/library/nginx image.

<details>
<summary>Answer</summary>

### Command
    docker ps -a
    docker stop <container_id>
    docker rm <container_id>
    docker rmi docker.io/library/nginx

### Explanation
- must stop/remove containers using image first
- docker rmi → remove image

</details>

---

## 🧪 Task 6

Task: Remove all Docker containers.

<details>
<summary>Answer</summary>

### Command
    docker rm -f $(docker ps -aq)

### Explanation
- docker ps -aq → all container IDs
- rm -f → force remove (running + stopped)

</details>

---

## 🧪 Task 7

Task: Run Apache container:
- image = httpd
- port 9080 → 80
- restart always
- name = webinstance1

<details>
<summary>Answer</summary>

### Command
    docker run -d -p 9080:80 --restart always --name webinstance1 httpd

### Explanation
- --restart always → restart on failure or reboot
- -p → port mapping
- -d → background

</details>

---

## 🧪 Task 8

Task: List all VMs and save name to /home/bob/vm.

<details>
<summary>Answer</summary>

### Command
    virsh list --all | awk 'NR>2 && $2!="" {print $2}' > /home/bob/vm

### Explanation
- virsh list --all → list all VMs
- awk → extract VM name column
- `>` → save output

</details>

---

## 🧪 Task 9

Task: Start VM1.

<details>
<summary>Answer</summary>

### Command
    virsh start VM1

### Explanation
- start → boot VM

</details>

---

## 🧪 Task 10

Task: Remove VM1 completely.

<details>
<summary>Answer</summary>

### Command
    virsh destroy VM1
    virsh undefine VM1

### Explanation
- destroy → power off
- undefine → remove VM definition

</details>

---

## 🧪 Task 11

Task: Create VM from /opt/testmachine2.xml and start it.

<details>
<summary>Answer</summary>

### Command
    virsh define /opt/testmachine2.xml
    virsh list --all
    virsh start <VM_NAME>

### Explanation
- define → register VM from XML
- start → run VM

</details>

---

## 🧪 Task 12

Task: Set VM2 to autostart at boot.

<details>
<summary>Answer</summary>

### Command
    virsh autostart VM2

### Explanation
- autostart → enable boot-time start

</details>

---

## 🧪 Task 13

Task: Set VM2 memory to 80M and apply changes.

<details>
<summary>Answer</summary>

### Command
    virsh setmaxmem VM2 80M --config
    virsh setmem VM2 80M --config
    virsh destroy VM2
    virsh start VM2

### Explanation
- setmaxmem → max memory
- setmem → current memory
- --config → persistent
- restart required for changes

</details>

---

## 🧪 Task 14

Task: Create VM kk-ubuntu using provided cloud image.

<details>
<summary>Answer</summary>

### Command
    virt-install \
        --name kk-ubuntu \
        --memory 1024 \
        --vcpus 1 \
        --disk path=/var/lib/libvirt/images/ubuntu-22.04-minimal-cloudimg-amd64.img \
        --import \
        --os-variant ubuntu22.04 \
        --graphics none \
        --network network=default

### Explanation
- virt-install → create VM
- --memory → RAM in MB
- --vcpus → CPU count
- --disk → disk image path
- --import → use existing image
- --graphics none → no GUI
- --network → attach to default network

</details>
