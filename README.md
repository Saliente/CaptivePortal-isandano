# CaptivePortal-isandano
Easy way to install isandano on RHEL Linux Based (CentOS, Rocky, Alma, Oracle)

# How to install

Due to systemd files, it's necessary to run as root
```
sudo su
```
Download the shell file using cURL
```
curl -O https://raw.githubusercontent.com/Saliente/CaptivePortal-isandano/main/captiveportal.sh
```
Make the shell file executable
```
dos2unix ./captiveportal.sh
```
Now just execute the file 
```
sh ./captiveportal.sh
```
