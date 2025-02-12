#!/bin/sh  

# Root check -> Only root can execute this script
if [ "$(id -u)" -ne 0 ]; then 
    echo "This script must be run as root!"
    exit 1 
fi 

# Arguments: <Disk-Name> <Mount-Path>
if [ "$#" -ne 2 ]; then 
    echo "Incorrect usage!"
    echo "Syntax: $0 <Disk-Name> <Mount-Path>"
    echo "Example: $0 teo_disk /mnt/teo_home"
    exit 1 
fi 

DISK_NAME=$1
MOUNT_PATH=$2 
DISK_IMG="$DISK_NAME.img"

# Check if the disk image exists
if [ ! -f "$DISK_IMG" ]; then
    echo "Error: The file $DISK_IMG does not exist!"
    exit 1
fi

# Set up loopback device
LOOP_DEVICE=$(losetup -f)
losetup "$LOOP_DEVICE" "$DISK_IMG"

# Mount the disk
mkdir -p "$MOUNT_PATH"
mount "$LOOP_DEVICE" "$MOUNT_PATH"

# Retrieve the UUID of the disk
UUID=$(blkid -o value -s UUID "$LOOP_DEVICE")

# Add disk to /etc/fstab (if not already present)
if ! grep -q "$UUID" /etc/fstab; then 
    echo "UUID=$UUID $MOUNT_PATH ext4 default 0 2" >> /etc/fstab
    echo "Disk $DISK_NAME has been added to /etc/fstab!" 
else 
    echo "Disk $DISK_NAME is already in /etc/fstab!"
fi

echo "Disk $DISK_NAME will now be automatically mounted at every reboot!"
