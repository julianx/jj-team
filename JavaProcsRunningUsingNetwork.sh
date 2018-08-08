#!/bin/bash
#
# --numeric --numeric-hosts --numeric-ports
case $1 in
   ip)
      for i in $(netstat -utnlp | awk '/java/ {print substr($7, 1, length($7)-5)}' | sort -u)
      do
         ps -eo pid,user,command --cols 70 | grep $i | grep -v grep ; netstat -utlp --numeric --numeric-hosts --numeric-ports| grep $i
         echo
      done
      ;;
   host)
      for i in $(netstat -utlp | awk '/java/ {print substr($7, 1, length($7)-5)}' | sort -u)
      do
         ps -eo pid,user,command --cols 70 | grep $i | grep -v grep ; netstat -utlp | grep $i
         echo
      done
      ;;
   ambari)
      for i in $(netstat -utnlp | egrep 'java|python' | awk '{print substr($7, 1, length($7)-5)}' | sort -u)
      do
         ps -eo pid,user,command --cols 70 | grep $i | grep -v grep ; netstat -utnlp | grep $i
         echo
      done
      ;;
   *)
      echo "USAGE: ${0} with 'host | ip | ambari' arguments"
      exit 1
      ;;
esac
echo "=============================================================================================================="
















