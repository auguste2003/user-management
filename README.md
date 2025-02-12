

```md
#  Automatic User & Disk Management with Bourne Shell (sh)  

This project provides **Bourne Shell (`sh`)** scripts to manage user home directories on virtual disks.  
It allows you to:  
✅ **Create users with a separate virtual disk as their home**  
✅ **Automatically mount the disk after reboot (fstab entry)**  
✅ **Cleanly remove users & disks when needed**  

---

##  Installation & Usage  

### **1️ Setup Script: Create a New User with a Dedicated Disk**  
```sh
sudo ./setup.sh <USERNAME> <DISK-SIZE_MB> <DISK-NAME> <MOUNT-PATH>
```
**Example:**  
```sh
sudo ./setup.sh teo 500 teo_disk /mnt/teo_home
```
➡ Creates a **500 MB virtual disk** for user **`teo`** and mounts it at `/mnt/teo_home`.  

---

### **2️ Enable Automatic Mounting After Reboot**  
```sh
sudo ./setup_autoload.sh <DISK-NAME> <MOUNT-PATH>
```
**Example:**  
```sh
sudo ./setup_autoload.sh teo_disk /mnt/teo_home
```
➡ The disk will now be automatically mounted after every reboot.  

---

### **3️ Cleanly Remove User & Disk**  
```sh
sudo ./unmount_and_delete.sh <DISK-NAME> <MOUNT-PATH> <USERNAME>
```
**Example:**  
```sh
sudo ./unmount_and_delete.sh teo_disk /mnt/teo_home teo
```
➡ Removes the virtual disk **teo_disk**, deletes the user **teo**, and removes the `/etc/fstab` entry.  

---

##  Debugging & Testing  
If any issues occur, check:  
```sh
lsblk  # Shows active disks
mount | grep /mnt/teo_home  # Checks if the disk is mounted
losetup -a  # Lists active loopback devices
df -h | grep teo  # Checks disk space usage
```
If a disk is corrupted:  
```sh
sudo mkfs.ext4 teo_disk.img  # Reformat as ext4
```

---

##  Requirements  
🔹 **Bourne Shell (`sh`)** must be installed (default in Linux).  
🔹 **Root privileges (`sudo`)** are required.  
🔹 The following commands must be available: **`losetup`, `mount`, `useradd`, `mkfs.ext4`**.  

---

##  Author  
 Created by **[Auguste Atoundem Sonfack]**  
 GitHub: **[https://github.com/auguste2003]**
```

---


