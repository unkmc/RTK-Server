#!/bin/bash
for script in scripts/*.sql; do
	echo Executing $script...
	mysql --login-path=migrate < $script
done
