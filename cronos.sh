#!/bin/bash
#
# Cronos Build Script V3.3
# For Exynos7420
# Coded by BlackMesa/AnanJaser1211 @2019
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software

# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Main Dir
CR_DIR=$(pwd)
# Define toolchan path
CR_TC=~/Android/Toolchains/linaro-4.9.4-aarch64-linux/bin/aarch64-linux-gnu-
# Define proper arch and dir for dts files
CR_DTS=arch/arm64/boot/dts
# Define boot.img out dir
CR_OUT=$CR_DIR/Cronos/out
# Presistant A.I.K Location
CR_AIK=$CR_DIR/Cronos/A.I.K
# Main Ramdisk Location
CR_RAMDISK=$CR_DIR/Cronos/Ramdisk
# Compiled image name and location (Image/zImage)
CR_KERNEL=$CR_DIR/arch/arm64/boot/Image
# Compiled dtb by dtbtool
CR_DTB=$CR_DIR/boot.img-dtb
# Kernel Name and Version
CR_VERSION=V4.0
CR_NAME=CronosKernel
# Thread count
CR_JOBS=$((`nproc`-1))
# Target android version and platform (7/n/8/o/9/p)
CR_ANDROID=o
CR_PLATFORM=8.0.0
# Target ARCH
CR_ARCH=arm64
# Current Date
CR_DATE=$(date +%Y%m%d)
# Init build
export CROSS_COMPILE=$CR_TC
# General init
export ANDROID_MAJOR_VERSION=$CR_ANDROID
export PLATFORM_VERSION=$CR_PLATFORM
export $CR_ARCH
##########################################
# Device specific Variables [SM-N920CIGSLK]
CR_DTSFILES_N920C="exynos7420-noblelte_eur_open_00.dtb exynos7420-noblelte_eur_open_01.dtb exynos7420-noblelte_eur_open_02.dtb exynos7420-noblelte_eur_open_03.dtb exynos7420-noblelte_eur_open_04.dtb exynos7420-noblelte_eur_open_05.dtb exynos7420-noblelte_eur_open_06.dtb exynos7420-noblelte_eur_open_08.dtb exynos7420-noblelte_eur_open_09.dtb"
CR_CONFG_N920C=noblelte_defconfig
CR_VARIANT_N920C=N920X
# Device specific Variables [SM-G92X]
CR_DTSFILES_G920F="exynos7420-zeroflte_eur_open_06.dtb exynos7420-zeroflte_eur_open_07.dtb"
CR_VARIANT_G920F=G920F
CR_DTSFILES_G925F="exynos7420-zerolte_eur_open_08.dtb"
CR_VARIANT_G925F=G925F
CR_CONFG_G92X=zerolte_defconfig
CR_CONFIG_G920F=zerof_defconfig
CR_CONFIG_G925F=zero_defconfig
#####################################################

# Script functions

