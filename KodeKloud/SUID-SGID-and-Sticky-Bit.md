SUID, SGID, and Sticky Bit

SUID = Set user identification bit - whenever this is set on file it means whenever the file is executed it's going to be executed as the user id of the owner of the file instead of the person running the file 

su - switch user 

-rwSrw-r-- 1 
capital S for the execute bit means the SUID bit is enabled for this file
capital S means SUID is enabled but there's no execute permission

-rwsrw-r-- 1
lowercase s means the execute bit and the SUID bit are both set 

SGID = set group id

chmod 2664 sgidfile
-rw-rwSr--1

chmod 2674 sgidfile
-rw-rwsr-- 1


ro6ert@ro6bx:~/Documents/LINUX/KodeKloud/SUID-SGID-Sticky-Bit$ ls
SGID.png                 SGID-SUID-stickydir.png  Sticky-Bit-2.png  SUID.png
SGID-SUID-find-perm.png  Sticky-Bit-1.png         SUID-2.png



