#!/bin/sh

# Benutzer Teo anlegen und sein home Verzeichnis auf eigenen Disk einhängen 

# Nur der root darf ausführen 
if [ "$(id -u)" -ne 0 ]; then  # der root hat immer die id 0  
	echo "Dieses Script muss als root ausgeführt werden!"
	exit 1
fi



# virtueller Disk anlegen   : teo_disk.img

dd if=/dev/zero of=teo_disk.img bs=1M count=10

# Lookback Geräte einrichten 

losetup /dev/loop1 teo_disk.img 

# Dateisystem erstellen 
mkfs.ext4 /dev/loop1 

# mount erstellen und anhängen 
mkdir -p /mnt/teo_home 
mount /dev/loop1 /mnt/teo_home 

# Benutzer teo anlegen & Home setzen 
useradd -m -d /mnt/teo-home teo 

# PAssort genieren und setzen 
PASSWORD=$(openssl rand -base64 12) #Zufälliges 12 stelliges Passwort 
echo "teo:4PASSWORD"| chpasswd

# Berechtigungen einsetzen 
chown -R teo:teo /mnt/teo_home
chmod 700 /mnt/teo_home 

echo "Benutzer 'teo' erfolgreich erstellt und sein Home unter /mnt/teo_home !"
echo "INitiales Passwort: $PASSWORD"
echo "Teo kann sein passord ändern mit : passwd"
echo "Falls der admin es ändern muss : sudo passwd teo"


