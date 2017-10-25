APPNAME=aarTest
VERSION=0.0.1-beta
ZIPALIGN = $HOME/Library/Android/sdk/build-tools/22.0.1/zipalign

all: createDist build release certificate

createDist:
	rm -rf ./dist
	cordova create dist com.dolearning.studentBookshelf ${APPNAME}
	cd ./dist \
	&& cordova platform add android \
	&& cordova plugin add cordova-plugin-compat@1.1.0 \
	&& cordova plugin add ../modules/cordova-plugin-crosswalk-webview \
	&& cordova plugin add cordova-plugin-ezar-snapshot \
	&& cordova plugin add cordova-plugin-file-transfer@1.5.1 \
	&& cordova plugin add cordova-plugin-file@4.2.0 \
	&& cordova plugin add cordova-plugin-device@1.1.2 \
	&& cordova plugin add cordova-plugin-zip@3.1.0 \
	&& cordova plugin add phonegap-plugin-barcodescanner@5.0.0 \
	&& cordova plugin add cordova-plugin-fileopener@1.0.4 \
	&& cordova plugin add cordova-plugin-networkinterface@1.0.8 \
	&& cordova plugin add cordova-plugin-network-information@1.3.2 \
	&& cordova plugin add https://github.com/arturokunder/cl.kunder.webview.git \
	&& cordova plugin add cordova-plugin-media-capture@1.3.0 \
	&& cordova plugin add cordova-plugin-camera@2.2.0 \
	&& cordova plugin add cordova-plugin-media@2.3.0

	# && cordova plugin add cordova-plugin-crosswalk-webview@1.6.1
	sed -i 's/'"${APPNAME}"'/尚/g' dist/platforms/android/.project



build:
	# npm install
	rm dist/config.xml
	rm dist/platforms/android/build.gradle
	cp files/config.xml dist/config.xml
	cp files/build.gradle dist/platforms/android
	mkdir dist/www/vendor && mkdir dist/www/vendor/book
	find ./dist -name "*.map" -o -name "*.scss" -o -name "*.es6" -o -name "*.jsx" -type f | xargs rm -rf

encrypt:
	cd modules/encrypt && bin/encrypt -s ../../dist/www -t ../../dist/www2
	rm -rf dist/www && mv dist/www2 dist/www
	cp -a ../bookshelf-student-v3/vendor/lockscreen.html dist/www/vendor


build-x86-debug:
	cd dist && cordova build android --debug --x86
	mv `pwd`/dist/platforms/android/build/outputs/apk/android-x86-debug.apk `pwd`/dist/${APPNAME}-debug-x86.apk

build-arm-debug:
	cd dist && cordova build android --debug --arm

build-x86-release:
	cd dist && cordova build android --release --x86

build-arm-release:
	cd dist && cordova build android --release --arm

certificate:
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore dist/dolearning-bookshelf.keystore dist/android-x86-release-unsigned.apk bookshelf
	jarsigner -verify -verbose -certs dist/android-x86-release-unsigned.apk
	${ZIPALIGN} -v 4 dist/android-x86-release-unsigned.apk dist/${APPNAME}-x86-${VERSION}.apk
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore dist/dolearning-bookshelf.keystore dist/android-armv7-release-unsigned.apk bookshelf
	jarsigner -verify -verbose -certs dist/android-x86-release-unsigned.apk
	${ZIPALIGN} -v 4 dist/android-armv7-release-unsigned.apk dist/${APPNAME}-arm-${VERSION}.apk

release: createDist build encrypt build-x86-release build-arm-release certificate
	# cd dist && cordova build android --release

debug: update createDist build build-x86-debug #build-arm-debug
	# cd dist && cordova build android --debug


update:
	cd modules/cordova-plugin-crosswalk-webview && npm install
# 	echo $PASSWORD
	# sed -i '' 's/git@github.com:/https:\/\/haozit146:'"${GITHUB_TOKEN}"'@github.com\//' package.json
	# git submodule update


.phony: build debug
