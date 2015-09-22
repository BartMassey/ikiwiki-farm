#!/bin/sh
# Copyright (c) 2007 Bart Massey <bart@cs.pdx.edu>
# All Rights Reserved
# Please see the file COPYING distributed
# with this script for license information.

. /storage/ikiwiki/farm/setvars.sh

sed 's/^@/#/' <<EOF
@ check for already initialized
if [ -d $MASTER ] || [ -d $WEBD ] || [ -f $APACHE/$NAME ] || [ -f $GITINDEX/$NAME.git ]
then
  echo "wiki exists" >&2
  echo "MASTER=$MASTER WEB=$WEBD WEBCONFIG=$APACHE/$NAME GIT=$GITINDEX/$NAME.git" >&2
  exit 1
fi
EOF

# sed substitution file
SUBST=$FARM/cnf/$NAME.subst
# mailman config file
MMTMP=/tmp/$NAME.mmc

cat <<EOF |
WEBNAME
DESCNAME
NAME
UNAME
WUSER
ADMIN
MAILDOMAIN
ADMINEMAIL
DESC
STORAGE
WEB
FARM
MASTER
SETUP
WD
REPO
WEBD
WIKILIST
ACCTPASS
PRIVATE
LISTNAME
LISTDOMAIN
LISTWEBDOMAIN
LISTADMIN
LISTPASSWD
EOF
while read v
do
  echo s=@$v@=`eval echo "$"$v`=g
done > $SUBST

sed 's/^@/#/' <<EOF
@ do initial setup
mkdir $MASTER
mkdir $WD
mkdir $WEBD
@ build config files
cd $FARM
sed -f $SUBST ikiwiki.setup > $SETUP
sed -f $SUBST index.mdwn > $WD/index.mdwn
sed -f $SUBST apache2-site.txt > $APACHE/$WEBNAME
@ set up user and groups
GECOSDESC="`echo "$DESC" | tr ':,' '-'`"
adduser --shell /bin/sh --disabled-password --gecos "\$GECOSDESC" $WUSER
addgroup $ADMIN $WUSER
cd $MASTER
@ set up working directory
chown -R $WUSER.$WUSER $WD
@ set up repo
ikiwiki-makerepo git $WD $REPO
echo "$DESC" > $REPO/description
chown -R $WUSER.$WUSER $REPO
ln -s $REPO $GITINDEX/
chown -R $WUSER.$WUSER $WD
@ set up web directory
[ "$PRIVATE" = '#' ] && sed -f $SUBST $FARM/htaccess > $WEBD/.htaccess
chown -R $WUSER.$WUSER $WEBD
su $WUSER -c "ikiwiki --setup $SETUP_BASE"
@ XXX workaround for ikiwiki bug
( cd $WD/.ikiwiki
  touch commitlock
  chmod 600 commitlock
  chown $WUSER.$WUSER commitlock )
@ ikiwiki / apache setup
echo $WUSER $SETUP >> $WIKILIST
chmod u+s $WEBD/ikiwiki.cgi
chmod u+s $REPO/hooks/post-update
a2ensite $WEBNAME
/etc/init.d/apache2 reload
@ optional email list setup
if [ "$LISTNAME" != "" ]
then
  $MMBIN/newlist \\
    -q -u $LISTWEBDOMAIN -e $LISTDOMAIN \\
    $LISTNAME $LISTADMIN $LISTPASSWD
  sed -f $SUBST $FARM/mailman-config >$MMTMP &&
  $MMBIN/config_list -i $MMTMP $LISTNAME &&
  rm $MMTMP
fi
@ save substitutions for future reference
mv $SUBST .subst
EOF
