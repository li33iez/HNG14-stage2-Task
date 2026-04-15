#!/bin/bash

set -e

APPDIR="app.py"
LOGFILE="deploy.log"
RR="requirements.txt"

log(){
 echo " $(date +"%Y%m%d_%H%M%S") - $1"  | tee  -a $LOGFILE
}


log "check python version" python --version
log "updating  apt packages" sudo apt update


if ! command -v python3 > /dev/null
then
	sudo apt install python3 python3-pip -y
	log "installing python3"
fi




log "creating virtual environment"

sudo apt update > /dev/null 2>&1
sudo apt install python3 python3-pip python3-venv -y > /dev/null 2>&1
log "installing python3"


python3 -m venv venv > /dev/null 2>&1
source venv/bin/activate

log  "activating venv"




log "installing dependencies"

pip install --upgrade pip >/dev/null 2>&1
log "updating pip"
echo ""
echo ""

pip install -r $RR  >/dev/null 2>&1 
log "installing from requirements.txt"
log "installing gunicorn"



log "====================== starting flask app ======================"

nohup gunicorn -w 2 -b 127.0.0.1:8000 app:appi > gunicorn.log 2>&1 &


echo ""
echo "==================================================================="
log " CONFIGURATION OF NGINX  AS A REVERSE PROXY"

if ! command -v nginx  > /dev/null
then
	sudo apt install nginx -y > /dev/null 2>&1
	log " nginx not found, now installing nginx"
fi


sudo systemctl start nginx && sudo systemctl enable nginx
log "start and enable nginx"


sudo cp  flaskapi /etc/nginx/sites-available/flask
sudo ln -s /etc/nginx/sites-available/flask /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

echo ""
echo ""
echo "===================================================================="

sudo nginx -t  >> $LOGFILE
sudo nginx -s reload $LOGFILE


log "TESTING NGINX CONFIG"
 
