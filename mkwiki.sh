#!/bin/sh
. /storage/ikiwiki/farm/setvars.sh

# sed substitution file
SUBST=/tmp/$NAME.subst

echo mkdir $MASTER

cat <<EOF |
WEBNAME
NAME
WUSER
ADMIN
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
EOF
while read v
do
  echo s=@$v@=`eval echo "$"$v`=g
done > $SUBST

cat <<EOF
mkdir $WD
mkdir $WEBD
cd $FARM
sed -f $SUBST ikiwiki.setup > $SETUP
sed -f $SUBST index.mdwn > $WD/index.mdwn
sed -f $SUBST htaccess > $WEBD/.htaccess
sed -f $SUBST apache2-site.txt > $APACHE/$NAME
adduser --shell /bin/sh --system --gecos "$DESC" $WUSER
addgroup --system $WUSER
cd $WD
cg-init -I
cg-add index.mdwn
cg-commit -C -m 'added index page'
git-init-db --shared
echo "$DESC" > .git/description
mv .git $REPO
cd $MASTER
chown -R $WUSER.$WUSER $REPO
GIT_DIR=$REPO cg-admin-setuprepo -g $WUSER
mv $WD $WD.bak
git-clone -l -s $REPO $WD
echo $NAME $SETUP >> $WIKILIST
ikiwiki --setup $SETUP
for d in $REPO $WD $WEBD
do
  chown -R $WUSER.nogroup \$d
done
su $WUSER -c "ikiwiki --setup $SETUP"
chown -R $WUSER.nogroup $WD/.ikiwiki
ln -s $REPO $GITINDEX/
a2ensite $NAME
/etc/init.d/apache2 reload
cd $MASTER
mv $SUBST .subst
htdigest -c htpasswd $WEBNAME $ADMIN
EOF
