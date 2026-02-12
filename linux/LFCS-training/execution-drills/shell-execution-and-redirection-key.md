# 🧪 Shell Execution, Redirection, Pipelines, and Job Control — Answer Key (LFCS)

Simple key only. Full explanations live in:
`linux/LFCS-training/execution-drills/shell-execution-and-redirection-qa.md`

---

# 🧪 Setup

## Lab Reset + Deterministic Input

mkdir -p ~/lfcs-labs/execution-drills/shell  
cd ~/lfcs-labs/execution-drills/shell  
rm -f out.txt err.txt all.txt report.txt input.txt file.txt important.txt  
rm -rf data  

cat > input.txt <<EOF  
alpha  
beta  
gamma  
beta  
delta  
EOF  

---

# 🧱 Atomic Drills

## Exit Codes

true  
echo $?  
false  
echo $?  

0 = success  
non-zero = failure  

---

## Conditional Chaining (&& / ||)

mkdir -p a2 && echo "mkdir ok" || echo "mkdir failed"  
test -f /etc/passwd && echo "exists" || echo "missing"  
test -f /nope && echo "exists" || echo "missing"  

&& runs on success (0)  
|| runs on failure (≠ 0)  

---

## STDOUT Redirect: Overwrite vs Append

echo "one" > out.txt  
echo "two" >> out.txt  
cat out.txt  

> = overwrite  
>> = append  

---

## STDERR Redirect Only

ls /no/such/path 2> err.txt  
cat err.txt  

2> = redirect stderr  

---

## Redirect Both stdout+stderr (Classic vs Bash Shorthand)

ls /no/such/path > all.txt 2>&1  
cat all.txt  

ls /no/such/path &> all.txt  
cat all.txt  

---

## /dev/null Patterns

ls /no/such/path 2> /dev/null  
ls /etc > /dev/null  
ls /no/such/path &> /dev/null  

2> /dev/null = hide errors only  
> /dev/null = hide normal output only  
&> /dev/null = hide everything  

---

## tee: View + Save

dmesg | head -n 5 | tee out.txt  
cat out.txt  

tee = split stream (screen + file)  

---

## tee -a: Append

echo "append-test" | tee -a out.txt  
tail -n 3 out.txt  

-a = append  

---

## Pipes: Count Lines

cat input.txt | wc -l  

wc -l = line count  

---

## Pipes: Count Matching Lines

cat input.txt | grep -c beta  

grep -c = count matching lines  

---

## Here-Doc File Creation

cat > file.txt <<EOF  
line1  
line2  
EOF  

cat file.txt  

---

## Grouping for Redirection

{ date; uptime; echo "OK"; } > report.txt  
cat report.txt  

{ } = group commands  
> once at end = redirect whole group  

---

# ⏱️ Timed Drills

## Capture Everything (Correct Ordering)

ls /no/such/path > all.txt 2>&1  
cat all.txt  

Rule: `> file 2>&1` (left-to-right)  

---

## 3-Command Pipeline: Frequency Count

cat input.txt | sort | uniq -c  

sort first, then uniq -c  

---

## Find Largest File (find → du → sort → head)

mkdir -p data  
dd if=/dev/zero of=data/a bs=1K count=10 status=none  
dd if=/dev/zero of=data/b bs=1K count=50 status=none  
dd if=/dev/zero of=data/c bs=1K count=20 status=none  

find data -type f -exec du -h {} + | sort -rh | head -n 1  

---

# 💥 Failure Injection

## Misordered Redirection (Wrong)

ls /no/such/path 2>&1 > all.txt  

## Misordered Redirection (Correct)

ls /no/such/path > all.txt 2>&1  

Rule: `2>&1` copies stderr to wherever stdout points at that moment  

---

## Clobber Risk

echo "DO NOT LOSE THIS" > important.txt  
echo "oops" > important.txt  

> overwrites (destructive)  
>> appends  

---

# 🔎 Diagnosis

## grep Exit Codes: No Match vs Match

cat input.txt | grep zzz  
echo $?  

cat input.txt | grep beta  
echo $?  

grep exit codes:  
0 = match found  
1 = no match found  
2 = actual error  

---

# 🧰 Job Control

sleep 3000 &  
jobs  
fg %1  
Ctrl+Z  
bg %1  
jobs  
kill %1  

& = background  
%1 = job spec (not PID)  

---

# 🧩 Composition

## Live Filter + Capture

(ls /no/such/path; ls /etc) 2>&1 | tee all.txt | grep -i "no such"  

---

## Report Generator

{  
  echo "=== DATE ==="  
  date  
  echo  
  echo "=== UPTIME ==="  
  uptime  
  echo  
  echo "=== TOP 5 PROCESSES BY MEM ==="  
  ps aux --sort=-%mem | head -n 6  
} > report.txt  

---

# ✅ Completion Criteria

Never hesitate on: >  >>  2>  2>&1  &>  
Never mis-order redirection  
Use tee naturally  
Build 3–5 command pipelines automatically  
Use grouping { } for redirection  
Fluent with &: jobs, fg, bg, Ctrl+Z, kill %job  
Build: find | du | sort | head without thinking  

---

# 🧠 Operator Rule

If you do not control redirection and pipelines perfectly, you do not control Linux.

---

