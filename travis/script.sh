#!/bin/sh
set -e

xctool -project pdf417-sample/pdf417-sample.xcodeproj \
	-scheme pdf417-sample \
	-configuration Debug \
	-sdk iphoneos \
	ONLY_ACTIVE_ARCH=NO \
 	build

xctool -project pdf417-sample/pdf417-sample.xcodeproj \
	-scheme pdf417-sample \
	-configuration Release \
	-sdk iphoneos \
	ONLY_ACTIVE_ARCH=NO \
 	build

xctool -project pdf417-sample/pdf417-sample.xcodeproj \
	-scheme pdf417-sample \
	-configuration Debug \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	build

xctool -project pdf417-sample/pdf417-sample.xcodeproj \
	-scheme pdf417-sample \
	-configuration Release \
	-sdk iphonesimulator \
	ONLY_ACTIVE_ARCH=NO \
 	build