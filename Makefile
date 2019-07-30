APPNAME=aarTest
VERSION=0.0.1-beta


createDist:
	rm -rf ./dist
	cordova create dist com.dolearning.studentBookshelf ${APPNAME}
	cd ./dist \
	&& cordova platform add android

	ls dist -al
	ls dist/platforms -al
	ls dist/platforms/android -al


build-x86-debug:
	cd dist && cordova build android --debug --x86
	ls dist/platforms/android/build/outputs/apk/
	mv dist/platforms/android/build/outputs/apk/android-debug.apk dist/${APPNAME}-debug.apk	
	ls ./
	ls ./dist

build-arm-debug:
	cd dist && cordova build android --debug --arm

build-x86-release:
	cd dist && cordova build android --release --x86

build-arm-release:
	cd dist && cordova build android --release --arm

debug: createDist build-x86-debug #build-arm-debug
	# cd dist && cordova build android --debug


update:
	cd modules/cordova-plugin-crosswalk-webview && npm install


.phony: build debug
