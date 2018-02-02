# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=Ashish94 @ xda-developers
do.devicecheck=0
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
} # end properties 

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
chmod -R 755 $ramdisk


## AnyKernel install
dump_boot;

# begin ramdisk changes

# add excalibur initialization script
insert_line init.rc "import /init.excalibur.rc" after "import /init.environ.rc" "import /init.excalibur.rc";
cp /tmp/init.excalibur.rc /tmp/anykernel/ramdisk/init.excalibur.rc
chmod 0750 /tmp/anykernel/ramdisk/init.excalibur.rc

#set min freq
cpu0=`grep selected.1 /tmp/aroma/cpu0.prop | cut -d '=' -f2`
if [ $cpu0 = 1 ]; then
replace_line init.qcom.power.rc "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 800000";
elif [ $cpu0 = 2 ]; then
replace_line init.qcom.power.rc "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 533330";
elif [ $cpu0 = 3 ]; then
replace_line init.qcom.power.rc "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 400000";
elif [ $cpu0 = 4 ]; then
replace_line init.qcom.power.rc "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 302000";
else
replace_line init.qcom.power.rc "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 200000";
fi;

#set io scheduler
SCHED=`grep selected.1 /tmp/aroma/sched.prop | cut -d '=' -f2`
if [ $SCHED = 1 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"bfq\"";
elif [ $SCHED = 2 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"cfq\"";
elif [ $SCHED = 3 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"deadline\"";
elif [ $SCHED = 4 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"noop\"";
else
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"row\"";
fi;

#remove deprecated ipv6 rmnet entries
remove_line init.qcom.rc "    #To allow interfaces to get v6 address when tethering is enabled"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet0/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet0/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet1/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet2/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet3/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet4/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet5/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet6/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet7/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_sdio0/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_sdio1/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_sdio2/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_sdio3/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_sdio4/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_sdio5/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_sdio6/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_sdio7/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_usb0/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_usb1/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_usb2/accept_ra 2"
remove_line init.qcom.rc "    write /proc/sys/net/ipv6/conf/rmnet_usb3/accept_ra 2"

#remove stock interactive target load
remove_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpufreq/interactive/target_loads"
remove_line init.qcom.power.rc "    write /sys/devices/system/cpu/cpufreq/interactive/io_is_busy"
replace_line init.qcom.power.rc "    start perfd" "    stop perfd"

# ZRAM
misc=`grep selected.2 /tmp/aroma/misc.prop | cut -d '=' -f2`
if [ $misc = 1 ]; then
replace_line fstab.qcom "/dev/block/zram0" "/dev/block/zram0                              none        swap            defaults             zramsize=536870912,notrim";
elif [ $misc = 2 ]; then
replace_line fstab.qcom "/dev/block/zram0" "/dev/block/zram0                              none        swap            defaults             zramsize=824180736,notrim";
else
replace_line fstab.qcom "/dev/block/zram0" "/dev/block/zram0                              none        swap            defaults             zramsize=1073741824,notrim";
fi;

# end ramdisk changes

write_boot;

## end install

