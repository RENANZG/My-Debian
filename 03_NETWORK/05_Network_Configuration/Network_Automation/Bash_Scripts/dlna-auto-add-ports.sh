#!/bin/bash

## See README.md for a full description of this script.
## https://github.com/PartialVolume/DNLAAutoAddPorts for downloads and installation instructions
## 
## Summary
## This script will open and close TCP & UDP ports automatically for specified processes only.
## It was designed to open TCP/UDP ports as randomly used by DLNA/UPNP servers that need
## to be accessable on the local area network, while having most ports closed to to your LAN
## except those explicitly stated by UFW or IPTABLES etc. It was mainly written with bubbleupnpserver
## and minidlnad in mind but should work for other DLNA software & devices. Any existing rules you
## have in your firewall are not affected.

## Check this script is running as root !
if [ "$(id -u)" != "0" ]; then echo "Aborting, this script needs to be run as root!";exit 1;fi

## -----------------------------------
## User Configuration
## Edit these based on which DLNA servers you are running, multiple DLNA servers are ok. Separate each server name by a space
## Note case is important, process names must match exactly what you see if you run ps -ef | grep -i bubbleupnpserver or
## ps -ef | grep -i minidlnad or ps -ef | grep -i rygel
## Note rhythmbox dleyna-server is not currently supported as dleyna opens & closes ports too quickly for this script to keep up
## an alternative c coded script is in the works which will require less CPU and will capable of running more frequently.
processnames="minidlnad java:BubbleUPnPServer java:ums.jar rygel rhythmbox dleyna-server"


## Minimum lower port for use by DLNA for random ports, I'm not sure what this should be, but seems to be about 32000
min_DLNA_port="30000" 

## all TCP ports below 'min_DLNA_port' will not be opened except for these exemptions
## 3689 used by rhythmbox, 5001=ums
allowed_TCP_ports_below_min_DLNA_port="3689 8200 5001"

## all UDP ports below 32000 will not be opened except for these exemptions
allowed_UDP_ports_below_min_DLNA_port="1900 5353"

## End of User Configuration
## -----------------------------------

# Set logfiles
version="DLNAAutoAddPorts v2.0.15"
logtcp="/tmp/ports.tcp"
logudp="/tmp/ports.udp"
currtcp="/tmp/curr.tcp"
currudp="/tmp/curr.udp"

## Only one instance of this script should ever be running and as its use is normally called via cron, if it's then run manually
## for test purposes it may intermittently update the ports.tcp & ports.udp files unnecessarily. So here we check no other instance
## is running. If another instance is running we pause for 3 seconds and then delete the PID anyway. Normally this script will run
## in under 150ms and via cron runs every 60 seconds, so if the PID file still exists after 3 seconds then it's a orphan PID file.
DNLAAutoAddPortsPID="/var/run/DNLAAutoAddPorts.sh.pid"
if [ -f "$DNLAAutoAddPortsPID" ]
then
        sleep 3 #if PID file exists wait 3 seconds and test again, if it still exists delete it and carry on
        echo "There appears to be another DLNAAutoAddPorts running, waiting for 3 seconds ..."
        rm -f -- "$DNLAAutoAddPortsPID"
fi		
trap "rm -f -- $DNLAAutoAddPortsPID" EXIT
echo $$ > "$DNLAAutoAddPortsPID"


## Check for arguments
if [ "$1" = -v ]; then verbose="1"; else verbose="0";fi

