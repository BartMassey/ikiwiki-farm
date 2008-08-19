# source config file
# Copyright (c) 2007 Bart Massey <bart@cs.pdx.edu>
# All Rights Reserved
# Please see the file COPYING distributed
# with this script for license information.
PGM="`basename $0`"
if [ $# -ne 1 ]
then
  echo "$PGM: usage: $PGM <config>" >&2
  exit 1
fi
if . $1
then
  :
else
  echo "PGM: couldn't source $1" >&2
  exit 1
fi

# where the global git index lives
GITINDEX=/git
# where apache descriptions live
APACHE=/etc/apache2/sites-available
# where master directories live
STORAGE=/storage/ikiwiki
# where web pages live
WEB=/var/www
# where the farm is
FARM=$STORAGE/farm
# where the wiki list is
WIKILIST=/etc/ikiwiki/wikilist

# master directory
MASTER=$STORAGE/$NAME
# setup file
SETUP_BASE=$NAME.setup
SETUP=$MASTER/$SETUP_BASE
# working directory
WD_BASE=$NAME-wd
WD=$MASTER/$WD_BASE
# master repository
REPO_BASE=$NAME.git
REPO=$MASTER/$REPO_BASE
# web directory
WEBD=$WEB/$WEBNAME
# uppercase description for email list tag
UDESC="`echo \"$DESC\" | tr 'a-z' 'A-Z'`"
