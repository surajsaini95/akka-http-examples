#!/bin/bash
#
# SCRIPT: deploy.sh
# AUTHOR: Suraj Saini
# DATE:   20-Apr-2020
# REV:    1.1.A (Valid are A, B, D, T and P)
#          (For Alpha, Beta, Dev, Test and Production)
#
#
# PLATFORM: Specify which os you have written it for
# 
# PURPOSE: Deploy the application on server.
# REV LIST:
#    DATE        : Date of revision
#    BY          : AUTHOR OF MODIFICATION
#    MODIFICATION: Describe the chages made. What do they enhance.
# 
# set -n   # Uncomment to check script syntax, without execution.
#          # NOTE: Do forget comment it back as it won't allow the 
#          # the script to execute.
#
# set +x   # Uncomment this for debugging this shell script.
#
#
################################################################
#          Define Files and Variables here                     #
################################################################
################################################################
#          Define Functions here                               #
################################################################
################################################################
#          Beginning of Main                                   #
nohup java -jar target/scala-2.11/akka-http-helloworld-assembly-1.0.jar &
################################################################
# End of script