## Get listening ports, multiple ports may be returned by each netstat command determined by process name, the results are sorted and duplicates deleted.
tcpports=""
udpports=""
if [ $verbose -eq "1" ]; then echo $version;fi
if [ $verbose -eq "1" ]; then echo "Ports are being checked/opened/closed for the following processes:";fi
for i in $processnames
do
    ## check for a prefix and if present split the prefix & processname
    prefix=""
    process=""
    if [[ $i == *":"* ]]
    then
            prefix=$(echo $i | cut -d ':' -f 1)
            process=$(echo $i | cut -d ':' -f 2)
            netstatprocess=$prefix
    else
            netstatprocess=$i
    fi
    
    if [ $verbose -eq '1' ]; then echo "10 i=$i, netstatprocess=$netstatprocess, process=$process, prefix=$prefix";fi

    tcpports_tmp="$(/bin/netstat -anpt | grep $netstatprocess | grep 'LISTEN\|ESTABLISHED\|SYNC\|CLOSE\|FIN\|LAST' | cut -d ':' -f 2 | cut -d ' ' -f 1 | xargs -n1 | sort -u)"" "
    udpports_tmp=$(/bin/netstat -anp | grep '^udp' | grep $netstatprocess | cut -d ':' -f 2 | cut -d ' ' -f 1 | xargs -n1 | sort -u)" "
    
    if [ -n "$prefix" ]
    then
            if [ $verbose -eq '1' ]; then echo "20 prefix=$prefix";fi
            for port in "$tcpports_tmp"
            do
                ## For each port in the list use netstat to return a PID, this PID will then be used in a search using ps below
                #pid=$(/bin/netstat -anp | grep "^tcp" | awk '{ print substr($0, index($0,$6)) }' | grep "^LISTEN" | awk '{ print substr($0, index($0,$2)) }' | grep "$netstatprocess" | cut -d '/' -f 1 | xargs -n1 | sort -u)
                pid="$(/bin/netstat -anpt | awk '{ print substr($0, index($0,$6)) }' | awk '{ print substr($0, index($0,$2)) }' | grep $netstatprocess | cut -d '/' -f 1 | sort -u)"
                if [ $verbose -eq '1' ]; then echo "38 tcp pid=$pid";fi
                
                ## TCP, Using the PID search for the process name using ps
                ps_process=$(ps -ef | awk '{ print substr($0, index($0,$2)) }' | grep "^$pid" |  awk '{ print substr($0, index($0,$7)) }' | grep "$process")
                if [ $? -eq '0' ];then tcpports="$tcpports$port ";fi
            done

            for port in "$udpports_tmp"
            do
                ## For each port in the list use netstat to return a PID, this PID will then be used in a search using ps below
                pid="$(/bin/netstat -anpu | awk '{ print substr($0, index($0,$6)) }' | grep -v '^ESTABLISHED' | awk '{ print substr($0, index($0,$2)) }' | grep "$netstatprocess" | cut -d '/' -f 1 | xargs -n1 | sort -u)"
                if [ $verbose -eq '1' ]; then echo "40 udp pid=$pid";fi
                
                ## UDP, Using the PID search for the process name using ps
                ps_process=$(ps -ef | awk '{ print substr($0, index($0,$2)) }' | grep "^$pid" |  awk '{ print substr($0, index($0,$7)) }' | grep "$process")
                if [ $? -eq '0' ];then udpports="$udpports$port ";fi
            done
    else
            tcpports=$tcpports$tcpports_tmp
            udpports=$udpports$udpports_tmp
    fi

done

## Sort ports removing duplicates and clean up
tcpports=$(echo $tcpports | xargs -n1 | sort -u | xargs)
udpports=$(echo $udpports | xargs -n1 | sort -u | xargs)

if [ $verbose -eq '1' ]; then echo "119 tcpports=$tcpports";fi
if [ $verbose -eq '1' ]; then echo "120 udpports=$udpports";fi


## Process the list of found ports removing those below min_DLNA_port unless 
## in 'allowed_TCP_ports_below_min_DLNA_port' or 'allowed_UDP_ports_below_min_DLNA_port' 

## TCP
tcpports_tmp=""
for tcpport in $tcpports
do
	if [ $tcpport -lt $min_DLNA_port ]
	then
		disallowed=1
		for TCP_allowed in $allowed_TCP_ports_below_min_DLNA_port
		do
			if [ $tcpport -eq $TCP_allowed ]
			then
				disallowed=0
				tcpports_tmp=$tcpports_tmp' '$tcpport
				if [ $verbose -eq '1' ]; then echo Port $tcpport is below minimum DLNA port $min_DLNA_port but in allowed list [ACCEPTED];fi
			fi
		done
		if [ $disallowed -eq '1' ];then if [ $verbose -eq '1' ]; then echo Port $tcpport is below minimum DLNA port $min_DLNA_port and NOT in allowed list [REJECTED];fi;fi
	else 
		tcpports_tmp=$tcpports_tmp' '$tcpport
	fi
done
tcpports=$tcpports_tmp

## UDP
udpports_tmp=""
for udpport in $udpports
do
        if [ $udpport -lt $min_DLNA_port ]
        then
                disallowed=1
                for UDP_allowed in $allowed_UDP_ports_below_min_DLNA_port
                do
                        if [ $udpport -eq $UDP_allowed ]
                        then
                                disallowed=0
                                udpports_tmp=$udpports_tmp' '$udpport
                                if [ $verbose -eq '1' ]; then echo Port $udpport is below minimum DLNA port $min_DLNA_port but in allowed list [ACCEPTED];fi
                        fi
                done
                if [ $disallowed -eq '1' ];then if [ $verbose -eq '1' ]; then echo Port udpport is below minimum DLNA port $min_DLNA_port and NOT in allowed list [REJECTED];fi;fi
        else
                udpports_tmp=$udpports_tmp' '$udpport
        fi
done
udpports=$udpports_tmp


## If in verbose mode echo a list of the TCP/UDP ports found as being used by the 'processnames'

if [ $verbose -eq '1' ]; then echo "Ports identified as being used by the above processes..";fi
if [ ! -z "$tcpports" ] || [ "$tcpports" = ' ' ]
then
        if [ $verbose -eq '1' ]; then echo "60 TCP/"$tcpports;fi
else
        if [ $verbose -eq '1' ]; then echo "No process & associated TCP ports found";fi
