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
LOGFILE=/data/helios/wifiloader.log


log_print() {
  echo "$1"
  echo "$1" >> $LOGFILE
}
log_print "------------------------------------------------------"
log_print "**helios WifiLoader script started at $( date +"%d-%m-%Y %H:%M:%S" )**"

# Execute deferred_initcalls
cat /proc/deferred_initcalls

# Exit
   log_print "**helios WifiLoader script finished at $( date +"%d-%m-%Y %H:%M:%S" )**"
   log_print "------------------------------------------------------"
