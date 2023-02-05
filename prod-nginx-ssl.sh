#!/bin/bash
clear;

echo "install Nginx";
    if [ -d  /etc/nginx/  ]
    then
        echo "nginx sudah ada";
        sudo nginx -t;
        sudo rm -rf /etc/nginx/conf.d/prod.conf /etc/nginx/ssl;
        sudo mkdir /etc/nginx/ssl;
        git clone https://gitlab.com/roboticpuppies/ssl-certificate.git;
        sudo mv ~/ssl-certificate/* /etc/nginx/ssl;
        sudo mv ~/webserver/prod.conf /etc/nginx/conf.d/;
        sudo nginx -t;
        sudo systemctl restart nginx;
    else
        echo "Nginx belum ada";
        sudo apt install nginx -y;
        sudo systemctl enable nginx;
        sudo mkdir /etc/nginx/ssl;
        git clone https://gitlab.com/roboticpuppies/ssl-certificate.git;
        sudo mv  ~/ssl-certificate/* /etc/nginx/ssl/;
        sudo mv  ~/webserver/prod.conf /etc/nginx/conf.d/;
        sudo nginx  -t;
        sudo systemctl restart nginx;
    fi
