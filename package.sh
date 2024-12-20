#!/usr/bin/env bash
cd "$(dirname "$0")"
export SCRIPT_DIR="$(pwd)"
export PACKAGE_NAME=LREditionDetails
export TARGET_DIR_MAC="$SCRIPT_DIR/target/mac/Library/Application Support/Adobe/Lightroom"
export TARGET_DIR_WIN="$SCRIPT_DIR/target/win/AppData/Roaming/Adobe/Lightroom"
export SOURCE_DIR=$SCRIPT_DIR/src/main/lua/$PACKAGE_NAME.lrdevplugin
export RESOURCE_DIR=$SCRIPT_DIR/res
export VERSION=1.1.0.0
#
export TARGET_DIR_QRGEN_MAC="$SCRIPT_DIR/target/mac/Library/Application Support/QRGen"
export TARGET_DIR_QRGEN_WIN="$SCRIPT_DIR/target/win/AppData/Local/Programs/QRGen"
export SOURCE_DIR_QRGEN="$HOME/Library/Application Support/QRGen"
#
# mac
#
if [ -d  "$TARGET_DIR_MAC" ]; then
   rm -d -f -r "$TARGET_DIR_MAC"
fi
rm $SCRIPT_DIR/target/$PACKAGE_NAME-$VERSION"_mac.zip"

mkdir -p "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
mkdir -p "$TARGET_DIR_QRGEN_MAC"

# copy dev

cp -R "$SOURCE_DIR"/* "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
cp -R "$SOURCE_DIR_QRGEN"/* "$TARGET_DIR_QRGEN_MAC"
# compile
#cd "$TARGET_DIR_MAC/Modules/$PACKAGE_NAME.lrplugin"
#for f in *.lua
#do
# luac5.1 -o $f $f
#done
# cd $RESOURCE_DIR
# cp -R * "$TARGET_DIR_MAC"
cd "$SCRIPT_DIR/target/mac"
zip -q -r ../$PACKAGE_NAME-$VERSION"_mac.zip" Library

# win
#
if [ -d  "$TARGET_DIR_WIN" ]; then
   rm -d -f -r "$TARGET_DIR_WIN"
fi
rm $SCRIPT_DIR/target/$PACKAGE_NAME-$VERSION"_win.zip"
mkdir -p "$TARGET_DIR_WIN/Modules/$PACKAGE_NAME.lrplugin"
mkdir -p "$TARGET_DIR_QRGEN_WIN"
# copy dev

cp -R "$SOURCE_DIR"/* "$TARGET_DIR_WIN/Modules/$PACKAGE_NAME.lrplugin"
cp -R "$SOURCE_DIR_QRGEN"/* "$TARGET_DIR_QRGEN_WIN"
# compile
#cd "$TARGET_DIR_WIN/Modules/$PACKAGE_NAME.lrplugin"
#for f in *.lua
#do
# luac5.1 -o $f $f
#done
# cd $RESOURCE_DIR
# cp -R * "$TARGET_DIR_WIN"
cd $SCRIPT_DIR/target/win
zip -q -r ../$PACKAGE_NAME-$VERSION"_win.zip" AppData


