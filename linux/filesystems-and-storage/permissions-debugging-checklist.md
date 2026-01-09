## 🧪 Permissions Debugging Checklist

1) Who is the user?
id

2) What is the path?
ls -ld PATH

3) What is mounted there?
findmnt PATH

4) Check attributes first:
lsattr PATH

5) Check ACLs:
getfacl PATH

6) Check special bits:
ls -l PATH

7) Finally check rwx:
ls -l PATH

Rule:

Always debug from the top of the stack down.

EOF

