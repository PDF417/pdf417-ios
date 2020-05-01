#!/bin/sh

xcodebuild -project ../Samples/pdf417-sample-Swift/pdf417-sample-Swift.xcodeproj/ -sdk iphoneos archive -archivePath app.xcarchive -scheme pdf417-sample-Swift

xcodebuild -exportArchive -archivePath app.xcarchive -exportPath app.ipa -exportOptionsPlist exportOptions.plist -allowProvisioningUpdates

cp "app.ipa/App Thinning Size Report.txt" .
