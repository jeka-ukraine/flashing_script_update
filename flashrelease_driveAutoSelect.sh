#!/usr/bin/env bash

set -e

regex='\w+-\S+\.(\w+)-(\S+)_Images\.tar'
archive=$1
vip_output='/media/sf_VM_Share/'

###added
DRIVE_NAME=$(lsblk | grep -o "sd\w11" | grep -P -o --colour "[a-z]{3}")

if [[ $(basename "$archive") =~ $regex ]]; then
	reltype=${BASH_REMATCH[1]}
	version=${BASH_REMATCH[2]}
	echo "Flashing $reltype version $version"
fi

output_dir="$reltype-$version"

echo "Exracting to $output_dir"

mkdir -p $output_dir
sudo tar -xf $archive --directory $output_dir

echo "Copy VIP files to $vip_output"

###modified
#prefix="$output_dir/Tools/Autogrator/resources/cards/Mfa2H2RH850Firmwarev${version}/master/lin_opt/BIN/MFA2_C5_B3/"

#verification for VANs firware
VAN_regex='VANS'
if [[ $1 =~ $VAN_regex ]];
then
        prefix="$output_dir/Tools/Autogrator/resources/cards/Mfa2H2RH850Firmwarev${version}/master/lin_opt/BIN/MFA2_VANS_B3"
        #echo "VANs prefix"
else
        prefix="$output_dir/Tools/Autogrator/resources/cards/Mfa2H2RH850Firmwarev${version}/master/lin_opt/BIN/MFA2_C5_B3"
        #echo "CARs prefix"
fi

#verification for 0.1.0 instead of current version
ZERO_VERSION='0.1.0'
if [[ ! -f "$prefix/MFA2_VIP_C5_B3_fls_img.srec" ]];
then
        prefix="$output_dir/Tools/Autogrator/resources/cards/Mfa2H2RH850Firmwarev${ZERO_VERSION}/master/lin_opt/BIN/MFA2_C5_B3"
fi

####################


cp "$prefix/MFA2_VIP_C5_B3_fls_img.srec" "$vip_output/"
cp "$prefix/globalValidFlag.hex" "$vip_output/"

echo "Start Autogrator"

cd "$output_dir/Tools/Autogrator"

###modified
sudo ./Autogrator.sh deploy --cardName Mfa2M2Emmcv${version} --device /dev/$DRIVE_NAME

###added
echo ""
echo "============================"
echo "Network setup; User and Group of 'sshd' verification:"
sudo mount -t ext4 /dev/$DRIVE_NAME\8  /mnt/
echo "auto eth0    
iface eth0 inet dhcp" >> /mnt/etc/network/interfaces 

#check user and groop of sshd
$SSHD_ROOT_NUMBER=$(ls -l /var/lib/ | grep sshd | grep -c sshd)
if ! [ "$SSHD_ROOT_NUMBER" = "2" ]; then
	sudo chown root:root /mnt/var/lib/sshd -R
	echo "sshd user and group were changed to root."
else
	echo "sshd user and group were correct."
fi

sync
sudo umount /dev/$DRIVE_NAME\8
echo "Network setup; User and Group of 'sshd' verification are done."
echo "============================"

#adding scopes
echo ""
echo "============================"
echo "Adding scopes to 'default.sco'"
sudo mount -t ext4 /dev/$DRIVE_NAME\9  /mnt/

echo "VERSION 1.0

UICockpit.* INFO
UICockpitServerIVI.* DEBUG
UIServerProcessIVI.* INFO

UICockpit.HAL_Tuner.* WARN

UICockpit.HAL_RUI.* DEBUG
UICockpit.HAL_infotainment.TimeAndDateServiceDelegate WARN" >> /mnt/etc/trace/default.sco 
sync
sudo umount /dev/$DRIVE_NAME\9
echo "Scopes added."
echo "============================"



