#!/bin/bash

#  build.command
#  CoreDisplayFixup
#
#  Copyright © 2017 Vanilla. All rights reserved.

cd "$(dirname "$0")"/..

if [[ ! -d Lilu.kext ]]; then
  echo "Lilu.kext not found at repo dir, trying desktop"
  if [[ -d ~/Desktop/Lilu.kext ]]; then
    mv ~/Desktop/Lilu.kext Lilu.kext
  else
    echo "Lilu.kext still not found, exiting..."
    exit 1
  fi
fi

TARGET=("Debug" "Release")

for build in "${TARGET[@]}"; do
  xcodebuild build -configuration "${build}"
done

VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" build/Debug/CoreDisplayFixup.kext/Contents/Info.plist)

cd build/Debug
zip -qr $VERSION.DEBUG.zip CoreDisplayFixup.kext
mv $VERSION.DEBUG.zip ../..

cd ../Release
zip -qr $VERSION.RELEASE.zip CoreDisplayFixup.kext
mv $VERSION.RELEASE.zip ../..

cd ../.. && rm -r build 

open .

exit 0
