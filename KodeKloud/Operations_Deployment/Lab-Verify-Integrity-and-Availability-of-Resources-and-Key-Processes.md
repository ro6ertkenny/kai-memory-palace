# Verify Integrity & Availability of Resources — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: Identify what % space of / partition is in use and save it in /home/bob/used.

<details>
<summary>Answer</summary>

### Command
    df / | awk 'NR==2 {print $5}' > /home/bob/used

### Explanation
- df / → disk usage for root partition
- awk 'NR==2 {print $5}' → second line, 5th column (used %)
- `>` → save output to file

</details>

---

## 🧪 Task 2

Task: Find disk usage of /bin and save it in /home/bob/bin.

<details>
<summary>Answer</summary>

### Command
    du -sh /bin | awk '{print $1}' > /home/bob/bin

### Explanation
- du → disk usage
- -s → summary
- -h → human readable
- awk '{print $1}' → extract size only
- `>` → save output

</details>

---

## 🧪 Task 3

Task: Find total system memory (in MB) and save it in /home/bob/memory.

<details>
<summary>Answer</summary>

### Command
    free --mega | awk '/Mem:/ {print $2}' > /home/bob/memory

### Explanation
- free --mega → memory in MB
- /Mem:/ → match memory line
- {print $2} → total memory column
- `>` → save result

</details>

---

## 🧪 Task 4

Task: Find system uptime and save only the time value in /home/bob/up.

<details>
<summary>Answer</summary>

### Command
    uptime | awk -F'(up |,)' '{print $2}' | sed 's/ //g' > /home/bob/up

### Explanation
- uptime → system uptime info
- awk -F'(up |,)' → split around "up" and comma
- {print $2} → extract uptime value
- sed 's/ //g' → remove spaces
- `>` → save output

</details>

---

## 🧪 Task 5

Task: Find CPU cores per socket and save value in /home/bob/cpu.

<details>
<summary>Answer</summary>

### Command
    lscpu | awk -F: '/Core\\(s\\) per socket/ {gsub(/ /,"",$2); print $2}' > /home/bob/cpu

### Explanation
- lscpu → CPU info
- match "Core(s) per socket"
- remove spaces with gsub
- print value only
- `>` → save result

</details>

---

## 🧪 Task 6

Task: Check XFS filesystem on /dev/vdd for errors and save output to /home/bob/fscheck.

<details>
<summary>Answer</summary>

### Command
    sudo xfs_repair -n /dev/vdd > /home/bob/fscheck 2>&1

### Explanation
- xfs_repair → check/repair XFS filesystem
- -n → no modify (check only)
- `>` → redirect standard output
- `2>&1` → include error output

</details>
