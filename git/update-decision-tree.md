# 🌳 Git Update Decision Tree (Fetch → Inspect → Integrate)

## 🎯 Purpose
Provide an explicit, low-risk decision system for updating branches using:
- merge (safe default)
- rebase (clean history, higher risk)
- do nothing (often correct)

This complements:
- `git/forks-and-upstream.md` (origin vs upstream)

---

## 🧠 Core Rule
Always update in this order:

1) FETCH (no mutation)
2) INSPECT (understand the diff)
3) INTEGRATE (merge or rebase, intentionally)

---

## 1) FETCH (always safe)

### Forked repos
Fetch both remotes:

    git fetch origin
    git fetch upstream

### Non-fork repos (you own the upstream)
Fetch origin:

    git fetch origin

---

## 2) INSPECT (determine what changed)

### Show remotes and confirm you’re in the right repo
    git remote -v

### See if your local branch is behind/ahead of your tracking branch
    git status

### Compare your local `main` to upstream `main` (forks)
    git log --oneline --decorate --graph --left-right --cherry-pick main...upstream/main

### Compare your local `main` to origin `main` (non-forks or your fork)
    git log --oneline --decorate --graph --left-right --cherry-pick main...origin/main

Interpretation:
- Commits shown with `<` are on the left side (your branch).
- Commits shown with `>` are on the right side (remote branch).
- If you see only `>` commits, you are behind.
- If you see only `<` commits, you are ahead.
- If you see both, you have diverged.

---

## 3) INTEGRATE (choose the correct action)

### Decision Tree (authoritative)

#### A) Are you on a shared branch that other people pull from?
Examples: team `main`, `release/*`, anything others consume regularly.

- YES → prefer MERGE (safe)
- NO  → MERGE or REBASE depending on your goals

#### B) Have you already pushed commits to the branch you’re updating?
- YES → prefer MERGE
- NO  → REBASE is allowed (if you want clean linear history)

#### C) Is this a fork, and you’re syncing from `upstream`?
- YES → MERGE is default; REBASE only if you understand force-with-lease

---

## ✅ Safe Default Path (MERGE)
Use merge when:
- branch is shared
- you already pushed commits
- you want low risk and clarity

### Fork: update your local `main` from upstream, then push to your fork
    git checkout main
    git fetch upstream
    git merge upstream/main
    git push origin main

### Non-fork: update your local `main` from origin
    git checkout main
    git fetch origin
    git merge origin/main
    git push origin main

---

## 🧼 Clean History Path (REBASE)
Use rebase when ALL are true:
- you have NOT pushed your local commits yet, OR you accept rewriting history
- the branch is NOT shared
- you know how to recover if needed

### Fork: rebase your `main` onto upstream, then push to your fork
    git checkout main
    git fetch upstream
    git rebase upstream/main
    git push --force-with-lease origin main

### Non-fork: rebase onto origin
    git checkout main
    git fetch origin
    git rebase origin/main
    git push --force-with-lease origin main

---

## 🛑 When the correct action is “DO NOTHING”
Do nothing if:
- `git status` shows you are up to date
- your branch is ahead only, and you do NOT want to publish yet
- you fetched and inspection shows no relevant updates

---

## ⚠️ Divergence Handling (both sides have commits)
If your branch and the remote both have unique commits, you have diverged.

Default action:
- MERGE (preserves history, avoids rewriting)

### Fork divergence with upstream
    git checkout main
    git fetch upstream
    git merge upstream/main
    git push origin main

If you insist on rebase (advanced):
- stop and confirm you have no collaborators depending on your branch
- use rebase + force-with-lease as shown earlier

---

## 🔥 Red Flags (stop immediately)
Stop if:
- you see `fatal: refusing to merge unrelated histories`
- you are on the wrong branch (not `main`) and about to integrate
- you are about to `push --force` without `--force-with-lease`
- you are rebasing a branch others already pulled

---

## 🧯 Recovery Quick Notes (minimal)
### Abort a merge in progress
    git merge --abort

### Abort a rebase in progress
    git rebase --abort

### Find previous HEAD (last resort)
    git reflog

---

## 🗂️ Canonical Location in kai-memory-palace
Path:

    git/update-decision-tree.md

This belongs in the Git wing because it encodes operational judgment, not a single tool command.

---

## 🚀 Git Commands to Add This File to kai-memory-palace
    cd ~/kai-memory-palace
    vim git/update-decision-tree.md
    # paste this file, save, and exit

    git status
    git add git/update-decision-tree.md
    git commit -m "Add git update decision tree (fetch → inspect → integrate)"
    git push
