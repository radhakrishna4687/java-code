#!/bin/bash

isExistApp=`pgrep java`
if [[ -n $isExitApp ]]; then 
    service tomcat8 stop 
fi    