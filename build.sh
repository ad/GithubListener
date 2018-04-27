#!/bin/bash

NAME='GitHubListener'

rm -rf Release 2>/dev/null

xcodebuild archive \
	-scheme "$NAME" \
	-archivePath Release/App.xcarchive

xcodebuild \
	-exportArchive \
	-archivePath Release/App.xcarchive \
	-exportOptionsPlist export-options.plist \
	-exportPath Release

cd Release
rm -r App.xcarchive

sleep 5

VER=`mdls -raw -name kMDItemVersion $NAME.app`

ARCH_NAME="$NAME.v$VER.zip"
zip -r $ARCH_NAME $NAME.app
# echo "$ARCH_NAME"
