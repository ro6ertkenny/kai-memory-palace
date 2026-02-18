# 🧪 Essential Commands — Answer Key (LFCS)

Grouped by foundation layer for rapid operator recall  
All references are canonical learning homes.

---

# 🥇 LAYER 1 — Shell Execution Model

 true  
 echo $?  
 false  
 echo $?  
 0 = success  

 cmd1 ; cmd2  
 cmd && echo OK  
 cmd || echo FAIL  
 cmd && echo OK || echo FAIL  

 echo "text" > file  
 echo "text" >> file  

 ls /nope 2> err.txt  
 ls /nope 2> /dev/null  

 command | wc -l  
 command | grep pattern  

 command | tee file  
 command | tee -a file  

→ [bash-basics](../../shell-and-bash/bash/bash-basics.md)  
→ [bash-pipelines](../../shell-and-bash/bash/bash-pipelines.md)

---

# 🥈 LAYER 2 — Navigation & Filesystem Awareness

 pwd  
 ls -l  
 ls -lh  
 file target  

 df -h  
 du -sh dir  
 du -sh dir1 dir2  

→ [files-and-metadata-inspection](../../foundations/files-and-metadata-inspection.md)

---

# 🥉 LAYER 3 — Create / Move / Delete

 touch file  

 mkdir dir  
 mkdir -p a/b/c  

 cp src dst  
 cp -r dir1 dir2  
 cp -a src dst  

 mv old new  
 mv file /path/  
 mv file /path/newname  

 rm file  
 rmdir dir  
 rm -r dir  

→ [filesystem-access-control](../../foundations/filesystem-access-control.md)

---

# 🏅 LAYER 4 — Viewing & Inspecting Content

 cat file  
 head -n 10 file  
 tail -n 10 file  
 less file  

 wc -l file  
 wc -w file  
 wc -c file  

→ [files-and-metadata-inspection](../../foundations/files-and-metadata-inspection.md)

---

# 🏅 LAYER 5 — Search

 find . -name "file"  
 find / -name "file"  

 find . -type f  
 find . -size +10M  
 find . -user user  
 find . -perm 644  
 find . -mtime -7  

 locate file  
 which cmd  
 whereis cmd  

→ [system-inspection](../../foundations/system-inspection.md)

---

# 🏅 LAYER 6 — Text Filtering Primitives

 grep pattern file  
 grep -c pattern file  
 grep -v pattern file  
 
 cut -d: -f1 file  

 sort file  
 uniq file  
 sort file | uniq -c  

 tr 'a' 'A'  
 tr -d 'x'  

 command | wc -l  
 command | wc -w  

→ [grep](../../shell-and-bash/text-processing/grep.md)  
→ [cut-sort-uniq-tr](../../shell-and-bash/text-processing/cut-sort-uniq-tr.md)

---

# 🏅 LAYER 7 — Links

 ln file hardlink  
 ls -li  

 ln -s target link  
 ls -l  

→ [advanced-filesystem-permissions](../../foundations/advanced-filesystem-permissions.md)

---

# 🏅 LAYER 8 — Permissions & Ownership

 ls -l  

 chmod 644 file  
 chmod +x file  
 chmod -w file  

 chown user file  
 chgrp group file  
 chown user:group file  

 umask  
 umask 022  
 touch test  
 ls -l  

→ [advanced-filesystem-permissions](../../foundations/advanced-filesystem-permissions.md)

---

# 🏅 LAYER 9 — Archive & Compression

 tar -cf archive.tar dir  
 tar -tf archive.tar  
 tar -xf archive.tar  

 gzip file  
 gunzip file.gz  

 bzip2 file  
 bunzip2 file.bz2  

 xz file  
 unxz file.xz  

 tar -czf archive.tar.gz dir  
 tar -xzf archive.tar.gz  

→ [archives-and-compression-tar](../../foundations/archives-and-compression-tar.md)

---

# 🏅 LAYER 10 — File Comparison

 cmp file1 file2  
 diff file1 file2  

→ [grep](../../shell-and-bash/text-processing/grep.md)

---

# 🏅 LAYER 11 — Remote Operations

 ssh user@host  
 ssh user@host command  

 scp file user@host:/path/  
 scp user@host:/path/file .  

→ [ssh-operator-basics](../../networking/ssh-operator-basics.md)

