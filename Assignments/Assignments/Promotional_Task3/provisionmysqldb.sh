#!/bin/bash

sudo apt-get update

MYSQL_ROOT_PASSWORD=princessa2

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

sudo apt-get install -y mysql-server
