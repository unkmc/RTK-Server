# Local RTK Server Setup
This document describes how to set up a local RTK server on a PC running `Windows 10` and using `VirtualBox 6.1.8`. Any deviations from that setup may result in procedural discrepancies.

***

## 1) Create a virtual machine
1. Download [Ubuntu Server 16.04 (32-bit)](https://releases.ubuntu.com/16.04/ubuntu-16.04.6-server-i386.iso)
2. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
   - This document is based on [VirtualBox 6.1.8](https://download.virtualbox.org/virtualbox/6.1.8/VirtualBox-6.1.8-137981-Win.exe)
3. Open `VirtualBox` and click the `New` button to create a new virtual machine (VM)
   - **Name:** RTK
   - **Machine Folder:** Your choice
   - **Type:** Linux
   - **Version:** Ubuntu (32-bit)
   - **Memory size:** Your choice
   - **Create a virtual hard disk now**
     - **VDI (VirtualBox Disk Image)**
     - **Dynamically allocated**
     - **File location:** Your choice
     - **File size:** Your choice
4. Double-click on your new VM to start it
5. On the `Select start-up disk` dialog, click the `Choose a virtual optical disk file...` button
   - Click the `Add` button and select the `Ubuntu Server 16.04` image that you downloaded in the first step
   - Click `Choose` and then `Start`
   - The VM will automatically boot into the `Ubuntu Server` setup

***

## 2) Install Ubuntu Server
1. Choose your preferred language and then select `Install Ubuntu Server`
2. Choose your language again, then your location, and then your keyboard layout
3. Enter `rtk` as the `Hostname`
4. Enter `gm` as the `Full name for the new user`
5. Enter `gm` again as the `Username for your account`
6. Enter and confirm any `password` of your choosing
7. Choose `<No>` when asked about encrypting your home directory
8. Confirm or adjust your time zone
9. Choose `Guided - use entire disk and set up LVM` for your `Partitioning method`
10. Select the virtual optical disk that you created earlier for `Select disk to partition` (should be the only option)
11. Choose `<Yes>` for `Write the changes to disks and configure LVM?`
12. Use the entire disk for `Amount of volume group to use for guided partitioning` (should be the default option)
13. Choose `<Yes>` for `Write the changes to disks?`
14. Leave `HTTP proxy information` blank
15. Choose `No automatic updates`
16. `<Continue>` with the default selections for `Choose software to install`
17. Choose `<Yes>` for `Install the GRUB boot loader`
18. `Finish the installation`:
    - The installation media should have been removed automatically
    - In the `VirtualBox` menu bar, if `Devices` &rarr; `Optical drives` &rarr; `Remove disk from virtual drive` is *not* grayed out, select it to manually remove the media
    - Choose `<Continue>`
    - After installation completes, the VM will automatically boot up and eventually prompt you for `rtk login:`

***

## 3) Install required packages

1. Login as `gm` using the password that you set during the previous setup
2. At the `gm@rtk:~$` prompt, enter `sudo apt update`
   - You will be asked for your password again since this is your first `sudo` command
3. Enter `sudo apt upgrade` and then `y` to confirm
4. Enter `sudo apt-get install build-essential make mysql-server libmysqlclient20 libmysqlclient-dev lua5.1 liblua5.1 liblua5.1-dev` and then `y` to confirm
   - Enter and confirm any password of your choosing for the `MySQL "root" user` when prompted
5. In the `VirtualBox` menu bar, select `Machine` &rarr; `ACPI Shutdown` to turn off your VM

***

## 4) Set up a shared folder for the RTK source
1. Use [this guide](https://gist.github.com/estorgio/0c76e29c0439e683caca694f338d4003) to set up a shared folder between your `Host` (i.e. Windows) and `Guest` (i.e. VM), but note the following caveats:
   - Ignore any discrepancies in the prerequisites; it will still work
   - Select the top-level folder of your copy of the RTK repository for the `Folder Path`
   - On the `Add Share` dialog, use `rtk` for the `Folder Name` instead of `shared`
   - The guide includes a few redundant commands; these are harmless, so just follow the instructions and ignore any console output about not being able to do something because it was already done
   - Be sure to use `rtk` instead of `shared` on any commands that reference the `Folder Name`
     - e.g. `sudo mount -t vboxsf rtk ~/shared`
     - e.g. `rtk    /home/gm/shared    vboxsf    defaults    0    0` (separated by tabs)
   - Ignore the `Bonus` section
2. In the `VirtualBox` menu bar, select `Machine` &rarr; `ACPI Shutdown` to turn off your VM

***

## 5) Add VM to host-only network
1. Open `VirtualBox`, select your VM, click the `Settings` button, and select the `Network` tab
   - Switch to the `Adapter 2` tab, select `Host-only Adapter` in the `Attached to` dropdown and click `OK`
2. Click the `Tools` button, and you should see an entry named `Virtual Box Host-Only Ethernet Adapter`
   - Ensure that the `Enable` checkbox under `DHCP Server` is checked
   - Make note of the IP address under `IPv4 Address/Mask`
3. Boot up your VM
4. After logging in, enter `ip addr`
   - Find the name of interface that does not have any sort of IP address listed (by default, this will be `enp0s8`)
5. Enter `sudo nano /etc/network/interfaces` and add the following lines to the end of the file:
   - `allow-hotplug enp0s8`
   - `iface enp0s8 inet dhcp`
6. Press `Ctrl` + `x`, then `y`, then `Enter` to save your changes
   - `VirtualBox` remaps the right `Ctrl` key by default, so use the left `Ctrl` key
7. Reboot your VM using `sudo shutdown -r now`
8. After logging back in, enter `ip addr | grep 'inet[^6]'`
   - One of the resulting lines should contain an IP address that matches the first three numbers of the IP address from step 5.2
   - This is the IP address that will be used to connect to your RTK server, so make note of it
   - If you don't see it in the results, try [Troubleshooting Common Issues](https://cs4118.github.io/dev-guides/host-only-network.html#troubleshooting-common-issues)

***

## 6) Update the IP address in the RTK source
1. In Windows, use any text editor to open the `/rtk/conf/map.conf` file from your copy of the RTK repository
2. Edit the values for `map_ip` and `loginip` to use the IP address obtained in step 5.8
   - e.g. `map_ip: 192.168.56.101`
   - e.g. `loginip: 192.168.56.101`
3. Save the file, and the update will automatically sync to your VM via the shared folder configured in step 4

***

## 7) Create the RTK database
1. Back on the VM, use the [mysql_config_editor](https://dev.mysql.com/doc/refman/5.7/en/mysql-config-editor.html) to set up an encrypted login path so that you can securely execute database migration scripts without manually entering your password:
   - `mysql_config_editor set --login-path=migrate --host=localhost --user=root --password`
   - When prompted for a password, enter the `root` MySQL password that you set in step 3.4
2. Now you can automatically create and configure the `RTK` database using database migration scripts:
   - `~/shared/database/migrate.sh`
   - Re-run this command any time a new script is added to the repository

***

## 8) Build and run the RTK server executables
1. Navigate to the `rtk` subfolder of your shared folder:
   - `cd ~/shared/rtk`
2. Build all servers:
   - `make all`
3. Start each server:
   - `./login-server &`
   - `./char-server &`
     - Wait for it to confirm connection to the login server
   - `./map-server &`
     - This one takes a while, but wait for it to confirm connection to the char server
4. The servers can be stopped using `./shutdown-mithia-servers` whenever you are finished or need to reboot them

_Note: You must rebuild the servers any time you make changes to the C code._

***

## 9) Configure the client
1. On Windows, press `Windows key` + `r` and enter `shell:programfilesx86`
2. Copy the included `/client/RetroTK` folder to the directory that was opened by the previous step
3. Create a shortcut to the copy of `RetroTK.exe` for your desktop or any other desired location
4. Run the included `/client/WHE.exe` with administrator privileges and create the following entry:
   - **Name of hosts to add:** tk0.retrotk.com
   - **IP address:** The IP address found in step 5.8
 5. Run `RetroTK.exe` to play

***

## 10) Create a GM
1. Create a character via the normal in-game process
2. Log out of the new character
3. On the server, login to MySQL and promote the new character to a GM:
   - `/usr/bin/mysql -u root -p`
   - `USE RTK;`
   - ``UPDATE `Character` SET `ChaGMLevel` = '99' WHERE `ChaName` = '[Your character's name goes here]';``
   - `exit`
4. Log back in

_Note: GM characters do not always cause the same in-game behavior as a normal character. For example, mobs may not spawn if the GM is in stealth mode (which it will be by default). So if you notice strange behavior, it might just be that you need to change the settings on your GM or use a non-GM character instead._

***

## 11) Restore item tooltips
You may have noticed that item tooltips are missing. Item meta data is loaded only once at login, so use a GM to reload that data, and then log out and back in. GM commands are performed by "speaking" them in-game like any other regular chat. The GM commands for this are:

- `/reloadItem`
- `/metan`

_Note: You must reload item meta data any time you make changes to items in the database._

***

## 12) Set up automated database backups

1. Set up another encrypted login path so that you can run `mysqldump` commands securely without manually entering your password:
   - `mysql_config_editor set --login-path=mysqldump --host=localhost --user=root --password`
   - When prompted, enter the password for your `root` MySQL user
2. Use [cron](https://en.wikipedia.org/wiki/Cron) to regularly execute a script that creates a full backup of your database:
   - `crontab -e`
   - Add the line `*/5 * * * * ~/shared/database/backup.sh` to the end of your crontab file
   - Save and exit
3. Cron will now automatically backup your entire database to `/database/history/` every 5 minutes
   - You may change the schedule by editing the [cron expression](https://crontab.guru/)
   - `backup.sh` keeps the latest 72 backups (i.e. six hours) by default

_Note: This only backs up the database to your VM server (and your Windows PC via the shared folder). You would still lose everything if you lost your PC, so consider also using a cloud service (e.g. Dropbox) or some other backup method for the `mysqldump` files._

***

## 13) Manage MySQL database from Host
If you want to use database management software to connect to the MySQL database on your VM server from Windows (as opposed to always using the Ubuntu terminal as in step 10.3), perform the following steps:

1. On your VM, allow remote connections to MySQL from any IP address:
   - `sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf`
   - Comment out the line that starts with `bind-address` (i.e. add a `#` at the start of that line)
   - `Ctrl` + `x`, then `y`, then `Enter` to save your changes
2. Log into MySQL:
   - `/usr/bin/mysql -u root -p` 
3. Create a root user that can login from your Host PC:
   - `CREATE USER 'root'@'192.168.56.1' IDENTIFIED BY '[any password of your choosing]'`;
   - `GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.56.1';`
   - `FLUSH PRIVILEGES;`
4. Now on Windows, download and install the database management software of your choosing
   - [Navicat](https://www.navicat.com/en/products/navicat-for-mysql) is the one I see recommended most often, but it's like $300 for a license
   - [DBeaver]() is great free alternative, but the UI is less intuitive and might be confusing for inexperienced users
   - [Table Plus](https://tableplus.com/windows) is another free option that is more limited but might therefore be less intimidating
5. Open your database manager and connect to the database using the IP address of your VM. This will look different depending on which software you installed, but here are the main things you are likely to need to know:
   - **Host/Socket:** The IP address of your VM (e.g. `192.168.56.101`)
   - **Port:** 3306
   - **User:** root
   - **Password:** MySQL `root` password from step 3.4
   - **Database:** RTK

***

## Tips

- Use `Shift` + `PgUp` and `PgDown` to scroll up and down in the Ubuntu Server terminal
- [MySQL Cheat Sheet](https://gist.github.com/bradtraversy/c831baaad44343cc945e76c2e30927b3)
