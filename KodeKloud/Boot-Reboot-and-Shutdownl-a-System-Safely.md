# Boot, Reboot, and Shutdown a System Safely

Use the systemctl to do the following:

#### systemctl reboot
#### sudo systemctl reboot

#### sudo systemctl poweroff

If the sytem is hung and it absolutely must be turned off or rebooted type you can force it by typing:

#### sudo systemctl reboot --force
#### sudo systemctl poweroff --force

## ABSOLUTE turn off ... double force (simulates unplugging the pc from its power source):

#### sudo systemctl reboot --force --force

## Shutdown at night:

#### sudo shutdown 02:00

#### sudo shutdown +15

#### sudo shutdown -r 02:00

#### sudo shutdown -r +15

## Write wall message:

#### sudo shutdown -r +1 'Sheduled restart to upgrade our Linux kernel'





