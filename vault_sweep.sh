#!/bin/bash

for file in $(find . -name "*.sh")
do
    echo "Checking: $file"

    if grep -q "rm -rf" "$file" || grep -q "shutdown" "$file" || grep -q "reboot" "$file"
    then
        echo "[WARN] $file contains dangerous command" >> scan.log
    fi 

    perm=$(stat -c "%a" "$file")

    if [ "$perm" = "777" ]
    then 
        echo "[WARN] $file has dangerous permission: $perm " >> scan.log
        read -p "Fix permission for $file? (y/n): " choice 
    

        if [ "$choice" = "y" ]
        then 
            chmod 755 "$file"
            echo "Permission fixed for $file" 
        fi
    fi
done
> .env.sanitized
while read line 
do 
if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*=.*$ ]]
then
    echo "$line" >> .env.sanitized
fi 
done < bad.env

for execfile in $(find . -type f -executable)
do 
    if [[ "$execfile" != *.sh ]]
    then 
        echo "[WARN] Suspicious executable found: $execfile"

    fi
done