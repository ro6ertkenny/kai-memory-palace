# 🧪 Essential Commands — Answer Key (LFCS)

Grouped by execution surface for rapid operator recall

---

# 🐚 Shell

## Exit Codes

true  
echo $?  
false  
echo $?

0 = success  
non-zero = failure  

Memory: 0 means “all good”

---

## Conditional Chaining

command && echo "success"  
command || echo "failed"

&& runs if exit code = 0  
|| runs if exit code ≠ 0  

Example:  
test -f /etc/passwd && echo "exists" || echo "missing"

---

## mkdir Safe Creation

mkdir -p path

-p = parents  
Safe to re-run  

Memory: -p = parent-aware + repeatable

---

## Group + Redirect

{ date; uptime; echo "OK"; } > report.txt

{ } = group commands  
> = overwrite  

Memory: group first, redirect once

---

## Job Control

sleep 3000 &  
jobs  
fg %1  
Ctrl+Z  
bg %1  
kill %1  

& = background  
%1 = job spec (not PID)  

Memory: jobs → fg/bg → kill

---

## Globbing

* = match anything  
? = match one character  
[] = character set  
[a-c] = range  
{1,2,3} = generate names  
[!a]* = exclude pattern  

Memory: shell expands before command runs

---

# 💽 Filesystem

## Disk Usage

df -h  
-h = human readable  

“How full are my disks?”

df -T  
-T = filesystem type  

“What filesystem type?”

---

## Block Devices

lsblk -f  
-f = filesystem info  

Show devices, UUID, mountpoint

---

## Identify Filesystem on Device

file -sL /dev/sda1  

-s = special files  
-L = follow symlink  

Memory: inspect the real device

---

# 🔤 Text

## Create Files

touch a.txt b.txt  

Create empty file or update timestamp

---

## Compare Files

diff a.txt b.txt  
diff -u file1 file2  
-u = unified format  

diff -ur dir1 dir2  
-r = recursive  

Memory: -u readable, -r recursive

---

## Sort

sort file.txt  

Alphabetical sort

---

## Count Lines

wc -l file.txt  

-l = lines

---

## Number Lines

nl -ba file.txt  

-b = number all  
-a = include empty lines

---

## Cut Columns

cut -d ':' -f 1 /etc/passwd  

-d = delimiter  
-f = field  

Memory: cut = columns

---

## Translate Characters

tr ',' ';' < file.csv  

Character swap  
Does not modify file  

Memory: tr = characters

---

## Squeeze Spaces

tr -s ' ' < file.txt  

-s = squeeze repeats

---

## Octal Dump

od -bc file.txt  

-b = octal bytes  
-c = show characters  

Memory: use when bytes look wrong

---

## Rename Batch

rename 's/foo/bar/' *.txt  

Substitute in filenames

---

# 🔎 Search

## locate (database search)

sudo updatedb  
locate passwd  

updatedb = rebuild index  
locate = search index  

Memory: locate is instant but may be stale

---

## find Basics

find WHERE WHAT

find . -type f  
find /var -size +1G  
find /home -user bob  

Memory: find path first

---

## Find by Name

find . -name "*.conf"  
find . -iname "*.conf"

-name = case sensitive  
-iname = ignore case

---

## Find by Size

find . -size +10M  
find . -size -10M  

+ = larger than  
- = smaller than

---

## Find by Type

-type f = file  
-type d = directory  
-type l = symlink  

---

## Find by Permissions

-perm 777 = exact  
-perm -020 = must include bits  
-perm /022 = any of bits  

Memory:  
MODE = exact  
-MODE = include  
/MODE = any

World writable:  
find / -type f -perm /002 2>/dev/null  

SUID:  
find / -type f -perm -4000 2>/dev/null  

SGID:  
find / -type f -perm -2000 2>/dev/null  

2>/dev/null = hide errors  

---

## Modified Time

-mtime -7  
-mtime +7  
-mmin -60  

-mtime = days  
-mmin = minutes  

---

## Inode Search

ls -i  
find . -inum 123456 -ls  
find . -inum 123456 -delete  

Memory: confirm before delete

---

## find -exec

find . -type f -exec ls -lh {} +  
+ = batch  

find . -type f -exec ls -lh {} \;  
\; = one-by-one  

-ok = confirm before run  

Memory: + fast, ; slow, -ok safe

---

## grep

grep pattern file  
grep -i pattern file  
grep -v pattern file  
grep -n pattern file  
grep -R pattern dir  
grep -E "a|b" file  

-i = ignore case  
-v = invert  
-n = line numbers  
-R = recursive  
-E = extended regex  

Memory: prefer -E over -P

---

# 🔗 Streams

## join

join a.txt b.txt  

Match by first column (key)  

Memory: SQL-style join

---

## paste

paste a.txt b.txt  

Match by line number  

Memory: horizontal merge

---

## split

split -n 3 file  

-n = number of pieces  

Memory: one file → many

---

## sed

sed -n '1,10p' file  
-n = no auto print  
p = print  

sed '1,5d' file  
d = delete  

sed 's/foo/bar/'  
s = substitute  

sed 's/foo/bar/g'  
g = global  

sed -E 's/(foo)(bar)/\2\1/'  
-E = extended regex  
\1 \2 = capture groups  

Memory: s/FIND/REPLACE/

---

## awk

awk '{print $1}' file  

' ' = protect program  
{} = action block  
$1 = first field  

awk -F: '{print $1,$3}' file  
-F = field separator  

awk '$3 > 1000 {print $1}' file  

BEGIN {sum=0}  
{sum+=$6}  
END {print sum}  

Memory: BEGIN → process lines → END  

awk = column-aware processor

---

# ✅ Completion Criteria

You are ready when:

Exit codes and chaining are automatic  
Job control is automatic  
Command surfaces execute without lookup

