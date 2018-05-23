#!/bin/bash

rm -r Release 2>/dev/null

xcodebuild archive \
    -scheme "GitHubListener" \
    -archivePath Release/App.xcarchive

xcodebuild \
    -exportArchive \
    -archivePath Release/App.xcarchive \
    -exportOptionsPlist export-options.plist \
    -exportPath Release

cd Release
rm -r App.xcarchive
sleep 2

# Prerequisite: npm i -g create-dmg
# create-dmg "${NAME}.app"

VERSION=`mdls -raw -name kMDItemVersion GitHubListener.app`
echo $VERSION
zip -r "GitHubListener.v$VERSION.zip" "GitHubListener.app"
