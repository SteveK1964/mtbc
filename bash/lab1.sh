# First Lab

#!/bin/bash

# Accept two command line parms
#   parm 1 = virtual host configuration
#   parm 2 = which service directive we wanted to use
CONFIG="$1"
COMMAND="$2"

# Get the valid sites available in the Apache2 folder
VHOSTS_PATH=/etc/apache2/sites-available/*.conf

BOLVALIDHOST="false"
STRFULLNAME="/etc/apache2/sites-available/""$CONFIG"".conf" 
clear

# Ensure two parms were entered
if [ $# -eq 2 ] 
then
    # only allow reload or restart.
    if [ "$COMMAND" == "reload" ] || [ "$COMMAND" == "restart" ]
    then
        # Check if the configuration entered on command line
        #   is in the configuration set
        for FILENAME in $VHOSTS_PATH
        do
            if [ "$STRFULLNAME" = "$FILENAME" ]
            then
                BOLVALIDHOST="true"
            fi
            
        done

        if [ "$BOLVALIDHOST" = "false" ]
        then
            echo " "
            echo "ERROR: Invalid host entered"
            echo " "
            echo "You entered host name = " "$CONFIG"
            echo " "
            echo "Following hosts are available:"

            # Echo back the valid hosts
            for FILENAME in $VHOSTS_PATH
            do
                echo "   $FILENAME" 
            done
          
            echo " " 


            exit 1
        else



            # Move the current execution state to the proper directory
            cd /etc/apache2/sites-available
            cd ~

            # Disable a vhost configuration
            sudo a2dissite "$CONFIG"
            sudo service apache2 "$COMMAND"

            # Enable a vhost configuration
            sudo a2ensite "$CONFIG"
            sudo service apache2 "$COMMAND"
        fi

    else
        echo "ERROR: $COMMAND is an invalid service command {restart|reload}"
        exit 1
    fi

else
    echo "ERROR: $0 requires two parameters {virtual-host} {restart|reload}"
    exit 1
fi
