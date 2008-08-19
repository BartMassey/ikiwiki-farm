#!/bin/sh
# Copyright (c) 2007 Bart Massey <bart@cs.pdx.edu>
# All Rights Reserved
# Please see the file COPYING distributed
# with this script for license information.

. /storage/ikiwiki/farm/setvars.sh

cat <<EOF
a2dissite $WEBNAME
/etc/init.d/apache2 reload
rm -rf $MASTER $WEBD $APACHE/$WEBNAME $GITINDEX/$NAME.git
deluser $WUSER
delgroup $WUSER
sed -i "/^$NAME /d" $WIKILIST
[ $LISTNAME != "" ] && $MMBIN/rmlist $LISTNAME
EOF
