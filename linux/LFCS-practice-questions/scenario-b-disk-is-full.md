# 🧠 Scenario B — Disk Is Full

## 📍 Symptom

A command fails with:

“No space left on device”

Writes are failing. Services may start crashing.

---

## 🎯 Goal

Determine:

- Which filesystem is affected
- Whether this is **space exhaustion** or **inode exhaustion**
- Which directory tree is responsible
- What is safe to clean up

---

## 🧭 Operator Rule

> **Never delete before you know which filesystem and which directory tree is responsible.**

---

## 🧪 Step 1 — Identify the Failing Resource

Run:

    df -h
    df -i

Interpretation:

- df -h
  - Find filesystems near 100% usage.
  - This answers: “Which filesystem is full?”

- df -i
  - Check inode usage.
  - If inodes are 100% → you are out of file entries, not space.

Decision:

- If space is full → continue.
- If inodes are full → look for directories with millions of small files.

---

## 🔎 Step 2 — Find Where the Space (or Inodes) Went

Start at the root of the affected filesystem:

    sudo du -x -sh /* | sort -h

Notes:

- -x stays on the same filesystem.
- This gives a **top-level size map**.

Then drill down:

    du -sh /var/* | sort -h
    du -sh /home/* | sort -h
    du -sh /var/log/* | sort -h

Repeat until you find the **offending subtree**.

---

## 🧠 Step 3 — Decide What You Are Looking At

Common causes:

- Logs growing without rotation
- Cache directories growing without bounds
- Temporary files never cleaned
- A runaway application writing endlessly
- User data filling a partition

Ask:

- Is this system data or user data?
- Is it safe to delete or truncate?
- Is this a symptom of a deeper bug?

---

## ⚠️ Forbidden Actions

- Do not delete blindly.
- Do not rm -rf random directories.
- Do not “just free some space”.

Every deletion must be:
- targeted
- justified
- verified

---

## ✅ Step 4 — Clean Up Safely

Examples (situation dependent):

- Truncate logs
- Clear known cache directories
- Remove known temporary files
- Stop the runaway producer first

After cleanup:

    df -h
    df -i

Verify space or inodes are actually freed.

---

## 🏁 Success Criteria

You can explain:

- Which filesystem was full
- Whether it was space or inodes
- Which directory tree caused it
- Why your cleanup action was safe
- That the system is now healthy again

---

## 🧠 Operator Loop (Reinforced)

Symptom → Identify → Locate → Decide → Act → Verify

Never reverse the order.
EOF

