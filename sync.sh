#!/bin/bash
trap 'cp /jd-scripts-docker/sync.sh /sync' Exit
if [ -d /jd-scripts-docker ];then
	git -C /jd-scripts-docker pull
else
	git clone --depth=1 https://github.com/jk9527/jd-scripts-docker.git /jd-scripts-docker_tmp
	[ -d /jd-scripts-docker_tmp ] && {
		  rm -rf /jd-scripts-docker
	  mv /jd-scripts-docker_tmp /jd-scripts-docker
  }
fi


if [ -d /scripts ];then
	git -C /scripts reset --hard
	git -C /scripts pull
else
	git clone -b my_master --depth=1 https://gitee.com/jk9527/jd_scripts.git /scripts_tmp
	[ -d /scripts_tmp ] && {
		  rm -rf /scripts
	  mv /scripts_tmp /scripts
  }
fi


cd /scripts || exit 1

npm install || npm install --registry=https://registry.npm.taobao.org || exit 1
cp /crontab.list /crontab.list.old
cp /jd-scripts-docker/crontab.list /crontab.list
crontab -r
crontab /crontab.list || {
	  cp /crontab.list.old /crontab.list
  crontab /crontab.list
}
crontab -l
