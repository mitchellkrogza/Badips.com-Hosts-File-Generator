#!/bin/bash
# *****************************************************************************************************
# https://github.com/mitchellkrogza/Badips.com-Hosts-File-Generator
# *****************************************************************************************************
# ABOUT

# Shell script for blocking IPs which have been reported to http://www.badips.com
# This writes IP entries to your hosts.deny file on Linux and immediately blocks
# all the Bad Ip's it collects from accessing SSH on your server
# I run this as a daily cron to always have the freshest set of IP's and I collect
# only those IP addresses blocked by badips.com with a levels of 5 (very bad) within a 6 month
# period and pulls any IP's with a level 3 (bad) using your private key.
# This script uses the key method - you need your own key from badips.com
# On my Ubuntu Server this script takes all of 4-5 seconds to complete.
# *****************************************************************************************************
# RUNNING IT AS CRON

# A cron for this would be as follows (substitute your own email address)
# 30 22 * * * /bin/badips2hostsdeny.sh | mail -s "Bad IPs updated on `uname -n`" me@mydomain.com
# The above cron will run every night at 22:30
# *****************************************************************************************************

# On a daily basis this list will vary in length from 13000 - 25000 Bad IP entries
# If you play with the variables _age and _level you could increase this to a much larger list but it 
# is really not necessary as this script extracts only those IP's scored with a very high score on 
# badips.com - ie. only those who have repeat offended and been reported by multiple people
# *****************************************************************************************************
# GET OUR OWN PRIVATE KEY

# Make sure you get your own key from badips.com and add it below in the _keyservice field before running this
# wget https://www.badips.com/get/key -qO -
# See - https://www.badips.com/documentation
# *****************************************************************************************************
# ERRORS

# An error on the first run is normal "tail: invalid number of lines: ‘/etc/hosts.deny’"
# Avoid this by first adding the comment block into your exising hosts.deny file
# The Comment Block is the two lines below copy and paste it into your hosts.deny file

# ##### START badips.com Block List — DO NOT EDIT #####
# ##### END badips.com Block List #####

# Report any issues on https://github.com/mitchellkrogza/Badips.com-Hosts-File-Generator
# *****************************************************************************************************

_file=/etc/hosts.deny # Location of your hosts.deny file
_input=badips.db # Name of database we create on the fly
_input2=badipsprivate.db # Name of database we pull using our key 
_level=5 # Block level: not so bad (0) over confirmed bad (3) very bad (5)
_service=any # Logged service (http://www.badips.com for information on services)
_age=6m # Use h d w m and y (hours days weeks months years) ex 6m is 6 months
_tmp=tmp # Name of temporary file we create
_PRIVATEservice=any # Logged service (http://www.badips.com for information on services)
_PRIVATElevel=3 # Block level: not so bad (0) over confirmed bad (3) very bad (5)
_keyservice= # PLEASE ADD Your own private key

# Let us Get the bad IPs
wget -qO- http://www.badips.com/get/list/${_service}/${_level}?age=${_age} > $_input || { echo "$0: Unable to download ip list."; exit 1; }
wget -qO- http://www.badips.com/get/list/${_PRIVATEservice}/${_PRIVATElevel}/apidoc?key=${_keyservice} > $_input2 || { echo "$0: Unable to download ip list."; exit 1; }

# This defines a block inside our hosts.deny file. It will only write inside this block so 
# any custom blocks you already have won't be touched.
# Make sure any custom blocks are named differently example:
# # ### Custom Block Dont Touch ###
# # ### End Custom Block Dont Touch ###
_start="# ##### START badips.com Block List — DO NOT EDIT #####"
_end="# ##### END badips.com Block List #####"

# First lets delete the old entries
_line_start=`grep -x -n "$_start" $_file | cut -f1 -d:`
_line_end=`grep -x -n "$_end" $_file | cut -f1 -d:`
_lines=`wc -l < $_file`

# Chop out the old block if it exists
# *****************************************************************************************************
# An error on the first run is normal "tail: invalid number of lines: ‘/etc/hosts.deny’"
# Avoid this by first adding the above comment block into your exising hosts.deny file
# or simply ignore the first error and re-run the script and it will not error the second time around
# *****************************************************************************************************

if [[ "$_line_start" != " " ]]
then
    head -n`expr $_line_start - 1` $_file > $_tmp
    tail -n`expr $_lines - $_line_end` $_file >> $_tmp
else
    cp $_file $_tmp
fi

# Now lets add the new entries
echo $_start >> $_tmp
cat $_input | sed "s/^/ALL\:\ /g" >> $_tmp
cat $_input2 | sed "s/^/ALL\:\ /g" >> $_tmp
echo $_end >> $_tmp

# Replace and cleanup the old file
mv $_tmp $_file
rm $_input
rm $_input2

exit 0
