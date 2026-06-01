#!/bin/bash

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

for file in $(find . -name "*.sh")
do

    if [ "$file" = "./vault_sweep.sh" ]
    then
        continue
    fi

    echo "Checking: $file"

    if grep -q "rm -rf" "$file" || grep -q "shutdown" "$file" || grep -q "reboot" "$file"
    then
        echo "[$(timestamp)] [WARN] $file - Reason: Dangerous command detected" >> scan.log
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
            echo "[$(timestamp)] [FIX] $file removed world write permission" >> scan.log
        fi
    fi
done
> .env.sanitized

valid=0
invalid=0

while read line
do
if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*=.*$ ]] &&
[[ ! "$line" =~ ^(PASSWORD|TOKEN|SECRET)= ]] &&
[[ ! "$line" =~ ^PATH= ]] &&
[[ ! "$line" =~ ^export[[:space:]]+PATH ]]
then
echo "$line" >> .env.sanitized
valid=$((valid+1))
else
invalid=$((invalid+1))
fi

done < test_files/bad.env

echo "[INFO] bad.env Valid: $valid, Invalid: $invalid" >> scan.log


for execfile in $(find . -path ./.git -prune -o -type f -executable -print)
do 
    if [[ "$execfile" != *.sh ]]
    then 
        echo "[WARN] Suspicious executable found: $execfile"
        echo "[$(timestamp)] [WARN] $execfile - Reason: Suspicious executable detected" >> scan.log
        author=$(git log -1 --pretty=format:"%an" "$execfile")
        echo "Last modified by: $author"
        echo "[$(timestamp)] [INFO] $execfile Author: $author" >> scan.log

    fi
done