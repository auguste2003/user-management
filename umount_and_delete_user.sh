#!/bin/sh

# Root-Prüfung  -> Nur der Root darf ausführen 

if [ "$(id -u)" -ne 0 ]; then 
        echo "Dieses Script muss als root ausgeführt werden"
        exit 1 

fi 

# Argumente: <Disk-Name> <Mount-Pfad> >Benutzername>

if [ "$#" -ne 3 ]; then 
        echo "Fasche Nutzung!"
        echo "Syntax: $0 <Disk-Name> <Mount-Pfad> <Benutzername>"
        echo "Beispiel: $0 teo_disk /mnt/teo_home teo"
        exit 1 

fi 

DISK_NAME=$1 
MOUNT_PATH=$2 
BENUTZER=$3
DISK_IMG="DISK_NAME.img"

# Prüfen , ob die Disk femounted ist 

if mountpoint -q "$MOUNT_PATH"; then 
        echo "Unmounting $MOUNT_PATH..."
        sudo fuser -k "$MOUNT_PATH" # Beende alle Prozesse , die das Verzeichnis benutzen
        umount "$MOUNT_PATH"
else 
        echo "Das Verzeichnis $MOUNT_PATH ist nicht gemounted!"
fi 

# Loopback-Device entfernen 
LOOP_DEVICE=$(losetup -j "$DISK_IMG" | cut -d: -f1)

if [ -n "$LOOP_DE " ]; then 
        echo "Entferne Loopback-Device $LOOP_DEVICE..."
        losetup -d "$LOOP_DEVICE"
fi

# ENtferne /etc/fstab - EIntrag 
UUID=$(blkid -o value -s UUID "$DISK_IMG")
sed -i "\|UUID=$UUID|d" /etc/fstab
echo "Disk wurde aus /etc/fstab entfernt!"

# Benutzer entfernen , falls gewünscht 
if id $BENUTZER > /dev/null 2>&1; then 
        echo "Entferne Benutzer $BENUTZER ..."
        userdel -r $BENUTZER 
else 
        echo "Benutzer $BENUTZER existiert nicht !"
fi

# Home-Verzeichniss und DISK löschen 
rm -rf $MOUNT_PATH
rm -f $DISK_IMG 

echo "Disk $DISK_NAME wurde vollständig entfernt!"

