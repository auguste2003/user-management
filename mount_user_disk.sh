#!/bin/sh

# Create user and mount their home directory on a dedicated virtual disk

# Only root can execute this script
if [ "$(id -u)" -ne 0 ]; then  # root always has ID 0  
    echo "This script must be run as root!"
    exit 1
fi

# Check if all required arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Incorrect usage!"
    echo "Syntax: $0 <Username> <Disk Size in MB> <Disk Name> <Mount Path>"
    echo "Example: $0 teo 100 teo_disk /mnt/teo_home"
    exit 1
fi

# Set arguments
USER=$1
DISK_SIZE=$2
DISK_NAME=$3 
MOUNT_PATH=$4 

# Check if the user already exists
if id "$USER" > /dev/null 2>&1; then 
    echo "User $USER already exists!"
    echo "Their home directory remains unchanged."
    exit 0
else 
    echo "Creating new user $USER with home directory at $MOUNT_PATH"
fi

# Create virtual disk: teo_disk.img
dd if=/dev/zero of="$DISK_NAME.img" bs=1M count="$DISK_SIZE"

# Find a free loopback device & connect it
LOOP_DEVICE=$(losetup -f)
losetup "$LOOP_DEVICE" "$DISK_NAME.img"

# Check if losetup was successful
if [ -z "$LOOP_DEVICE" ]; then
    echo "❌ Error: Could not find a free loopback device!"
    exit 1
fi

# Create filesystem on the loopback device
mkfs.ext4 "$LOOP_DEVICE"

# Create mount point & mount the disk
mkdir -p "$MOUNT_PATH"
mount "$LOOP_DEVICE" "$MOUNT_PATH"

# If the user does not exist, create them
if ! id "$USER" >/dev/null 2>&1; then 
    # Create user & set their home directory
    useradd -m -d "$MOUNT_PATH" "$USER" 

    # Generate and set a random password
    PASSWORD=$(openssl rand -base64 12) # Generates a random 12-character password 
    echo "$USER:$PASSWORD" | chpasswd

    echo "🔑 Initial password: $PASSWORD"
    echo "$USER can change their password using: passwd"
    echo "If the admin needs to reset it: sudo passwd $USER"
else
    echo "User already exists – Home directory remains unchanged."
    exit 1
fi

# Set permissions
chown -R "$USER:$USER" "$MOUNT_PATH"
chmod 700 "$MOUNT_PATH" 

echo " User $USER successfully created and home directory set at $MOUNT_PATH!"
