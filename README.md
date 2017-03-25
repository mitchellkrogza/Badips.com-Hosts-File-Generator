# Badips.com hosts.deny File Generator

A simple shell script to pull a daily list of known bad hosts from badips.com and create an /etc/hosts.deny file for you. 
Only hosts with a level 5 (very bad) and level 3 (bad) are pulled daily from badips.com.

- https://github.com/mitchellkrogza/Badips.com-Hosts-File-Generator

## ABOUT

Shell script for blocking IPs which have been reported to http://www.badips.com. This writes IP entries to your hosts.deny file on Linux and immediately blocks all the Bad Ip's it collects from accessing SSH on your server

I run this as a daily cron to always have the freshest set of IP's and I collect only those IP addresses blocked by badips.com with a levels of 5 (very bad) within a 6 month period and pulls any IP's with a level 3 (bad) using your private key.

This script uses the key method - you need your own key from badips.com, on my servers this script takes all of 4-5 seconds to complete.

## INSTALLATION

`cd /usr/sbin`

`sudo wget https://raw.githubusercontent.com/mitchellkrogza/Badips.com-Hosts-File-Generator/master/badips2hostsdeny.sh -O badips2hostsdeny.sh`

Make the file executable

`sudo chmod 700 /usr/sbin/badips2hostsdeny.sh`

## RUNNING IT AS CRON

A cron for this would be as follows (substitute your own email address)

`30 22 * * * /usr/sbin/badips2hostsdeny.sh | mail -s "Bad IPs updated on `uname -n`" me@mydomain.com`

The above cron will run every night at 22:30 and email you to tell you it was updated.

On a daily basis this list will vary in length from 13000 - 25000 Bad IP entries

If you play with the variables _age and _level you could increase this to a much larger list but it is really not necessary as this script extracts only those IP's scored with a very high score on badips.com - ie. only those who have repeat offended and been reported by multiple people.

## GET OUR OWN PRIVATE KEY

Make sure you get your own key from badips.com and add it below in the _keyservice field before running this

`sudo wget https://www.badips.com/get/key -qO -`

See - https://www.badips.com/documentation

# ERRORS

An error on the first run is normal "tail: invalid number of lines: ‘/etc/hosts.deny’"

Avoid this by first adding the comment block into your exising hosts.deny file

The Comment Block is the two lines below copy and paste it into your hosts.deny file

```
# ##### START badips.com Block List — DO NOT EDIT #####
# ##### END badips.com Block List #####
```

Report any issues on https://github.com/mitchellkrogza/Badips.com-Hosts-File-Generator

# KEEP BAD BOTS AT BAY !!!

Check out my highly popular Nginx and Apache Bad Bot Blockers

**NGINX ULTIMATE BAD BOT BLOCKER**

https://github.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker

**APACHE ULTIMATE BAD BOT BLOCKER**

https://github.com/mitchellkrogza/apache-ultimate-bad-bot-blocker

Use the bad bot bot blockers in conjuction with this Badips.com hosts.deny and you will keep almost every bad IP and bot out there out of your servers.

Come drop by and visit me also at https://mitchellkrog.com

### If this helps you [You can buy me a beer](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=BKF9XT6WHATLG):beer: or send some cheese for my cat [![gitcheese.com](https://api.gitcheese.com/v1/projects/92bf5669-7d2c-447d-baa4-216ac9e720a6/badges)](https://www.gitcheese.com/app/#/projects/92bf5669-7d2c-447d-baa4-216ac9e720a6/pledges/create)
