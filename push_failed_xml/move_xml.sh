#!/bin/bash
#
# This script helps TE to push XML (5 each time - You can modify this value in MOVE_AMOUNT) from a 
# Failed XML folder to /dfcxact/mediabuild/UNIT_DATA_OUT_MX/
#
# Execute this program as root on L2 Server
# Script by: Jesus Rueda - MTY Local TE
#


#######CAMBIO SOBRE BRANCH"

XML_PATH="/dfcxact/workarea/JesusRueda/scripts/push_failed_xml/failed_xml_dir"
FAILED_MT="1S7X56"
MOVE_AMOUNT="5"
MIN_AMOUNT="2"

function refresh_count
{
count_var=$(ls -1 /dfcxact/mediabuild/UNIT_DATA_OUT_MX/${FAILED_MT}* 2> /dev/null|wc -l); 
}

function main
{
refresh_count;
while [[  ${count_var} -ne 0 ]] ; 
do 
    if [[ ${count_var} <= ${MIN_AMOUNT} ]]; 
	then 
		echo "Moving $(ls -1 $XML_PATH/|head -${MOVE_AMOUNT}|wc -l) files from ${XML_PATH}: ${count_var} ... $(ls -1 $XML_PATH/${FAILED_MT}*|wc -l) left"; 
		ls -1 ${XML_PATH}/${FAILED_MT}*|head -${MOVE_AMOUNT} | xargs -I {} mv {} /dfcxact/mediabuild/UNIT_DATA_OUT_MX/;
	else 
		echo "There are more than ${MIN_AMOUNT} ${FAILED_MT} Systems to process: ${count_var} ... $(ls -1 	$XML_PATH/|wc -l) left";
	fi; 
    echo "Sleeping for 5 secs..."; 
	sleep 5s; 
	refresh_count; 
done; 
echo "There are ${count_var} no ${FAILED_MT} XML to process. Exiting."
echo "DONE";

}
main;
