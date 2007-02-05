#!/bin/sh
. /storage/ikiwiki/farm/setvars.sh

cat <<EOF
a2dissite $NAME
/etc/init.d/apache2 reload
rm -rf $MASTER $WEBD $APACHE/$NAME $GITINDEX/$NAME.git
deluser $WUSER
delgroup $WUSER
sed -i "/^$NAME /d" $WIKILIST
EOF
