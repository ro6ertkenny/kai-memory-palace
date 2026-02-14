# sudo and Privilege Delegation

How Linux delegates administrative privilege, how sudo policy is evaluated,
and how to debug access issues safely.

---

## sudo vs su

su:
- switches to another user (often root)
- starts a shell as that user
- limited per-command auditing by default

sudo:
- executes a single command as another user (often root)
- enforces policy
- logs usage
- standard admin mechanism on modern systems

---

## Inspect sudo capability

Show what *you* can run:

    sudo -l

Show what another user can run:

    sudo -l -U marshall

---

## Where sudo rules live

Main config:

    /etc/sudoers

Drop-in directory:

    /etc/sudoers.d/

Drop-ins are read in addition to the main file.

---

## Always use visudo

Never edit sudoers with a normal editor.

    sudo visudo

visudo validates syntax before saving (prevents lockout).

---

## Prefer drop-in files

- safer than editing the main file
- clean separation
- easy to audit/remove
- package-friendly

---

## Create a sudo rule (drop-in)

Example: give marshall full sudo.

    sudo tee /etc/sudoers.d/marshall > /dev/null <<'EOF'
    marshall ALL=(ALL) ALL
    EOF

Fix permissions:

    sudo chmod 440 /etc/sudoers.d/marshall
    sudo chown root:root /etc/sudoers.d/marshall

---

## Command-restricted sudo (example)

Allow only apt-get:

    marshall ALL=(ALL) /usr/bin/apt-get

---

## Group-based sudo (Debian/Ubuntu)

Members of group `sudo` get sudo access.

Inspect:

    getent group sudo
    id marshall

Remove user from sudo group:

    sudo gpasswd -d marshall sudo

---

## Debugging sudo problems

1. Check group membership:

    id marshall
    getent group sudo

2. Check explicit rules:

    sudo -l -U marshall

3. Inspect drop-in files:

    sudo ls -l /etc/sudoers.d/

4. Validate sudoers syntax:

    sudo visudo

---

## Key commands

    sudo -l
    sudo -l -U marshall
    visudo
    getent group sudo
    gpasswd -d marshall sudo

---

## Related drills

- Execution drills directory:
  - ../LFCS-training/execution-drills/

---

## Exam memory hook

sudo is **policy-driven command delegation**, not just “become root”.