read -p "Clean source (y/n) > " yn
if [ "$yn" = "Y" -o "$yn" = "y" ]; then
     echo "Clean Build"
     make clean && make mrproper
     rm -r -f $CR_DTB
     rm -rf $CR_DTS/.*.tmp
     rm -rf $CR_DTS/.*.cmd
     rm -rf $CR_DTS/*.dtb
     rm -rf $CR_DIR/.config
else
     echo "Dirty Build"
     rm -r -f $CR_DTB
     rm -rf $CR_DTS/.*.tmp
     rm -rf $CR_DTS/.*.cmd
     rm -rf $CR_DTS/*.dtb
     rm -rf $CR_DIR/.config
fi

BUILD_IMAGE_NAME()
{
	CR_IMAGE_NAME=$CR_NAME-$CR_VERSION-$CR_VARIANT-$CR_DATE
}

BUILD_GENERATE_CONFIG()
{
  # Only use for devices that are unified with 2 or more configs
  echo "----------------------------------------------"
	echo " "
	echo "Building deconfig for $CR_VARIANT"
  echo " "
  if [ -e $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig ]; then
    echo " cleanup old configs "
    rm -rf $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  fi
  echo " Copy $CR_CONFIG "
  cp -f $CR_DIR/arch/$CR_ARCH/configs/$CR_CONFIG $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  if [ $CR_CONFIG_SPLIT=*_defconfig ]; then
    echo " Copy $CR_CONFIG_SPLIT "
    cat $CR_DIR/arch/$CR_ARCH/configs/$CR_CONFIG_SPLIT >> $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
    echo " Set $CR_VARIANT to Combined config "
    CR_CONFIG=tmp_defconfig
  fi
}

BUILD_ZIMAGE()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building zImage for $CR_VARIANT"
	export LOCALVERSION=-$CR_IMAGE_NAME
	echo "Make $CR_CONFIG"
	make $CR_CONFIG
	make -j$CR_JOBS
	if [ ! -e ./arch/arm64/boot/Image ]; then
	exit 0;
	echo "Image Failed to Compile"
	echo " Abort "
	fi
	du -k "$CR_KERNEL" | cut -f1 >sizT
	sizT=$(head -n 1 sizT)
	rm -rf sizT
	echo " "
	echo "----------------------------------------------"
}
BUILD_DTB()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building DTB for $CR_VARIANT"
	# Use the DTS list provided in the build script.
	# This source does not compile dtbs while doing Image
	make $CR_DTSFILES
	./scripts/dtbTool/dtbTool -o $CR_DTB -d $CR_DTS/ -s 2048
	if [ ! -e $CR_DTB ]; then
	exit 0;
	echo "DTB Failed to Compile"
	echo " Abort "
	fi
	rm -rf $CR_DTS/.*.tmp
	rm -rf $CR_DTS/.*.cmd
	rm -rf $CR_DTS/*.dtb
	du -k "$CR_DTB" | cut -f1 >sizdT
	sizdT=$(head -n 1 sizdT)
	rm -rf sizdT
	echo " "
	echo "----------------------------------------------"
}
PACK_BOOT_IMG()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building Boot.img for $CR_VARIANT"
	cp -rf $CR_RAMDISK/* $CR_AIK
	# Copy Ramdisk
	cp -rf $CR_RAMDISK/* $CR_AIK
	# Move Compiled kernel and dtb to A.I.K Folder
	mv $CR_KERNEL $CR_AIK/split_img/boot.img-zImage
	mv $CR_DTB $CR_AIK/split_img/boot.img-dtb
	# Create boot.img
	$CR_AIK/repackimg.sh
	# Remove red warning at boot
	echo -n "SEANDROIDENFORCE" » $CR_AIK/image-new.img
	# Move boot.img to out dir
	mv $CR_AIK/image-new.img $CR_OUT/$CR_IMAGE_NAME.img
	du -k "$CR_OUT/$CR_IMAGE_NAME.img" | cut -f1 >sizkT
	sizkT=$(head -n 1 sizkT)
	rm -rf sizkT
	echo " "
	$CR_AIK/cleanup.sh
}
# Main Menu
clear
echo "----------------------------------------------"
echo "$CR_NAME $CR_VERSION Build Script"
echo "----------------------------------------------"
PS3='Please select your option (1-2): '
menuvar=("SM-N920X" "SM-G920F" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "SM-N920X")
            clear
            echo "Starting $CR_VARIANT_N920C kernel build..."
            CR_VARIANT=$CR_VARIANT_N920C
            CR_CONFIG=$CR_CONFG_N920C
            CR_DTSFILES=$CR_DTSFILES_N920C
            BUILD_IMAGE_NAME
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            echo " "
            echo "----------------------------------------------"
            echo "$CR_VARIANT kernel build finished."
            echo "Compiled DTB Size = $sizdT Kb"
            echo "Kernel Image Size = $sizT Kb"
            echo "Boot Image   Size = $sizkT Kb"
            echo "$CR_OUT/$CR_IMAGE_NAME.img Ready"
            echo "Press Any key to end the script"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "SM-G920F")
            clear
            echo "Starting $CR_VARIANT_G920F kernel build..."
            CR_VARIANT=$CR_VARIANT_G920F
            CR_CONFIG=$CR_CONFG_G92X
            CR_CONFIG_SPLIT=$CR_CONFIG_G920F
            CR_DTSFILES=$CR_DTSFILES_G920F
            BUILD_IMAGE_NAME
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            echo " "
            echo "----------------------------------------------"
            echo "$CR_VARIANT kernel build finished."
            echo "Compiled DTB Size = $sizdT Kb"
            echo "Kernel Image Size = $sizT Kb"
            echo "Boot Image   Size = $sizkT Kb"
            echo "$CR_OUT/$CR_IMAGE_NAME.img Ready"
            echo "Press Any key to end the script"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
            "Exit")
            break
            ;;
        *) echo Invalid option.;;
    esac
done
