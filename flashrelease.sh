#!/usr/bin/env bash

set -e

regex='\w+-\S+\.(\w+)-(\S+)_Images\.tar'
archive=$1
vip_output='/media/sf_VM_Share/'

###added
$DRIVE_NAME=$(lsblk -f | grep -o "sd\w1" | grep -P -o --colour "[a-z]{3}")

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

prefix="$output_dir/Tools/Autogrator/resources/cards/Mfa2H2RH850Firmwarev${version}/master/lin_opt/BIN/MFA2_C5_B3/"

cp "$prefix/MFA2_VIP_C5_B3_fls_img.srec" "$vip_output/"
cp "$prefix/globalValidFlag.hex" "$vip_output/"

echo "Start Autogrator"

cd "$output_dir/Tools/Autogrator"

###modified
sudo ./Autogrator.sh deploy --cardName Mfa2M2Emmcv${version} --device /dev/$DRIVE_NAME

echo ""
echo "============================"
echo "Network setup..."
echo "auto eth0    
iface eth0 inet dhcp" >> 




echo "Network setup is done."
echo "============================"

echo ""
echo "============================"
echo "Adding scopes to trace..."




echo "Scopes added."
echo "============================"

