#!/system/bin/sh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Originally Coded by Tkkg1994 @GrifoDev, BlackMesa @XDAdevelopers
# Reworked by Ananjaser1211 & corsicanu @XDAdevelopers with some code from 6h0st@ghost.com.ro
#

RUN=/sbin/busybox;
LOGFILE=/data/helios/config.log
GPU="/sys/devices/14ac0000.mali"
CPU="/sys/devices/system/cpu"

log_print() {
  echo "$1"
  echo "$1" >> $LOGFILE
}
log_print "------------------------------------------------------"
log_print "**helios Configurator script started at $( date +"%d-%m-%Y %H:%M:%S" )**"

# Execute mods
log_print "**Execute $GPU adjustments**"
log_print "**Apply AlwaysON**"
echo 'always_on' > $GPU/power_policy
#log_print "**Apply Custom voltage**"
#echo '266 643750' > $GPU/volt_table
#echo '350 650000' > $GPU/volt_table
#echo '420 656250' > $GPU/volt_table
#echo '544 700000' > $GPU/volt_table
#echo '600 731250' > $GPU/volt_table
#echo '700 775000' > $GPU/volt_table
#echo '772 812500' > $GPU/volt_table
log_print "**Apply 600 max freq**"
echo '600' > sys/kernel/gpu/gpu_max_clock
log_print "**Execute $CPU adjustments**"
log_print "**Apply 400mHz min freq**"
echo '400000' > $CPU/cpu0/cpufreq/scaling_min_freq
echo '400000' > $CPU/cpu1/cpufreq/scaling_min_freq
echo '400000' > $CPU/cpu2/cpufreq/scaling_min_freq
echo '400000' > $CPU/cpu3/cpufreq/scaling_min_freq
echo '400000' > $CPU/cpu4/cpufreq/scaling_min_freq
echo '400000' > $CPU/cpu5/cpufreq/scaling_min_freq
echo '400000' > $CPU/cpu6/cpufreq/scaling_min_freq
echo '400000' > $CPU/cpu7/cpufreq/scaling_min_freq
log_print "**Apply 1.9gHz max freq**"
echo '1896000' > $CPU/cpu4/cpufreq/scaling_max_freq
echo '1896000' > $CPU/cpu5/cpufreq/scaling_max_freq
echo '1896000' > $CPU/cpu6/cpufreq/scaling_max_freq
echo '1896000' > $CPU/cpu7/cpufreq/scaling_max_freq

# Exit
   log_print "**helios Configurator script finished at $( date +"%d-%m-%Y %H:%M:%S" )**"
   log_print "------------------------------------------------------"
