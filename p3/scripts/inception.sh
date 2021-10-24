#!/usr/bin/env bash
VM='ishaimouVM'

# Create and Register the VM with VirtualBox
VBoxManage createvm --name $VM \
    --ostype Ubuntu_64 \
    --basefolder "C:\Users\Ilyass\VirtualBox VMs" \
    --register \

# Create hard disk
VBoxManage createhd \
    --filename "C:\Users\Ilyass\VirtualBox VMs/$VM/$VM.vdi" \
    --format VDI --size 20480

# Configure the settings for the VM
VBoxManage modifyvm $VM --ioapic on --rtcuseutc on --pae on
VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 net --boot4 none
VBoxManage modifyvm $VM --memory 2048 --cpus 2 --vram 16 --chipset piix3 --mouse usbtablet
# VBoxManage modifyvm $VM --vrde on --vrdeport 3389,5000,5010-5012
# iptables -A INPUT -p tcp --dport 3389 -j ACCEPT
VBoxManage modifyvm $VM --nic1 nat --nictype1 82540EM --cableconnected1 on
VBoxManage modifyvm $VM --nic2 hostonly --nictype1 82540EM --cableconnected1 on --hostonlyadapter2 "VirtualBox Host-Only Ethernet Adapter #2"

# Configure the VM Storage Controllers
VBoxManage storagectl $VM --name "SATA" --add sata \
    --controller IntelAHCI --portcount 1 --hostiocache off
VBoxManage storagectl $VM --name "IDE" --add ide \
    --controller PIIX4 --hostiocache on

# Attach the hard drive to the VM
VBoxManage storageattach $VM --storagectl "SATA" --port 0 \
    --device 0 --type hdd --medium "C:\Users\Ilyass\VirtualBox VMs/$VM/$VM.vdi"

# Attach the bootable Ubuntu Server ISO to the VM
VBoxManage storageattach $VM --storagectl "IDE" --port 0 \
    --device 0 --type dvddrive --medium "C:\Users\Ilyass\Downloads\ubuntu-20.04.3-live-server-amd64.iso"


# Start VM headless mode
# VBoxManage startvm $VM --type headless

# Eject the DVD
# VBoxManage storageattach $VM --storagectl "IDE" --port 0 \
#     --device 0 --type dvddrive --medium none

# Stop VM
# VBoxManage controlvm $VM poweroff

# Delete VM
# VBoxManage unregistervm $VM --delete


# VBoxManage list vms
# VBoxManage list runningvms
# VBoxManage snapshot $VM take <name of snapshot>
# VBoxManage snapshot $VM restore <name of snapshot>

