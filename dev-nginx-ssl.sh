#!/bin/bash

clear;

echo "install Nginx";
    if [ -d  /etc/nginx/  ]
    then
        echo "nginx sudah ada";
        nginx -t;
        git clone https://gitlab.com/roboticpuppies/ssl-certificate.git;
        mv ~/ssl-certificate /etc/nginx;
        mv ~/webserver/dev.conf /etc/nginx/conf.d;
        nginx -t;
        sudo systemctl reload nginx;
    else
        echo "Nginx belum ada";
        sudo apt install nginx -y;
        sudo systemctl enable nginx;
        git clone https://gitlab.com/roboticpuppies/ssl-certificate.git;
        mv ~/binar/ssl-certificate /etc/nginx;
        mv ~/webserver/dev.conf /etc/nginx/conf.d;
        nginx  -t;
        sudo systemctl reload nginx;
    fi
