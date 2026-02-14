✅ Quick Fix (start the default network)

Run this on your host (not inside a VM):

sudo virsh net-start default


Make it auto-start every boot:

sudo virsh net-autostart default


Now start the VM again.
