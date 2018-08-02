#!/bin/sh
set -e

xcodebuild -project Samples/DirectAPI-sample-Swift/DirectAPI-sample-Swift.xcodeproj \
	-scheme DirectAPI-sample-Swift \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	clean build

xcodebuild -project Samples/pdf417-sample-Swift/pdf417-sample-Swift.xcodeproj \
	-scheme pdf417-sample-Swift \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
	clean build