#!/sbin/sh

#Build config file
CONFIGFILE="/tmp/init.excalibur.rc"

echo "" >> $CONFIGFILE
echo "on boot" >> $CONFIGFILE

echo "on property:sys.boot_completed=1" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#set I/O scheduler" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/queue/rq_affinity 1" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/queue/read_ahead_kb 256" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#interactive gov" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpufreq/interactive/target_loads 80" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpufreq/interactive/io_is_busy 1" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#gpu" >> $CONFIGFILE
echo "write /sys/class/kgsl/kgsl-3d0/devfreq/min_freq 100000000" >> $CONFIGFILE
echo "write /sys/class/kgsl/kgsl-3d0/devfreq/max_freq 465000000" >> $CONFIGFILE
echo "write /sys/class/kgsl/kgsl-3d0/max_gpuclk 465000000" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#disable core control and enable msm thermal" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 0" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/parameters/enabled Y" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#cpu-boost" >> $CONFIGFILE
echo "write /sys/module/cpu_boost/parameters/input_boost_freq \"0:800000 1:800000 2:800000 3:800000\"" >> $CONFIGFILE
echo "write /sys/module/cpu_boost/parameters/input_boost_ms 1000" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#set vibrator intensity" >> $CONFIGFILE
echo "write /sys/class/timed_output/vibrator/vtg_level 21" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "# VM tune up" >> $CONFIGFILE
echo "write /proc/sys/vm/min_free_kbytes 4096" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "# LMK Tune up" >> $CONFIGFILE
echo "write /sys/module/lowmemorykiller/parameters/minfree 2048,4096,8192,16384,24576,32768" >> $CONFIGFILE
