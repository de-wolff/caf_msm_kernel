#!/bin/sh

export KERNELBASEDIR=$PWD/../JB_Kernel_update-zip-files
#export TOOLCHAIN=$HOME/CodeSourcery/Sourcery_G++_Lite/bin/arm-none-eabi-
export TOOLCHAIN=/usr/bin/arm-linux-gnueabi-

export KERNEL_FILE=HTCLEO-Kernel_3_de_wolff
export KBUILD_OUTPUT=Kernel_out/
export EXTRA_AFLAGS=-mfpu=neon 
export ARCH=arm 
export CROSS_COMPILE=$TOOLCHAIN 
rm ${KBUILD_OUTPUT}arch/arm/boot/zImage
make htcleo_defconfig
make zImage -j8 && make modules -j8

if [ -f arch/arm/boot/zImage ]; then

mkdir -p $KERNELBASEDIR/
rm -rf $KERNELBASEDIR/boot/*
rm -rf $KERNELBASEDIR/system/lib/modules/*
mkdir -p $KERNELBASEDIR/boot
mkdir -p $KERNELBASEDIR/system/
mkdir -p $KERNELBASEDIR/system/lib/
mkdir -p $KERNELBASEDIR/system/lib/modules

cp -a arch/arm/boot/zImage $KERNELBASEDIR/kernel/zImage

make ARCH=arm CROSS_COMPILE=$TOOLCHAIN INSTALL_MOD_PATH=$KERNELBASEDIR/system/lib/modules modules_install -j8

cd $KERNELBASEDIR/system/lib/modules
find -iname *.ko | xargs -i -t cp {} .
rm -rf $KERNELBASEDIR/system/lib/modules/lib
stat $KERNELBASEDIR/boot/zImage
cd ../../../
zip -r ${KERNEL_FILE}_`date +"%Y%m%d_%H_%M"`.zip kernel system META-INF work mods sdcard
else
echo "Kernel STUCK in BUILD! no zImage exist"
fi
