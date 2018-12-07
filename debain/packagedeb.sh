#!/bin/sh
 
PACKAGE_NAME="jdesk9"
OS_ARCH="64bit"
PACKAGE_VERSION="0.1.1"
SOURCE_DIR=$PWD
OUT_DIR="target"
TEMP_DIR="/tmp"
JRE_DIR=$PWD/java/jre

mkdir -p $SOURCE_DIR/../$OUT_DIR
mkdir -p $TEMP_DIR/debian/DEBIAN
mkdir -p $TEMP_DIR/debian/lib
mkdir -p $TEMP_DIR/debian/usr/games
mkdir -p $TEMP_DIR/debian/usr/share/applications
mkdir -p $TEMP_DIR/debian/usr/share/$PACKAGE_NAME
mkdir -p $TEMP_DIR/debian/usr/share/doc/$PACKAGE_NAME
mkdir -p $TEMP_DIR/debian/usr/share/common-licenses/$PACKAGE_NAME
 
echo "Package: $PACKAGE_NAME" > $TEMP_DIR/debian/DEBIAN/control
echo "Version: $PACKAGE_VERSION" >> $TEMP_DIR/debian/DEBIAN/control
cat control >> $TEMP_DIR/debian/DEBIAN/control
 
cp *.desktop $TEMP_DIR/debian/usr/share/applications/
cp copyright $TEMP_DIR/debian/usr/share/common-licenses/$PACKAGE_NAME/ # results in no copyright warning
#cp copyright $TEMP_DIR/debian/usr/share/doc/$PACKAGE_NAME/ # results in obsolete location warning
 
cp -rf $JRE_DIR/* $TEMP_DIR/debian/usr/share/$PACKAGE_NAME/
cp $PACKAGE_NAME $TEMP_DIR/debian/usr/games/
 
echo "$PACKAGE_NAME ($PACKAGE_VERSION) trusty; urgency=low" > changelog
echo "  * Rebuild" >> changelog
echo " -- Manoj kushwah <design@jsinformatics.com>  `date -R`" >> changelog
gzip -9c changelog > $TEMP_DIR/debian/usr/share/doc/$PACKAGE_NAME/changelog.gz
 
cp *.svg $TEMP_DIR/debian/usr/share/$PACKAGE_NAME/
chmod 0664 $TEMP_DIR/debian/usr/share/$PACKAGE_NAME/*svg
 
PACKAGE_SIZE=`du -bs $TEMP_DIR/debian | cut -f 1`
PACKAGE_SIZE=$((PACKAGE_SIZE/1024))
echo "Installed-Size: $PACKAGE_SIZE" >> $TEMP_DIR/debian/DEBIAN/control
 
chown -R root $TEMP_DIR/debian/
chgrp -R root $TEMP_DIR/debian/
 
cd $TEMP_DIR/
dpkg --build debian
#mv debian.deb $SOURCE_DIR/$PACKAGE_NAME-$PACKAGE_VERSION.deb
mv debian.deb $SOURCE_DIR/../$OUT_DIR/$PACKAGE_NAME\($OS_ARCH\).deb
rm -r $TEMP_DIR/debian
