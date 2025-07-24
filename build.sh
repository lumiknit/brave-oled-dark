#!/bin/bash

set -e

EXTRACTED=b-ex

if [ -d "$EXTRACTED" ]; then
	echo "[NOTE] Directory $EXTRACTED already exists."
else
	# Decompile with Apktool (decode resources + classes)
	echo "[INFO] Downloading apktool"
	wget -q https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.12.0.jar -O apktool.jar

	echo "[INFO] apktool version $(java -jar apktool.jar -version)"

	echo "[INFO] Decompiling Brave browser APK"
	java -jar apktool.jar d brave.apk -r -o $EXTRACTED

	echo "[INFO] Removing META-INF directory"
	rm -rf $EXTRACTED/META-INF
fi

pushd $EXTRACTED

function patch() {
	local name="$1"
	echo "[INFO] Patching $name"
	# If finishes with '.rb' run with ruby
	if [[ "$name" == *.rb ]]; then
		ruby "$name"
		return
	fi
	. "$name"
}

echo "[INFO] Patching resources"

patch ../patches/0000-black.rb
patch ../patches/0001-bottom_toolbar_swipe_up.rb

popd

# Recompile the APK
echo "[INFO] Recompiling APK"
java -jar apktool.jar b b-ex -o b-patched.apk

# Align and sign the APK
echo "[INFO] Aligning the APK"
zipalign -p -f 4 b-patched.apk b-signed.apk

# Clean up
rm -rf b-patched.apk

