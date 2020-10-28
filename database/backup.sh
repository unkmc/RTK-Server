#!/bin/bash
dir=~/shared/database/history
file=$dir/$(date +%Y-%m-%d-%H-%M-%S)_RTK.sql

mysqldump --opt --add-drop-database --databases RTK > $file
chmod 444 $file

for oldBackup in $(ls -d -1tr $dir/*.sql | head -n -72); do
	chmod 744 $oldBackup
	rm -f $oldBackup
done
