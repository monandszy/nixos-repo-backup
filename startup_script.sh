#!/run/current-system/sw/bin/bash

LOCAL_REPO_DIR=/home/git/srv/services/project-base
LOG_FILE=/home/git/srv/startup.log
cd $LOCAL_REPO_DIR
bash docker/tunnel/clean_ports.sh
git switch master >> $LOG_FILE 2>&1
git reset --hard origin/master >> $LOG_FILE 2>&1
git pull origin master -v -f >> $LOG_FILE 2>&1
gradle composeProdUp -Pforce=false >> $LOG_FILE 2>&1
bash docker/tunnel/run_tunnel.sh  &
sleep 10 & pid=$!
kill $pid

git switch dev >> $LOG_FILE 2>&1
git reset --hard origin/dev >> $LOG_FILE 2>&1
git pull origin dev -v -f >> $LOG_FILE 2>&1
gradle composeDevUp -Pforce=false >> $LOG_FILE 2>&1
