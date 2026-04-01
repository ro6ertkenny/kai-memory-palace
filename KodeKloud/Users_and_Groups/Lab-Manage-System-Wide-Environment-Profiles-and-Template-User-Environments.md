# System-Wide Environment Profiles & Template User Environments — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: How can we print the value of an environment variable?

<details>
<summary>Answer</summary>

### Command
    echo $MYVAR

### Explanation
- echo → print to terminal
- $MYVAR → variable reference

</details>

---

## 🧪 Task 2

Task: Which environment variable holds the user's home directory?

<details>
<summary>Answer</summary>

### Command
    $HOME

### Explanation
- $HOME → path to current user’s home directory

</details>

---

## 🧪 Task 3

Task: Which file sets globally available environment variables?

<details>
<summary>Answer</summary>

### Command
    /etc/environment

### Explanation
- /etc/environment → system-wide environment variables
- applies to all users

</details>

---

## 🧪 Task 4

Task: Print current user's environment and save to /home/bob/env.

<details>
<summary>Answer</summary>

### Command
    env > /home/bob/env

### Explanation
- env → print environment variables
- `>` → save output to file

</details>

---

## 🧪 Task 5

Task: Add environment variable MYVAR=TRUE for user bob.

<details>
<summary>Answer</summary>

### Command
    vi ~/.bashrc

    export MYVAR=TRUE

    source ~/.bashrc

### Explanation
- .bashrc → user-specific shell config
- export → make variable available to child processes
- source → reload config

</details>

---

## 🧪 Task 6

Task: Save value of GLOBALENV variable to /home/bob/globalenv.

<details>
<summary>Answer</summary>

### Command
    echo $GLOBALENV > /home/bob/globalenv

### Explanation
- echo → print variable
- `>` → redirect output to file

</details>

---

## 🧪 Task 7

Task: Copy default user template files into /home/bob/default_data.

<details>
<summary>Answer</summary>

### Command
    sudo cp /etc/skel/.bash* /home/bob/default_data/

### Explanation
- /etc/skel → template directory for new users
- cp → copy files
- .bash* → hidden bash config files

</details>

---

## 🧪 Task 8

Task: Set GLOBALOPTION=ON system-wide.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/environment

    GLOBALOPTION=ON

### Explanation
- /etc/environment → global variables
- applies to all users on login
- no export needed in this file

</details>

---

## 🧪 Task 9

Task: Display "Welcome to our server!" for all users on login.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/profile.d/welcome.sh

    echo "Welcome to our server!"

### Explanation
- /etc/profile.d/ → scripts run at login
- .sh file → executed for all users

</details>

---

## 🧪 Task 10

Task: Ensure new users get a README file in their home directory.

<details>
<summary>Answer</summary>

### Command
    sudo touch /etc/skel/README

### Explanation
- /etc/skel → template copied to new users
- README → automatically included

</details>

---

## 🧪 Task 11

Task: Set LFCS variable for all users.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/environment

    LFCS="Welcome to the KodeKloud LFCS Labs!"

### Explanation
- /etc/environment → system-wide variable
- quotes required for spaces in value

</details>

---

## 🧪 Task 12

Task: Add $HOME/.config/bin to PATH for user bob.

<details>
<summary>Answer</summary>

### Command
    vi /home/bob/.bashrc

    export PATH="$HOME/.config/bin:$PATH"

    source /home/bob/.bashrc

### Explanation
- PATH → executable search path
- prepend custom directory
- export → make available to shell
- source → apply changes immediately

</details>
