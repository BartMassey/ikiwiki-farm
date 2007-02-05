# source config file
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
SETUP=$MASTER/$NAME.setup
# working directory
WD=$MASTER/$NAME-wd
# master repository
REPO=$MASTER/$NAME.git
# web directory
WEBD=$WEB/$WEBNAME
