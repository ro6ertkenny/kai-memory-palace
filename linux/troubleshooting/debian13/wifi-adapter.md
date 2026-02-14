lsusb 

Bus 001 Device 006: ID 2357:0115 TP-Link Archer T4U ver.3

sudo apt update && sudo apt upgrade

sudo apt install build-essential dkms git linux-headers-$(uname -r)

git clone https://github.com/morrownr/88x2bu-20210702.git
cd 88x2bu-20210702

sudo ./install-driver.sh

sudo reboot

Edit the file to change from USB 2 to USB 3:

sudo nano /etc/modprobe.d/88x2bu.conf

The Change
Look for the line that starts with options 88x2bu. Find the specific setting and change the 0 to a 1 as follows: 
From: rtw_switch_usb_mode=0
To: rtw_switch_usb_mode=1 

