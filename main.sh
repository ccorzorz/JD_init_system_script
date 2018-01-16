#/bin/sh

set -x 
cd /root/script
/root/script/auto_disk.sh
/root/script/init.sh
/root/script/tomcat_install.sh 1.6 6
sleep 2
/root/script/nginx_install.sh
chown -R admin:admin /export
sed -i '/main.sh/d' /etc/rc.local
rm -rf /root/script