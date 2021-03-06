# ARCH LINUX EFI BTRFS INSTALL NOTES

### Keyboard-layout

If you would like a non us qwerty lqyout:

```bash
loadkeys be-latin1
```

### Connect to the internet

```bash
wifi-menu
```

### Partition the disks

#####Cfdisk

```bash
cfdisk /dev/sdx
```

- First partiton efi) size: 1GiB, hexcode: EF00, name: boot
- Second partition swap) size: <>GiB, hexcode: 8200, name: swap 
- Third partition root) size: <>GiB, hexcode: 8300, name: root


Write to disk

> NOTE: replace sdx with the name of the partition you want to use.

> NOTE: swap size depends on ram size, 1.5 times ram, fe. if you have 16G of ram, commonly you would use a swap size of 24GiB.

> NOTE: having an all-in-one partition is used for personal use only, **for server use** it is recommended to have a seperate home and root partition.


### Format the partitions

```bash
mkfs.vfat /dev/sdx1
mkswap /dev/sdx2
swapon /dev/sdx2
mkfs.btrfs /dev/sdx3
```

### Mount the file systems

```bash
mount /dev/sdx3 /mnt
mkdir /mnt/boot
mount /dev/sdx1 /mnt/boot
```

> NOTE: if you have made a home partition you will need to create a home directory in /mnt and mount the partition to /mnt/home.

### Setting up mirrorlist

```bash
cp /etc/pacman.d.mirrorlist /etc/pacman.d/mirrorlist.backup
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
```

> NOTE: this can take a while 10-15mins.

### Pacstrap

```bash
pacstrap /mnt base base-devel
```

### Genfstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Change the fsck order of your btrfs partition in etc/fstab from **1 to 0**. 

> NOTE: check if the UUID's are the right ones and that every entry in etc/fstab has a UUID instead of the logical path (fe. /boot)! check with 'blkid'.


### Arch-chroot

```
arch-chroot /mnt
```

### Time,locale and language

Set the time zone.

```bash
ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime

hwclock --systohc
```

Edit /etc/locale.gen and search for the lines 'be_BY.UTF-8 UTF-8' and 'en_US.UTF-8 UTF-8' . Uncomment these.

```bash
locale-gen
```

```bash
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
export LANG=en_US.UTF-8
```

If you still want a non US qwerty layout

```bash
echo 'KEYMAP=be-latin1' > /etc/vconsole.conf
```

### Hostname

```bash
echo 'myhostname' > /etc/hostname
```

Add an entry to hosts.

```bash
vi /etc/hosts
```

```bash
127.0.1.1 myhostname.localdomain  myhostname
```

### Arch user repos

Edit /etc/pacman.conf and add.

```bash
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```

Now you can:

```bash
pacan -S yaourt
yaourt -S packer
```

### Root password and adding a user

```bash
passwd
```

Install sudo package (you will need the vim package first).

```bash
useradd -m -g users -G wheel,storage,power -s /bin/bash <user>
passwd <user>
```

```bash
visudo

#Uncomment '%wheel ALL=(ALL)' ALL

#Add this line under it
Defaults rootpw
```

### Install initial packages

```bash
pacman -Syyu

pacman -S intel-ucode btrfs-progs wireless_tools wpa_supplicant networkmanager network-manager-applet 
pacman -S mesa 
pacman -S xorg-server xorg-server-utils xorg-xinit xorg-twm xorg-xclock xterm
```

> NOTE: use networkmanager for auto internet access.

### Bootloader

Check if efivarfs is set up correctly.

```bash
mount -t efivarfs efivarfs /sys/firmware/efi/efivarfs
```

Use efibootmgr to configure the bootloader:

```bash
efibootmgr -d /dev/<sda> -p 1 -c -L 'Arch Linux EFISTUB' -l /vmlinuz-linux -u 'root=/dev/<sda3> rw initrd=/intel-ucode.img initrd=/initramfs-linux.img'
```

### Reboot (possible errors)

Reboot the system, if you notice a freeze the problem lies with nvidia-drivers.

Install the following packages.

```bash
pacman -S nvidia nvidia-libgl lib32-nvidia-libgl lib32-nvidia-utils nvidia-utils
#Go with the defaults
```

> NOTE: you will need to boot to the original arch installer iso, remount your partition and arch-chroot into your environment.
