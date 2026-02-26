#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_DIR="reports"
REPORT_FILE="$REPORT_DIR/health_$TIMESTAMP.log"

mkdir -p $REPORT_DIR

echo "===================================" >> $REPORT_FILE
echo " SERVER HEALTH REPORT " >> $REPORT_FILE
echo " Generated at: $(date)" >> $REPORT_FILE
echo "===================================" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "---- UPTIME ----" >> $REPORT_FILE
uptime >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "---- MEMORY ----" >> $REPORT_FILE
free -m >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "---- DISK ----" >> $REPORT_FILE
df -h >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "---- DISK ALERT CHECK ----" >> $REPORT_FILE

df -h | awk 'NR>1 {print $5 " " $1}' | while read output;
do
  usage=$(echo $output | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')

  if [ $usage -ge 80 ]; then
    echo "WARNING: Disk usage on $partition is ${usage}%" >> $REPORT_FILE
  fi
done

echo "" >> $REPORT_FILE
echo "Health check completed." >> $REPORT_FILE

echo "Report saved at $REPORT_FILE"