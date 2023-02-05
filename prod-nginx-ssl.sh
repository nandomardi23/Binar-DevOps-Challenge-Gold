#!/bin/bash
clear;

echo "install Nginx";
    if [ -d  /etc/nginx/  ]
    then
        echo "nginx sudah ada";
        sudo nginx -t;
        sudo mkdir /etc/nginx/ssl;
        git clone https://gitlab.com/roboticpuppies/ssl-certificate.git;
        mv ~/ssl-certificate/* /etc/nginx/ssl;
        mv ~/webserver/prod.conf /etc/nginx/conf.d/;
        sudo nginx -t;
        sudo systemctl reload nginx;
    else
        echo "Nginx belum ada";
        sudo apt install nginx -y;
        sudo systemctl enable nginx;
        sudo mkdir /etc/nginx/ssl;
        git clone https://gitlab.com/roboticpuppies/ssl-certificate.git;
        mv  ~/ssl-certificate/* /etc/nginx/ssl/;
        mv  ~/webserver/prod.conf /etc/nginx/conf.d/;
        sudo nginx  -t;
        sudo systemctl reload nginx;
    fi