fi
if [ ! -z "$udpports" ] || [ "$udpports" = ' ' ]
then
        if [ $verbose -eq '1' ]; then echo "70 UDP/"$udpports;fi
else
        if [ $verbose -eq '1' ]; then echo "No process & associated UDP ports found";fi
fi


## Compare previous and current ports, if no change exit, if change then update iptables
## Echo all the TCP ports to a file

## Create empty current port files, necessary in the situation
## where no process/ports are found else we get diff failing and
## create empty logtcp/udp files for the same reason

if [ -f $currtcp ]; then rm $currtcp; touch $currtcp;fi
if [ -f $currudp ]; then rm $currudp; touch $currudp;fi
if [ ! -f $logtcp ]; then touch $logtcp;fi
if [ ! -f $logudp ]; then touch $logudp;fi

## save the tcp/udp ports to files so we can diff them.
for tcpport in $tcpports
do
        echo $tcpport >> $currtcp
done
for udpport in $udpports
do
        echo $udpport >> $currudp
done

## TCP
if [ $verbose -eq '1' ]; then echo "diff output of previous and current TCP port logs follows..";fi
if [ $verbose -eq '1' ]; then diffcurrtcp="$(diff $currtcp $logtcp)";status="$?";echo "$diffcurrtcp";else diffcurrtcp="$(diff $currtcp $logtcp)";status="$?";fi
if [ $status = '0' ]
then
        if [ $verbose -eq '1' ]; then echo "No change in TCP ports";fi
else
        if [ $verbose -eq '1' ]; then echo "TCP ports have changed, updating logs and iptables";fi
        
        ## Delete old TCP firewall rules
        if [ -f "$logtcp" ]
        then
                if [ $verbose -eq '1' ]; then echo "Deleting old TCP firewall rules ..";fi
                for tcpport in $(cat $logtcp)
                do
                        /sbin/iptables -D INPUT -p tcp --dport $tcpport -j ACCEPT
                        status=$?
                        if [ $status != 0 ]
                        then
                                echo "Error deleting old TCP firewall rules, code="$status
                        else
                                if [ $verbose -eq '1' ]; then echo "Deleted "$tcpport;fi
                        fi
                done
                rm $logtcp
        fi
        
        ## Add TCP Firewall rules
        if [ "$tcpports" != "" ]; then if [ $verbose -eq '1' ]; then echo "Adding TCP firewall rules..";fi;fi
        for tcpport in $tcpports
        do
                /sbin/iptables -A INPUT -p tcp --dport $tcpport -j ACCEPT
                status=$?
                if [ $status != 0 ]
                then
                        echo "Error adding TCP firewall rule $tcpport, code="$status
                else
                        if [ $verbose -eq '1' ]; then echo "Added "$tcpport;fi
                fi
        done

        ## Echo all the TCP ports to a file
        for tcpport in $tcpports
        do
                echo $tcpport >> $logtcp
                if [ $verbose -eq '1' ]; then echo "Writing $tcpport to $logtcp";fi
        done

fi

# UDP
if [ $verbose -eq '1' ]; then echo "diff output of previous and current UDP port logs follows..";fi
if [ $verbose -eq '1' ]; then diffcurrudp="$(diff $currudp $logudp)";status=$?;echo "$diffcurrudp";else diffcurrudp="$(diff $currudp $logudp)";status=$?;fi
if [ $status = '0' ]
then
        if [ $verbose -eq '1' ]; then echo "No change in UDP ports";fi
else
        if [ $verbose -eq '1' ]; then echo "UDP ports have changed, updating logs and iptables";fi
        
        ## Delete old UDP firewall rules
        if [ -f "$logudp" ]
        then
                if [ $verbose -eq '1' ]; then echo "Deleting old UDP firewall rules ..";fi
                for udpport in $(cat $logudp)
                do
                        /sbin/iptables -D INPUT -p udp --dport $udpport -j ACCEPT
                        status=$?
                        if [ $status != 0 ]
                        then
                                echo "Error deleting old UDP firewall rules, code="$status
                        else
                                if [ $verbose -eq '1' ]; then echo "Deleted "$udpport;fi
                        fi

                done
                rm $logudp
        fi

        ## Add UDP Firewall Rules ..
        if [ "$udpports" != "" ]; then if [ $verbose -eq '1' ]; then echo "Adding UDP firewall rules..";fi;fi
        for udpport in $udpports
        do
                /sbin/iptables -A INPUT -p udp --dport $udpport -j ACCEPT
                status=$?
                if [ $status != 0 ]
                then
                        echo "Error adding UDP firewall rule $udpport, code="$status
                else
                        if [ $verbose -eq '1' ]; then echo "Added "$udpport;fi
                fi
        done

        ## Echo all UDP ports to a file
        for udpport in $udpports
        do
                echo $udpport >> $logudp
                if [ $verbose -eq '1' ]; then echo "Writing $udpport to $logudp";fi
        done
fi
