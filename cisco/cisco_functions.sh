#!/bin/bash

# some usefull functions to get mac information from a cisco switch


formatmac()
{
        local result=""
        mac="$1"
        if [[ ${mac} == ??:??:??:??:??:?? ]]; then
                result=$(sed 's/\://;s/\:/./;s/\://;s/\:/./;s/\://' <<< ${mac})
        elif [[ ${mac} == ??-??-??-??-??-?? ]]; then
                result=$(sed 's/\-//;s/\-/./;s/\-//;s/\-/./;s/\-//' <<< ${mac})
        elif [[ ${mac} == ????.????.???? ]]; then
                result=$mac
        else
                result='That does not appear to be a mac address, try harder'
        fi
        echo $result

}
getmacdyn()
{

# param1 = hostname
# param2 = login
# param3 = password


rawmactable=""
rawmactable=$(sshpass -p $3 ssh $2@$1 "show mac address-table dynamic" grep "\S" | grep "Gi" | tail -n +5 |  grep "\S" out | grep "Gi" | tr -s " ")

IFS=$'\n'$'\r'
#echo "switch;vlan;mac;port;"
for LINE in $rawmactable; do
        IFS=" "
        FIELDS=( $LINE )
        result=""
        counter=0
        for field in $LINE; do
                if [ $field != "DYNAMIC" ]
                then
                        if [ $counter == 0 ]
                        then
                                result="$switch;$field"
                        else
                                result="$result;$field"
                        fi
                fi
                counter=$counter+1
        done
        echo $result
done
}
searchmacdyn()
{
# param1 = hostname
# param2 = login
# param3 = password
# param4 = mac address to search for

rawmactable=""
rawmactable=$(sshpass -p $3 ssh $2@$1 "show mac address-table dynamic" grep "\S" | grep "Gi" | tail -n +5 |  grep "\S" out | grep "Gi" | tr -s " ")

IFS=$'\n'$'\r'
#echo "switch;vlan;mac;port;"
for LINE in $rawmactable; do
        IFS=" "
        FIELDS=( $LINE )
        result=""
        counter=0
        for field in $LINE; do
                if [ $field != "DYNAMIC" ]
                then
                        if [ $counter == 0 ]
                        then
                                result="$switch;$field"
                        else
                                result="$result;$field"
                        fi
                fi
                counter=$counter+1
        done
        if [[ $result =~ $4 ]]
        then
                echo $result
        fi
done
}
