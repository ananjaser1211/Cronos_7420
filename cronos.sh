#!/bin/bash
#
# Cronos Build Script V4.1
# For Exynos7420
# Coded by AnanJaser1211 @2019
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
CR_DTS_S6_2600=arch/arm64/boot/G92X_battery_2600.dtsi
CR_DTS_S6_3600=arch/arm64/boot/G92X_battery_3600.dtsi
CR_DECON=$CR_DIR/drivers/video/exynos
# Define boot.img out dir
CR_OUT=$CR_DIR/Cronos/out
CR_PRODUCT=$CR_DIR/Cronos/Product
# Presistant A.I.K Location
CR_AIK=$CR_DIR/Cronos/A.I.K
# Main Ramdisk Location
CR_RAMDISK=$CR_DIR/Cronos/Ramdisk
CR_RAMDISK_Q=$CR_DIR/Cronos/Q
# Compiled image name and location (Image/zImage)
CR_KERNEL=$CR_DIR/arch/arm64/boot/Image
# Compiled dtb by dtbtool
CR_DTB=$CR_DIR/boot.img-dtb
# Kernel Name and Version
CR_VERSION=V5.1
CR_NAME=CronosKernel
# Thread count
CR_JOBS=$(nproc --all)
# Target android version and platform (7/n/8/o/9/p)
CR_ANDROID=o
CR_PLATFORM=8.0.0
# Target ARCH
CR_ARCH=arm64
# Current Date
CR_DATE=$(date +%Y%m%d)
# Init build
export CROSS_COMPILE=$CR_TC
export ANDROID_MAJOR_VERSION=$CR_ANDROID
export PLATFORM_VERSION=$CR_PLATFORM
export $CR_ARCH
##########################################
# Device specific Variables [SM-N920X]
CR_DTSFILES_N920C="exynos7420-noblelte_eur_open_00.dtb exynos7420-noblelte_eur_open_09.dtb"
CR_DTSFILES_N920T="exynos7420-noblelte_usa_00.dtb exynos7420-noblelte_usa_09.dtb"
CR_CONFIG_N920C=noblelte_defconfig
CR_VARIANT_N920C=N920X
CR_VARIANT_N920T=N920TW8
# Device specific Variables [SM-G928X]
CR_DTSFILES_G928X="exynos7420-zenlte_eur_open_00.dtb exynos7420-zenlte_eur_open_09.dtb"
CR_DTSFILES_G928T="exynos7420-zenlte_usa_00.dtb exynos7420-zenlte_usa_09.dtb"
CR_CONFIG_G928X=zenlte_defconfig
CR_VARIANT_G928X=G928X
CR_VARIANT_G928T=G928TW8
# Device specific Variables [SM-G92X]
CR_DTSFILES_G92X="G92X_universal.dtb"
CR_VARIANT_G92X=G92X
CR_CONFIG_G92X=zerolte_defconfig
# Pre Unification
#CR_DTSFILES_G920X="exynos7420-zeroflte_eur_open_00.dtb exynos7420-zeroflte_eur_open_01.dtb exynos7420-zeroflte_eur_open_02.dtb exynos7420-zeroflte_eur_open_03.dtb exynos7420-zeroflte_eur_open_04.dtb exynos7420-zeroflte_eur_open_05.dtb exynos7420-zeroflte_eur_open_06.dtb exynos7420-zeroflte_eur_open_07.dtb"
#CR_DTSFILES_G925X="exynos7420-zerolte_eur_open_01.dtb exynos7420-zerolte_eur_open_02.dtb exynos7420-zerolte_eur_open_03.dtb exynos7420-zerolte_eur_open_04.dtb exynos7420-zerolte_eur_open_05.dtb exynos7420-zerolte_eur_open_06.dtb exynos7420-zerolte_eur_open_07.dtb exynos7420-zerolte_eur_open_08.dtb"
#CR_DTSFILES_G920T="exynos7420-zeroflte_usa_00.dtb exynos7420-zeroflte_usa_01.dtb exynos7420-zeroflte_usa_02.dtb exynos7420-zeroflte_usa_03.dtb exynos7420-zeroflte_usa_04.dtb exynos7420-zeroflte_usa_05.dtb"
#CR_DTSFILES_G925T="exynos7420-zerolte_usa_01.dtb exynos7420-zerolte_usa_02.dtb exynos7420-zerolte_usa_03.dtb exynos7420-zerolte_usa_04.dtb exynos7420-zerolte_usa_05.dtb exynos7420-zerolte_usa_06 exynos7420-zerolte_usa_07.dtb exynos7420-zerolte_usa_08.dtb"
#CR_VARIANT_G920X=G920X
#CR_VARIANT_G920T=G920TW8
#CR_VARIANT_G925X=G925X
#CR_VARIANT_G925T=G925TW8
#CR_CONFIG_G920X=zerof_defconfig
#CR_CONFIG_G925X=zero_defconfig
# Common configs
CR_CONFIG_AUDIENCE=audience_defconfig
CR_CONFIG_INTL=intl_defconfig
CR_CONFIG_SPLIT=NULL
CR_CONFIG_HELIOS=helios_defconfig
CR_S6MOD="2"
CR_AUDIO=NULL
#####################################################

