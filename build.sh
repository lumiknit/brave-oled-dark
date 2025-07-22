#!/bin/bash

set -e

# Decompile with Apktool (decode resources + classes)
wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.12.0.jar -O apktool.jar
java -jar apktool.jar d brave.apk -r -o b-ex
rm -rf b-ex/META-INF

pushd b-ex

function patch() {
	local name="$1"
	echo "[INFO] Patching $name"
	. "$name"
}

patch ../patches/0000-black.sh

popd

# Recompile the APK
java -jar apktool.jar b b-ex -o b-patched.apk

# Align and sign the APK
zipalign 4 b-patched.apk b-signed.apk

# Clean up
rm -rf b-patched.apk

