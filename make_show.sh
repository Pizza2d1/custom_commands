if [[ $1 == "y" ]]; then
    WriteLocation=show
    chmod +x ./show
else
    WriteLocation=show_storage.sh
fi

echo > $WriteLocation

echo -e "LIST OF DRIVES:\n$(df)\n"
## DRIVE 1 ##
read -p "What is the name off your first drive? (format as /dev/sdX ): " DRIVE1
if [[ $DRIVE1 == *"/dev/"* ]]; then
    echo "
DRIVE1=$DRIVE1
used_storage1=\$(df \$DRIVE1 | grep -h 2 | awk '\$DRIVE1 {print \$3}')
total_storage1=\$(df \$DRIVE1 | grep -h 2 | awk '\$DRIVE1 {print \$2}')
free_storage1=\$((\$total_storage1-\$used_storage1))
" >> $WriteLocation
    echo "Added $DRIVE1"
    if [ $? -ne 0 ]; then
        echo "Invalid Input, exiting"
        exit;
    fi
else
    echo -e "
#No drive was entered for this number\n
used_storage1=0
total_storage1=0
free_storage1=0
" >> $WriteLocation
fi

## DRIVE 2 ##
read -p "What is the name off your second drive? (format as /dev/sdX ): " DRIVE2
if [[ $DRIVE2 == *"/dev/"* ]]; then
    echo "
DRIVE2=$DRIVE2
used_storage2=\$(df \$DRIVE2 | grep -h 2 | awk '\$DRIVE2 {print \$3}')
total_storage2=\$(df \$DRIVE2 | grep -h 2 | awk '\$DRIVE2 {print \$2}')
free_storage2=\$((\$total_storage1-\$used_storage2))
" >> $WriteLocation
    echo "Added $DRIVE2"
    if [ $? -ne 0 ]; then
        echo "Invalid Input, exiting"
        exit;
    fi
else
    echo -e "
#No drive was entered for this number\n
used_storage2=0
total_storage2=0
free_storage2=0
" >> $WriteLocation
fi

## DRIVE 3 ##
read -p "What is the name off your third drive? (format as /dev/sdX ): " DRIVE3
if [[ $DRIVE3 == *"/dev/"* ]]; then
    echo "
DRIVE3=$DRIVE3
used_storage3=\$(df \$DRIVE3 | grep -h 2 | awk '\$DRIVE3 {print \$3}')
total_storage3=\$(df \$DRIVE3 | grep -h 2 | awk '\$DRIVE3 {print \$2}')
free_storage3=\$((\$total_storage1-\$used_storage3))
" >> $WriteLocation
    echo "Added $DRIVE3"
    if [ $? -ne 0 ]; then
        echo "Invalid Input, exiting"
        exit;
    fi
else
    echo -e "
#No drive was entered for this number\n
used_storage3=0
total_storage3=0
free_storage3=0
" >> $WriteLocation
fi

## TOTALS ##
echo '
TOTAL_USED_STORAGE=$(($used_storage1+$used_storage2+$used_storage3))
TOTAL_STORAGE=$(($total_storage1+$total_storage2+$total_storage3))
TOTAL_FREE_STORAGE=$(($free_storage1+$free_storage2+$free_storage3))
' >> $WriteLocation


## ADD FUNCTIONS ##
echo '
function showStorage(){
    # Percent-wise how full the drives are
    perc1=$(echo "scale=3; $used_storage1 / $total_storage1 * 100" | bc)
    perc2=$(echo "scale=3; $used_storage2 / $total_storage2 * 100" | bc)
    perc3=$(echo "scale=3; $used_storage3 / $total_storage3 * 100" | bc)
    PERC=$(echo "scale=3; $TOTAL_USED_STORAGE / $TOTAL_STORAGE * 100" | bc)
    ## Better readable percentage
    percent_storage1=$(echo "${perc1:0:4}%")
    percent_storage2=$(echo "${perc2:0:4}%")
    percent_storage3=$(echo "${perc3:0:4}%")
    TOTAL_PERCENT=$(echo "${PERC:0:4}%")

    echo -e "\n\n"

    figlet "TOTAL STORAGE:"
    echo -e "$(($TOTAL_USED_STORAGE/1000000))/$(($TOTAL_STORAGE/1000000)) GB  $TOTAL_PERCENT\n"
    figlet "FREE STORAGE"
    echo -e "$(($TOTAL_FREE_STORAGE/1000000)) GB\n"

    echo -e "\nDrive 1"
    echo -e "Storage Space Used: $(($used_storage1/1000000))/$(($total_storage1/1000000)) GB ($percent_storage1)"
    echo -e "Usable Storage: $(($free_storage1/1000000)) GB\n\n"
    echo -e "\nDrive 2"
    echo -e "Storage Space Used: $(($used_storage2/1000000))/$(($total_storage2/1000000)) GB ($percent_storage2)"
    echo -e "Usable Storage: $(($free_storage2/1000000)) GB\n\n"
    echo -e "\nDrive 3"
    echo -e "Storage Space Used: $(($used_storage3/1000000))/$(($total_storage3/1000000)) GB ($percent_storage3)"
    echo -e "Usable Storage: $(($free_storage3/1000000)) GB\n\n"
}' >> $WriteLocation

echo "
function showStatus(){
    RED='\033[1;31m'
    YELLOW='\033[1;33m'
    GREEN='\033[1;32m'
    ActiveReturnLine=\$(systemctl status smbd | grep "Active")     #Gets the status of the samba service (smbd) and collects only the line of data that includes whether the service is active or not
    case \$ActiveReturnLine in                                     #Will display different outputs based on whether or not the service is active
      *inactive*)
        printf \${RED}
        echo -e '\\nINACTIVE\\n'
        exit;;
      *active*)
        printf \${GREEN}
        echo -e '\\nACTIVE\\n'
        exit;;
      *deactivating*)
        printf \${YELLOW}
        echo -e '\\nDEACTIVATING\\n'
        exit;;
      *activating*)
        printf \${YELLOW}
        echo -e '\\nACTIVATING\\n'
        exit;;
      *failed*)
        printf \${RED}
        echo -e '\\nFAILED\\n'
        exit;;
    esac
}" >> $WriteLocation

## OTHER STUFF ##
echo "
case \"\$1\" in
    storage)    #Will display the current storage of the system, includes all drives)
    showStorage
      exit;;
    
    status)
      showStatus
      exit;;
    
    help)
      echo -e \"Options:\n\n$WriteLocation storage\n$WriteLocation status\n$WriteLocation help\n\"
      exit;;
    
esac" >> $WriteLocation

echo '
# echo "TOTAL STORAGE: $TOTAL_STORAGE"
# echo "$(($TOTAL_USED_STORAGE/1000000))/$(($TOTAL_STORAGE/1000000)) GB"
echo "TOTAL STORAGE: $total_storage1"
echo "$(($used_storage1/1000000))/$(($total_storage1/1000000)) GB"
echo "Available Storage: $free_storage1"' >> $WriteLocation




# ## TESTING ##
# echo '
# echo $TOTAL_USED_STORAGE
# echo $TOTAL_STORAGE
# echo $TOTAL_FREE_STORAGE
# ' >> $WriteLocation