# Script functions

read -p "Clean source (y/n) > " yn
if [ "$yn" = "Y" -o "$yn" = "y" ]; then
     echo "Clean Build"
     CR_CLEAN="1"
else
     echo "Dirty Build"
     CR_CLEAN="0"
fi

# Treble / OneUI
read -p "Variant? (1 (OneUI) | 2 (OneUI Q) > " aud
if [ "$aud" = "1" ]; then
     echo "Build OneUI Variant"
     CR_MODE="1"
fi
if [ "$aud" = "2" ]; then
     echo "Build OneUI Q Variant"
     CR_MODE="2"
fi

BUILD_CLEAN()
{
if [ $CR_CLEAN = 1 ]; then
     echo " "
     echo " Cleaning build dir"
     make clean && make mrproper
     rm -r -f $CR_DTB
     rm -rf $CR_DTS/.*.tmp
     rm -rf $CR_DTS/.*.cmd
     rm -rf $CR_DTS/*.dtb
     rm -rf $CR_DIR/.config
     rm -rf $CR_OUT/*.img
     rm -rf $CR_OUT/*.zip
     rm -rf $CR_DTS/G92X_battery.dtsi
fi
if [ $CR_CLEAN = 0 ]; then
     echo " "
     echo " Skip Full cleaning"
     rm -r -f $CR_DTB
     rm -rf $CR_DTS/.*.tmp
     rm -rf $CR_DTS/.*.cmd
     rm -rf $CR_DTS/*.dtb
     rm -rf $CR_DIR/.config
     rm -rf $CR_DTS/G92X_battery.dtsi
fi
}

BUILD_IMAGE_NAME()
{
	CR_IMAGE_NAME=$CR_NAME-$CR_VERSION-$CR_VARIANT-$CR_DATE
}

BUILD_GENERATE_CONFIG()
{
  # Only use for devices that are unified with 2 or more configs
  echo "----------------------------------------------"
	echo " "
	echo "Building defconfig for $CR_VARIANT"
  echo " "
  # Respect CLEAN build rules
  BUILD_CLEAN
  if [ -e $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig ]; then
    echo " cleanup old configs "
    rm -rf $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  fi
  echo " Copy $CR_CONFIG "
  cp -f $CR_DIR/arch/$CR_ARCH/configs/$CR_CONFIG $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  if [ $CR_CONFIG_SPLIT = NULL ]; then
    echo " No split config support! "
  else
    echo " Copy $CR_CONFIG_SPLIT "
    cat $CR_DIR/arch/$CR_ARCH/configs/$CR_CONFIG_SPLIT >> $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  fi
  if [ $CR_CONFIG_AUDIO = "$CR_CONFIG_AUDIENCE" ]; then
    echo " Copy $CR_CONFIG_AUDIO "
    cat $CR_DIR/arch/$CR_ARCH/configs/$CR_CONFIG_AUDIO >> $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  fi
  echo " Copy $CR_CONFIG_HELIOS "
  cat $CR_DIR/arch/$CR_ARCH/configs/$CR_CONFIG_HELIOS >> $CR_DIR/arch/$CR_ARCH/configs/tmp_defconfig
  echo " Set $CR_VARIANT to generated config "
  CR_CONFIG=tmp_defconfig
}

BUILD_HACKS()
{
	echo "----------------------------------------------"
	echo " "
  	echo " Applying HACKS for $CR_VARIANT"
    rm -rf $CR_DECON/decon
    if [ $CR_VIDEO = "noble" ]; then
    echo " Copy Noble Video driver"
    cp -rf $CR_DIR/Cronos/video/decon_noble $CR_DECON/decon/
    fi
    if [ $CR_VIDEO = "zero" ]; then
    echo " Copy Zero Video driver"
    cp -rf $CR_DIR/Cronos/video/decon_zero $CR_DECON/decon/
    fi
	echo " "
	echo "----------------------------------------------"
}

BUILD_OUT()
{
    echo " "
    echo "----------------------------------------------"
    echo "$CR_VARIANT kernel build finished."
    echo "Compiled DTB Size = $sizdT Kb"
    echo "Kernel Image Size = $sizT Kb"
    echo "Boot Image   Size = $sizkT Kb"
    echo "$CR_PRODUCT/$CR_IMAGE_NAME.img Ready"
    echo "Press Any key to end the script"
    echo "----------------------------------------------"
}

BUILD_ZIMAGE()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building zImage for $CR_VARIANT"
  # Make sure image name is set
  BUILD_IMAGE_NAME
	export LOCALVERSION=-$CR_IMAGE_NAME
    if [ $CR_S6MOD = "1" ]; then
    echo " Copy Modded S6 Battery DTSI"
    rm -rf $CR_DTS/G92X_battery.dtsi
  	cp $CR_DTS_S6_3600 $CR_DTS/G92X_battery.dtsi
    CR_VARIANT=$CR_VARIANT-ext
    fi
    if [ $CR_S6MOD = "0" ]; then
    echo " Copy Stock S6 Battery DTSI"
    rm -rf $CR_DTS/G92X_battery.dtsi
  	cp $CR_DTS_S6_2600 $CR_DTS/G92X_battery.dtsi
    CR_VARIANT=$CR_VARIANT-stk
    fi
	echo "Make $CR_CONFIG"
	make $CR_CONFIG
	make -j$CR_JOBS
	if [ ! -e $CR_KERNEL ]; then
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
  rm -rf $CR_DTS/G92X_battery.dtsi
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
	# Copy Ramdisk
	cp -rf $CR_RAMDISK/* $CR_AIK
	# Move Compiled kernel and dtb to A.I.K Folder
	mv $CR_KERNEL $CR_AIK/split_img/boot.img-zImage
	mv $CR_DTB $CR_AIK/split_img/boot.img-dtb
	# Create boot.img
	$CR_AIK/repackimg.sh
	# Remove red warning at boot
	echo -n "SEANDROIDENFORCE" » $CR_AIK/image-new.img
	# Copy boot.img to Production folder
	cp $CR_AIK/image-new.img $CR_PRODUCT/$CR_IMAGE_NAME.img
	# Move boot.img to out dir
	mv $CR_AIK/image-new.img $CR_OUT/$CR_IMAGE_NAME.img
	du -k "$CR_OUT/$CR_IMAGE_NAME.img" | cut -f1 >sizkT
	sizkT=$(head -n 1 sizkT)
	rm -rf sizkT
	echo " "
	$CR_AIK/cleanup.sh
	# Respect CLEAN build rules
	BUILD_CLEAN
}
# Main Menu
clear
echo "----------------------------------------------"
echo "$CR_NAME $CR_VERSION Build Script"
echo "----------------------------------------------"
PS3='Please select your option (1-5): '
menuvar=("SM-N920X" "SM-G928X" "SM-G92X" "ALL" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "SM-N920X")
            clear
            echo "Starting $CR_VARIANT_N920C kernel build..."
            CR_CONFIG=$CR_CONFIG_N920C
            CR_VIDEO="noble"
            echo " Adding Audience support "
            CR_CONFIG_AUDIO=$CR_CONFIG_AUDIENCE
            CR_VARIANT=$CR_VARIANT_N920C
            CR_DTSFILES=$CR_DTSFILES_N920T
            if [ $CR_MODE = "1" ]; then
              echo " Building Oneui variant "
              CR_VARIANT=$CR_VARIANT-OneUI
            fi
            if [ $CR_MODE = "2" ]; then
              echo " Building Oneui-Q variant "
              CR_VARIANT=$CR_VARIANT-Q
              CR_RAMDISK=$CR_RAMDISK_Q
            fi
            BUILD_HACKS
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            BUILD_IMAGE_NAME
            PACK_BOOT_IMG
            BUILD_OUT
            read -n1 -r key
            break
            ;;
        "SM-G92X")
            clear
            echo "Starting $CR_VARIANT_G92X kernel build..."
            CR_CONFIG=$CR_CONFIG_G92X
            CR_DTSFILES=$CR_DTSFILES_G92X
            CR_VARIANT=$CR_VARIANT_G92X
            CR_VIDEO="zero"
            CR_AUDIO=NULL
            if [ $CR_MODE = "1" ]; then
              echo " Building Oneui variant "
              CR_VARIANT=$CR_VARIANT-OneUI
            fi
            if [ $CR_MODE = "2" ]; then
              echo " Building Oneui-Q variant "
              CR_VARIANT=$CR_VARIANT-Q
              CR_RAMDISK=$CR_RAMDISK_Q
            fi
            read -p "Extended Battery? (y/n) > " yn
            if [ "$yn" = "Y" -o "$yn" = "y" ]; then
                 echo "Including S7E Battery modded DTSI"
                 CR_S6MOD="1"
            fi
            if [ "$yn" = "N" -o "$yn" = "n" ]; then
                 echo "Including Stock Battery DTSI"
                 CR_S6MOD="0"
            fi
            BUILD_HACKS
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            BUILD_IMAGE_NAME
            PACK_BOOT_IMG
            BUILD_OUT
            read -n1 -r key
            break
            ;;
        "SM-G928X")
            clear
            echo "Starting $CR_VARIANT_G928X kernel build..."
            CR_CONFIG=$CR_CONFIG_G928X
            CR_VIDEO="noble"
            echo " Adding Audience support "
            CR_CONFIG_AUDIO=$CR_CONFIG_AUDIENCE
            CR_VARIANT=$CR_VARIANT_G928X
            CR_DTSFILES=$CR_DTSFILES_G928T
            if [ $CR_MODE = "1" ]; then
              echo " Building Oneui variant "
              CR_VARIANT=$CR_VARIANT-OneUI
            fi
            if [ $CR_MODE = "2" ]; then
              echo " Building Oneui-Q variant "
              CR_VARIANT=$CR_VARIANT-Q
              CR_RAMDISK=$CR_RAMDISK_Q
            fi
            BUILD_HACKS
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            BUILD_IMAGE_NAME
            PACK_BOOT_IMG
            BUILD_OUT
            read -n1 -r key
            break
            ;;
        "ALL")
            echo "Starting $CR_VARIANT_N920C kernel build..."
            CR_CONFIG=$CR_CONFIG_N920C
            CR_VIDEO="noble"
            echo " Adding Audience support "
            CR_CONFIG_AUDIO=$CR_CONFIG_AUDIENCE
            CR_VARIANT=$CR_VARIANT_N920C
            CR_DTSFILES=$CR_DTSFILES_N920T
            if [ $CR_MODE = "1" ]; then
              echo " Building Oneui variant "
              CR_VARIANT=$CR_VARIANT-OneUI
            fi
            if [ $CR_MODE = "2" ]; then
              echo " Building Oneui-Q variant "
              CR_VARIANT=$CR_VARIANT-Q
              CR_RAMDISK=$CR_RAMDISK_Q
            fi
            BUILD_HACKS
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            BUILD_IMAGE_NAME
            PACK_BOOT_IMG
            BUILD_OUT
            echo "Starting $CR_VARIANT_G928X kernel build..."
            CR_CONFIG=$CR_CONFIG_G928X
            CR_VIDEO="noble"
            echo " Adding Audience support "
            CR_CONFIG_AUDIO=$CR_CONFIG_AUDIENCE
            CR_VARIANT=$CR_VARIANT_G928X
            CR_DTSFILES=$CR_DTSFILES_G928T
            if [ $CR_MODE = "1" ]; then
              echo " Building Oneui variant "
              CR_VARIANT=$CR_VARIANT-OneUI
            fi
            if [ $CR_MODE = "2" ]; then
              echo " Building Oneui-Q variant "
              CR_VARIANT=$CR_VARIANT-Q
              CR_RAMDISK=$CR_RAMDISK_Q
            fi
            BUILD_HACKS
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            BUILD_IMAGE_NAME
            PACK_BOOT_IMG
            BUILD_OUT
            clear
            echo "Starting $CR_VARIANT_G92X 2600 kernel build..."
            CR_CONFIG=$CR_CONFIG_G92X
            CR_DTSFILES=$CR_DTSFILES_G92X
            CR_VARIANT=$CR_VARIANT_G92X
            CR_VIDEO="zero"
            CR_AUDIO=NULL
            if [ $CR_MODE = "1" ]; then
              echo " Building Oneui variant "
              CR_VARIANT=$CR_VARIANT-OneUI
            fi
            if [ $CR_MODE = "2" ]; then
              echo " Building Oneui-Q variant "
              CR_VARIANT=$CR_VARIANT-Q
              CR_RAMDISK=$CR_RAMDISK_Q
            fi
            echo "Including Stock Battery DTSI"
            CR_S6MOD="0"
            BUILD_HACKS
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            BUILD_IMAGE_NAME
            PACK_BOOT_IMG
            BUILD_OUT
            clear
            echo "Starting $CR_VARIANT_G92X 3600 kernel build..."
            CR_CONFIG=$CR_CONFIG_G92X
            CR_DTSFILES=$CR_DTSFILES_G92X
            CR_VARIANT=$CR_VARIANT_G92X
            CR_VIDEO="zero"
            CR_AUDIO=NULL
            if [ $CR_MODE = "1" ]; then
              echo " Building Oneui variant "
              CR_VARIANT=$CR_VARIANT-OneUI
            fi
            if [ $CR_MODE = "2" ]; then
              echo " Building Oneui-Q variant "
              CR_VARIANT=$CR_VARIANT-Q
              CR_RAMDISK=$CR_RAMDISK_Q
            fi
            echo "Including S7E Battery modded DTSI"
            CR_S6MOD="1"
            BUILD_HACKS
            BUILD_GENERATE_CONFIG
            BUILD_ZIMAGE
            BUILD_DTB
            BUILD_IMAGE_NAME
            PACK_BOOT_IMG
            BUILD_OUT
            read -n1 -r key
            break
            ;;
        "Exit")
            break
            ;;
        *) echo Invalid option.;;
    esac
done
