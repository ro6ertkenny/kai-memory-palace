# Git Commit Message Standard (Conventional Commits)

This repository uses Conventional Commits to keep history searchable, automate changelogs later, and make reviews fast.

---

## Format

Commit messages follow this structure:

<type>(<scope>): <subject>

Optional body

Optional footer

Definitions:
- type: what kind of change this is
- scope: where the change lives (wing, folder, or component)
- subject: one-line, imperative summary with no trailing period

---

## Types

Use these types consistently:

- docs — documentation changes (Markdown, README, maps, runbooks)
- feat — new capability (new guide, new workflow, new automation)
- fix — bug fix (incorrect instructions, broken commands)
- refactor — restructure without changing meaning
- chore — housekeeping (formatting, non-functional cleanup)
- test — add or update tests (rare here)
- ci — CI/CD or GitHub Actions changes

Rule: If the change is Markdown and not executable behavior, use docs.

---

## Scopes (kai-memory-palace)

Prefer wing-level scopes, then sub-area if helpful.

Core wings:
- git
- kai
- linux
- networking
- vim
- snippets
- templates

Kubernetes wings:
- k8s-general
- k8s-foundations
- k8s-ops+provisioning
- k8s-networking
- k8s-ecosystem

Repository-level scopes:
- readme
- map
- repo

Keep scopes short and human-readable.

---

## Subject Line Rules

- Use imperative mood (add, fix, remove, refactor)
- Target 50–72 characters
- Do not end with a period
- Avoid vague language

Good examples:
- docs(map): add git wing to knowledge map
- fix(k8s-ops+provisioning): correct kubeadm reset cleanup steps

Bad examples:
- Updated map
- Fixing things
- WIP

---

## Body Rules

Include a body when:
- the intent is not obvious
- you need to explain why, not just what
- multiple files are changed for one purpose

Guidelines:
- wrap lines around 72 characters
- prefer bullet points
- explain intent and constraints

---

## Breaking Changes

If a change breaks paths, conventions, or meaning:

- add ! after the type or scope
- include a BREAKING CHANGE note at the end

Example:
refactor(repo)!: rename k8s wing directories

BREAKING CHANGE: updated k8s paths; all references must be updated.

---

## Canonical Examples

Root navigation:
- docs(readme): add git wing to top-level navigation

Knowledge map:
- docs(map): add git wing to knowledge map

New documentation:
- docs(linux): add apt-get package management conventions

Fix incorrect instructions:
- fix(k8s-ops+provisioning): correct kubeadm reset cleanup steps

Structural refactor:
- refactor(k8s-general): reorganize troubleshooting notes

Git wing content:
- docs(git): add commit message standard

---

## Commit Granularity Rules

- one commit equals one coherent idea
- prefer small, reviewable commits
- do not mix unrelated wings

If multiple files are changed:
- they must support the same intent
- otherwise, split the commits

---

## Pre-Commit Checklist

Run before committing:
- git status
- git diff
- git add <files>
- git diff --staged
- git commit -m "docs(git): clear subject"

---

## Authority

If another document conflicts with this one, this file is the single source of truth for commit message standards.
