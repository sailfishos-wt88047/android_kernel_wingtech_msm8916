#!/sbin/sh

#Build config file
CONFIGFILE="/tmp/init.excalibur.rc"

echo "on boot" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#S2W" >> $CONFIGFILE
SR=`grep "item.1.1" /tmp/aroma/gest.prop | cut -d '=' -f2`
SL=`grep "item.1.2" /tmp/aroma/gest.prop | cut -d '=' -f2`
SU=`grep "item.1.3" /tmp/aroma/gest.prop | cut -d '=' -f2`
SD=`grep "item.1.4" /tmp/aroma/gest.prop | cut -d '=' -f2`

if [ $SL = 1 ]; then
  SL=2
fi
if [ $SU == 1 ]; then
  SU=4
fi
if [ $SD == 1 ]; then
  SD=8
fi  

S2W=$(( SL + SR + SU + SD ))
echo "write /sys/android_touch/sweep2wake " $S2W >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#DT2W" >> $CONFIGFILE
DT2W=`grep "item.1.5" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo "write /sys/android_touch/doubletap2wake " $DT2W >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#S2S" >> $CONFIGFILE
S2S=`grep selected.0 /tmp/aroma/s2s.prop | cut -d '=' -f2`
if [ $S2S = 2 ]; then
  echo "write /sys/android_touch/sweep2sleep 1" >> $CONFIGFILE
elif [ $S2S = 3 ]; then
  echo "write /sys/android_touch/sweep2sleep 2" >> $CONFIGFILE
elif [ $S2S = 4 ]; then
  echo "write /sys/android_touch/sweep2sleep 3" >> $CONFIGFILE
else
  echo "write /sys/android_touch/sweep2sleep 0" >> $CONFIGFILE
fi

echo "" >> $CONFIGFILE
echo "on property:sys.boot_completed=1" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#set I/O scheduler" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/queue/rq_affinity 1" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#max freq" >> $CONFIGFILE
echo "chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" >> $CONFIGFILE
echo "chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" >> $CONFIGFILE
cpu0=`grep selected.2 /tmp/aroma/cpu0.prop | cut -d '=' -f2`
if [ $cpu0 = 1 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1401600" >> $CONFIGFILE
elif [ $cpu0 = 2 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1363200" >> $CONFIGFILE
elif [ $cpu0 = 3 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1209600" >> $CONFIGFILE
elif [ $cpu0 = 4 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1152000" >> $CONFIGFILE
else
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1094400" >> $CONFIGFILE
fi

echo "" >> $CONFIGFILE

echo "#set cpu governor" >> $CONFIGFILE
echo "chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" >> $CONFIGFILE
echo "chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" >> $CONFIGFILE
gov=`grep selected.0 /tmp/aroma/gov.prop | cut -d '=' -f2`
if [ $gov = 1 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor bioshock" >> $CONFIGFILE
elif [ $gov = 2 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor conservative" >> $CONFIGFILE
elif [ $gov = 3 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor impulse" >> $CONFIGFILE
elif [ $gov = 4 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor interactive" >> $CONFIGFILE
elif [ $gov = 5 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor lionfish" >> $CONFIGFILE
elif [ $gov = 6 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ondemand" >> $CONFIGFILE
elif [ $gov = 7 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor performance" >> $CONFIGFILE
elif [ $gov = 8 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor powersave" >> $CONFIGFILE
else
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor userspace" >> $CONFIGFILE
fi

echo "" >> $CONFIGFILE
echo "#read ahead buffer size" >> $CONFIGFILE
SCHED=`grep selected.2 /tmp/aroma/sched.prop | cut -d '=' -f2`
if [ $SCHED = 1 ]; then
echo "write /sys/block/mmcblk0/queue/read_ahead_kb 128" >> $CONFIGFILE
elif [ $SCHED = 2 ]; then
echo "write /sys/block/mmcblk0/queue/read_ahead_kb 256" >> $CONFIGFILE
elif [ $SCHED = 3 ]; then
echo "write /sys/block/mmcblk0/queue/read_ahead_kb 512" >> $CONFIGFILE
else
echo "write /sys/block/mmcblk0/queue/read_ahead_kb 768" >> $CONFIGFILE
fi

echo "" >> $CONFIGFILE

echo "#interactive gov" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpufreq/interactive/target_loads 80" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpufreq/interactive/io_is_busy 1" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#GPU" >> $CONFIGFILE
gpu=`grep selected.1 /tmp/aroma/gpu.prop | cut -d '=' -f2`
if [ $gpu = 1 ]; then
echo "write /sys/class/kgsl/kgsl-3d0/devfreq/min_freq 100000000" >> $CONFIGFILE
else
echo "write /sys/class/kgsl/kgsl-3d0/devfreq/min_freq 200000000" >> $CONFIGFILE
fi
gpu=`grep selected.2 /tmp/aroma/gpu.prop | cut -d '=' -f2`
if [ $gpu = 1 ]; then
echo "write /sys/class/kgsl/kgsl-3d0/devfreq/max_freq 465000000" >> $CONFIGFILE
echo "write /sys/class/kgsl/kgsl-3d0/max_gpuclk 465000000" >> $CONFIGFILE
else
echo "write /sys/class/kgsl/kgsl-3d0/devfreq/max_freq 400000000" >> $CONFIGFILE
echo "write /sys/class/kgsl/kgsl-3d0/max_gpuclk 400000000" >> $CONFIGFILE
fi

gpu=`grep selected.3 /tmp/aroma/gpu.prop | cut -d '=' -f2`
if [ $gpu = 1 ]; then
echo "write /sys/module/adreno_idler/parameters/adreno_idler_active Y" >> $CONFIGFILE
else
echo "write /sys/module/adreno_idler/parameters/adreno_idler_active N" >> $CONFIGFILE
fi

echo "" >> $CONFIGFILE

echo "#KCAL " >> $CONFIGFILE
misc=`grep selected.1 /tmp/aroma/misc.prop | cut -d '=' -f2`
if [ $misc = 2 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"217 215 255"\" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 265" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 253" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 250" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_hue 0" >> $CONFIGFILE
elif [ $misc = 3 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"223 223 255"\" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 271" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_hue 0" >> $CONFIGFILE
elif [ $misc = 4 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"232 237 256"\" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 300" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_hue 0" >> $CONFIGFILE
elif [ $misc = 5 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"230 232 255"\" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 274" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 247" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 268" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_hue 0" >> $CONFIGFILE
elif [ $misc = 6 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"232 228 255"\" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 251" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 254" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 256" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_hue 1515" >> $CONFIGFILE
else
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"256 256 256"\" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 255" >> $CONFIGFILE
fi

echo "" >> $CONFIGFILE

echo "#Custom Vibrator intensity " >> $CONFIGFILE
misc2=`grep selected.0 /tmp/aroma/misc2.prop | cut -d '=' -f2`
if [ $misc2 = 1 ]; then
echo "write /sys/class/timed_output/vibrator/vtg_level 14" >> $CONFIGFILE
elif [ $misc2 = 2 ]; then
echo "write /sys/class/timed_output/vibrator/vtg_level 18" >> $CONFIGFILE
elif [ $misc2 = 3 ]; then
echo "write /sys/class/timed_output/vibrator/vtg_level 21" >> $CONFIGFILE
else
echo "write /sys/class/timed_output/vibrator/vtg_level 27" >> $CONFIGFILE
fi

echo "" >> $CONFIGFILE

echo "#disable core control and enable msm thermal" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 0" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/parameters/enabled Y" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#cpu-boost" >> $CONFIGFILE
echo "write /sys/module/cpu_boost/parameters/input_boost_freq \"0:800000 1:800000 2:800000 3:800000\"" >> $CONFIGFILE
echo "write /sys/module/cpu_boost/parameters/input_boost_ms 1000" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "# VM tune up" >> $CONFIGFILE
echo "write /proc/sys/vm/min_free_kbytes 4096" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "# LMK Tune up" >> $CONFIGFILE
echo "write /sys/module/lowmemorykiller/parameters/minfree 2048,4096,8192,16384,24576,32768" >> $CONFIGFILE
