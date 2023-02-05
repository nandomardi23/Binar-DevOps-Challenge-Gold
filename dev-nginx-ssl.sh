#!/bin/bash

clear;

echo "install Nginx";
    if [ -d  /etc/nginx/  ]
    then
        echo "nginx sudah ada";
        sudo nginx -t;
        git clone https://gitlab.com/roboticpuppies/ssl-certificate.git;
        sudo mkdir /etc/nginx/ssl
        sudo mv ssl-certificate/* /etc/nginx/ssl/;
        sudo mv webserver/dev.conf /etc/nginx/conf.d;
        sudo nginx -t;
        sudo systemctl reload nginx;
    else
        echo "Nginx belum ada";
        sudo apt install nginx -y;
        sudo systemctl enable nginx;
        git clone https://gitlab.com/roboticpuppies/ssl-certificate.git;
        sudo mv ssl-certificate/* /etc/nginx/ssl/;
        sudo mv webserver/dev.conf /etc/nginx/conf.d;
        sudo nginx  -t;
        sudo systemctl reload nginx;
    fi
