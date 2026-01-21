# 🧪 Essential Commands — Execution Drills (LFCS)

Mental mode: Muscle memory.  
Goal: Be able to execute every task below **without thinking**.

This file is not a tutorial.  
This is a **hands-on execution checklist**.

You should be able to perform **every item** on a live system.

---

## 🔐 1) Local and Remote Login

- Switch to a TTY and log in
- Return to GUI (if present)
- SSH into localhost
- SSH into another host (or same host via IP)
- Show who is logged in

    w
    who
    tty

---

## 🔎 2) Find Files

- Find files by name
- Find files by size
- Find files by type
- Find files by owner
- Find files by permissions
- Find files modified in last N days
- Find and delete a file by inode
- Find files and run a command on them

    find . -name "*.conf"
    find . -size +10M
    find . -type f
    find . -user root
    find . -perm 777
    find . -mtime -7
    ls -i
    find . -inum 123456 -delete
    find . -type f -exec ls -lh {} +

---

## 📚 3) Locate Files Using Database

- Update locate database
- Find a file using locate

    sudo updatedb
    locate passwd

---

## 🧩 4) Globbing (Wildcard Expansion)

- Use *
- Use ?
- Use []
- Use ranges
- Use {}
- Use exclusions

    ls a*
    ls a?
    ls a[bc]
    ls a[a-c]*
    mkdir test-{1,2,3}
    ls [!a]*

---

## 💽 5) Filesystem Inspection

- Show disk usage
- Show filesystem types
- Identify filesystem on a block device

    df -h
    df -T
    lsblk -f
    file -sL /dev/sda1

---

## 📝 6) Compare and Manipulate Text

- Create files
- Compare files
- Compare directories
- Sort text
- Count lines
- Show line numbers
- Cut columns
- Translate characters
- Squeeze repeated spaces
- Show binary/octal view
- Rename files using pattern

    touch a.txt b.txt
    diff a.txt b.txt
    diff -ur dir1 dir2
    sort file.txt
    wc -l file.txt
    nl -ba file.txt
    cut -d ':' -f 1 /etc/passwd
    tr ',' ';' < file.csv
    tr -s ' ' < file.txt
    od -bc file.txt
    rename 's/foo/bar/' *.txt

---

## 🔗 7) Join, Paste, Split

- Join two files
- Paste two files side by side
- Split a file by size or lines

    join a.txt b.txt
    paste a.txt b.txt
    split -n 3 bigfile.txt

---

## 🔁 8) Input / Output Redirection

- Redirect stdout
- Redirect stderr
- Redirect both
- Append output
- Discard output
- Use stdin redirection
- Use pipes
- Use here-doc

    command > out.txt
    command 2> err.txt
    command > all.txt 2>&1
    command >> out.txt
    command > /dev/null 2>&1
    grep root < /etc/passwd
    ps aux | grep root
    cat << EOF
    hello
    world
    EOF

---

## 🔎 9) Regex and Text Search (grep)

- Basic grep
- Case insensitive grep
- Invert match
- Recursive grep
- Show line numbers
- Use extended regex
- Use Perl regex

    grep root /etc/passwd
    grep -i root /etc/passwd
    grep -v root /etc/passwd
    grep -R "root" /etc
    grep -n root /etc/passwd
    grep -E "root|daemon" /etc/passwd
    grep -P '(?<=root).*' /etc/passwd

---

## 🧹 10) sed Basics

- Print specific lines
- Delete lines
- Substitute text
- Substitute globally
- Use groups

    sed -n '1,10p' file.txt
    sed '1,5d' file.txt
    sed 's/foo/bar/' file.txt
    sed 's/foo/bar/g' file.txt
    sed -E 's/(foo)(bar)/\2\1/' file.txt

---

## 🧮 11) awk Basics

- Print columns
- Filter by value
- Use BEGIN and END
- Do arithmetic

    awk '{print $1}' /etc/passwd
    awk -F: '{print $1, $3}' /etc/passwd
    awk '$3 > 1000 {print $1}' /etc/passwd
    ps aux | awk 'BEGIN {sum=0} {sum+=$6} END {print sum}'

---

## 📦 12) Archives and Compression (tar, gzip, bzip2, xz)

- Create tar archive
- List archive
- Extract archive
- Create compressed tar
- Extract compressed tar
- Exclude files
- Create incremental backup

    tar cf test.tar dir/
    tar tf test.tar
    tar xf test.tar
    tar czf test.tar.gz dir/
    tar xzf test.tar.gz
    tar --exclude="*.log" -czf test.tar.gz dir/

---

## 🔁 13) rsync

- Copy file locally
- Sync directory locally
- Sync to remote
- Dry run
- Delete extra files

    rsync -a file1 /tmp/
    rsync -a dir1/ dir2/
    rsync -av --dry-run dir1/ dir2/
    rsync -av --delete dir1/ dir2/

---

## 📁 14) File and Directory Operations

- Create directories
- Remove directories
- Copy files
- Move files
- Remove recursively
- Jump to previous directory

    mkdir test
    rmdir test
    cp a.txt b.txt
    mv a.txt b.txt
    rm -rf somedir
    cd -

---

## 🔗 15) Hard and Soft Links

- Create hard link
- Create symlink
- Overwrite symlink
- Remove link
- Find files with multiple links

    ln a.txt a-hard.txt
    ln -s a.txt a-soft.txt
    ln -sf new.txt a-soft.txt
    unlink a-soft.txt
    find . -type f -links +1

---

## 🔐 16) Permissions

- Read permissions
- Change permissions numeric
- Change permissions symbolic
- Set suid
- Set sgid
- Set sticky bit
- Find suid files

    ls -l
    chmod 750 file
    chmod u+x,g+w,o-r file
    chmod u+s file
    chmod g+s dir
    chmod +t dir
    find / -perm -4000 -type f 2>/dev/null

---

## 📖 17) System Documentation

- Use man
- Use info
- Use help
- Use apropos
- Open specific man sections

    man ls
    info ls
    help cd
    apropos partition
    man 5 passwd

---

## 👑 18) Root Access

- Get root shell
- Run single command as root
- Set root password
- Lock root account

    sudo -i
    sudo command
    sudo passwd root
    sudo passwd -l root

---

## ✅ Completion Criteria

You are **done with this file** when:

- You can perform every section **without looking up syntax**
- You can do it **under time pressure**
- You make **no destructive mistakes**

---
