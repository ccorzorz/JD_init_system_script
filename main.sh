#/bin/sh

set -x 
cd /root/script
/root/script/auto_disk.sh
/root/script/init.sh
/root/script/tomcat_install.sh 1.6 7
#yes|cp 1.6CE/*.jar /export/servers/jdk/jre/lib/security
sleep 2
/root/script/nginx_install.sh
yum install -y unzip&&wget http://pocteam-obj.oss.cn-north-1.jcloudcs.com/sps-agent-flume.zip && unzip -d /export/servers/sps-agent-flume sps-agent-flume.zip && rm -f sps-agent-flume.zip
chown -R admin:admin /export
wget devops.oss.cn-south-1.jcloudcs.com/ifrit/ifrit-agent-installer-v0.01.348.4440aa4.20171205134020.bin -O installer && sh installer /export/servers/ifrit znkf && rm -f installer
sed -i '/main.sh/d' /etc/rc.local
rm -rf /root/script