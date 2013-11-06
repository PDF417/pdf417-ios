<p align="center" >
  <img src="https://raw.github.com/PDF417/pdf417-ios/assets/pdf417-git-logo.png" alt="pdf417 SDK for iOS" title="pdf417 SDK for iOS">
</p>

[![Build Status](https://travis-ci.org/PDF417/pdf417-ios.png)](https://travis-ci.org/PDF417/pdf417-ios)

pdf417 SDK for iOS is small and powerful tool for enabling barcode scanning in your apps. It's reliable, fast, and customizable. It's distributed as both framework and CococaPod so it's very easy to integrate. pdf417 SDK works on both iPhones and iPads on iOS 5.0 or later. Besides PDF417 format, SDK supports QR codes and all 1D barcodes.

## Integration

### Cocoapods

CocoaPods is the recommended way to add pdf417 SDK to your project.

1. Add a pod entry for PPpdf417 to your Podfile `pod 'PPpdf417',  '~> 1.4.0'`
2. Install the pod(s) by running `pod install`.
3. Go to classic integration step 3.

### Classic integration 

1. Drag the pdf417.embeddedframework into the Frameworks Group in your Xcode project. The framework
consists of code, headers, resources, strings, images and everything it needs to function properly.

2. Include the following frameworks and libraries into your project:
	- AVFoundation
	- AudioToolbox
	- CoreMedia
	- CoreVideo
	- CoreGraphics
	- libc++.dylib
	- libz.dylib
	- libiconv.dylib
	- OpenGLES
	- QuartzCore
	
3. In files in which you want to use barcode scanning, place import directive `#import <pdf417/PPBarcode.h>`

4. pdf417 framework uses it's own `CameraViewController` to present the UI. You should decide where you want to show this UI and write the following initialization code there. The initialization procedure consists of the following steps:

	First, it's appropriate to check if pdf417 scanning is supported and present some kind of message to the user if not (this can only happen in Simulator builds and on pre iPhone 3GS phones):
	
	```objective-c
	// Check if barcode scanning is supported
	NSError *error;
	if ([PPBarcodeCoordinator isScanningUnsupported:&error]) {
		NSString *messageString = [error localizedDescription];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                               		message:messageString
                                               	delegate:nil
                                	  	cancelButtonTitle:@"OK"
                                      	otherButtonTitles:nil, nil];
		[alert show];
		return;
	}
	```

	Then you need to setup pdf417 initialization parameters. Parameters are placed in a `NSMutableDictionary` object. 
	This is where you set which barcode formats are scanned (currently PDF417, QR code and 1D barcode types) and where you can set language used in pdf417 framework.  

	```objective-c
	// Create object which stores pdf417 framework settings
	NSMutableDictionary* coordinatorSettings = [[NSMutableDictionary alloc] init];

	// Set YES/NO for scanning pdf417 barcode standard (default YES)
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizePdf417Key];
    
	// Set YES/NO for scanning qr code barcode standard (default NO)
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeQrCodeKey];

	// Set YES/NO for scanning all 1D barcode standards (default NO). Use this if you're not sure
	// which barcode type you need to scan. Specific values for each barcode type (listed below)
	// overrides this value. This means that you can say YES for all 1D barcodes and set NO for
	// Code 128 and Code 39 to disable them.
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognize1DBarcodesKey];
    
	// Set YES/NO for scanning code 128 barcode standard (default NO)
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeCode128Key];
	
	// Set YES/NO for scanning code 39 barcode standard (default NO)
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeCode39Key];
	
	// Set YES/NO for scanning EAN 8 barcode standard (default NO)
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeEAN8Key];
	
	// Set YES/NO for scanning EAN 13 barcode standard (default NO)
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeEAN13Key];
	
	// Set YES/NO for scanning ITF barcode standard (default NO)
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeITFKey];
	
	// Set YES/NO for scanning UPCA barcode standard (default NO)
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeUPCAKey];
	
	// Set YES/NO for scanning UPCE barcode standard (default NO)
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeUPCEKey];
	```
	
	You can use pdf417 SDK free of change and without license key for development and non-commercial projects. Once you obtain a commercial license key from [www.pdf417.mobi](www.pdf417.mobi), you can set it like this:
   
	```objective-c
	// Set the license key
	[coordinatorSettings setValue:@"Enter_License_Key_Here" forKey:kPPLicenseKey];
	```
    
    You can also set the resolution which you would like to use for barcode scanning. There are four different options, but you should set only one:
    
	```objective-c
	// Set only one resolution mode
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPUseVideoPreset640x480];
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPUseVideoPresetMedium];
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPUseVideoPresetHigh];
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPUseVideoPresetHighest];	
	```
    
    As a rule of thumb, use the following values:
    
    1. For PDF417 barcodes with 15 or more columns, use `kPPUseVideoPresetHighest`. If you support iPhone 4, use this value also for barodes with 10 or more columns.
    2. For PDF417 with 5 or less columns, use `kPPUseVideoPreset640x480`
    3. Otherwise, it's recommended to use `kPPUseVideoPresetHigh`. This is also the default value.
    
    If the license key is valid for your application, this will automatically unlock the pdf417 SDK, remove the watermark from the camera view and enable all features to be used in your app.
		
    There are more, optional settings values. For example:

	```objective-c
	// present modal (recommended and default) - make sure you dismiss the view controller when done
	// you also can set this to NO and push camera view controller to navigation view controller 
	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPPresentModal];
    
	// You can set orientation mask for allowed orientations, default is UIInterfaceOrientationMaskAll
	[coordinatorSettings setValue:[NSNumber numberWithInt:UIInterfaceOrientationMaskAll] forKey:kPPHudOrientation];
	
	// Define the sound filename played on successful recognition
	NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
	[coordinatorSettings setValue:soundPath forKey:kPPSoundFile];
	```
    	
    Also, this is where you can set language used in pdf417 SDK, this can currently be only `en` (English), `de` (German) and `hr` (Croatian). Other languages can be supported on demand. If you don't specify the language, default user language will be used, so use this feature according to your application's localization strategy.
    
	```objective-c
	// Set the language. You can use "en", "de", "hr", if not specified, phone default will be used.
	// Use this according to your app localization strategy
	[coordinatorSettings setValue:@"en" forKey:kPPLanguage];
	```
		
    Now you can initialize `PPBarcodeCoordinator` object and use it to create `PPCameraViewController` which controls scanning UI. You can present it on navigation view controller or modally, whichever suits you best.

	```objective-c
	// Allocate the recognition coordinator object
	PPBarcodeCoordinator *coordinator = [[PPBarcodeCoordinator alloc] initWithSettings:coordinatorSettings];
	[coordinatorSettings release];

	// Create camera view controller
	UIViewController *cameraViewController = [coordinator cameraViewControllerWithDelegate:self];

	// present it modally
	cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:cameraViewController animated:YES completion:nil];
    
	[coordinator release];
	```

5. In the last step, you had to create `CameraViewController` with a delegate object. This object gets notified on certain events in pdf417 scanning lifecycle. In this example we set it to `self`, but any object can be used. The protocol which the delegate has to implement is `PPBarcodeDelegate` protocol and it consists of 2 required methods:
		
	```objective-c
	/**
 	 * Barcode library was closed. 
 	 *
 	 * This is where the Barcode library's UIViewController should be dismissed
 	 * if it's presented modally.
 	 */
 	- (void)cameraViewControllerWasClosed:(UIViewController*)cameraViewController;

	/**
 	 * Barcode library obtained a valid result. Do your next steps here.
 	 *
 	 * Depending on how you want to treat the result, you might want to
  	 * dismiss the Barcode library's UIViewController here.
 	 */
 	- (void)cameraViewController:(UIViewController*)cameraViewController
 	              obtainedResult:(PPScanningResult*)result;
	```
				 
	For example, your implementation of these methods can be (if you presented camera view controller modally):

	```objective-c
	- (void)cameraViewControllerWasClosed:(UIViewController *)cameraViewController {
		[self dismissViewControllerAnimated:YES completion:nil];
	}

	- (void)cameraViewController:(UIViewController *)cameraViewController 
			      obtainedResult:(PPScanningResult *)result {

		NSString *message = [[NSString alloc] initWithData:[result data] encoding:NSUTF8StringEncoding];

		if (message == nil) {
			message = [[NSString alloc] initWithData:[result data] encoding:NSASCIIStringEncoding];
		}

		// log the result
		NSLog(@"Barcode text:\n%@", message);

		NSString* type = @"Result:";
		if ([result type] == PPScanningResultPdf417) {
			type = @"PDF417:";
		} else if ([result type] == PPScanningResultQrCode) {
			type = @"QR Code:";
		}

		// log the barcode type
		NSLog(@"Barcode type:\n%@", type);

		[self setScanResult:result];
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	```
		
6. The package contains the framework and a sample application you can easily run to see how integration works in practice.

## Retrieving scanning results
		
Recognition results are returned via `PPScanningResult` object. You use this object to read barcode type and barcode data.

`PPScanningResult` has a field named `type` which is enum (identification) of the type of the barcode which was scanned. This can currently be one of the following values:

   - PPScanningResultPdf417,
   - PPScanningResultQrCode,
   - PPScanningResultLicenseInfo,
   - PPScanningResultCode128,
   - PPScanningResultCode39,
   - PPScanningResultEAN13,
   - PPScanningResultEAN8,
   - PPScanningResultITF,
   - PPScanningResultUPCA,
   - PPScanningResultUPCE,

The field named `data` contains the bytes scanned from the actual barcode. These are raw bytes which are written in the barcode. No encoding for this is assumed, since this is a responsibility of the user of the library. This byte array is guaranteed to terminate with `\0` character, so you can safely convert it to string.

Since barcode can contain various data types besides strings, you can use the field `rawData` to obtain more detailed information from the barcode. This field is used to obtain images and other raw binary information encoded in the barcode.

`rawData` field is of a type `PPBarcodeDetailedData` which contains field `barcodeElements`. This is a `NSArray` that contains elements of type `PPBarcodeElement`. Each `PPBarcodeElement` contains two fields: `elementType`, which is enum (identification) of the type of that element and `elementBytes`, which contains raw byte data. Identification of the type can be `PPTextElement` or `PPByteElement`. 

If the type is `PPTextElement`, this means that data in field `elementBytes` can be safely understood as string. If the type is `PPByteElement`, the data in field `elementBytes` is arbitrary binary data. Of course, you can always interpret both element types as string, if you like so. In such case, you would get the same information as with the `data` field of the `PPScanningResult`  object

If you are able to decode raw data without the need of elaborate structure information, then you can send message `getAllData` to object of type `PPBarcodeDetailedData`. Twhis will return `NSData` that will contain raw bytes of whole barcode.

## Using ARC

pdf417 Framework is ARC agnostic which means you can safely use it in your ARC projects. Just follow the rules described in [ARC release notes](https://developer.apple.com/library/ios/#releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html)  and you'll be fine. This means you just need to remove retain/release calls from above code and use default strong ARC references.

## Replacing resource files and localization

All resource files in pdf417 framework can be changed. For example, you can change or add new localisation resource files. Localisation resource files are named {country-code}.strings. (e.g. en.strings, de.strings..). These files contain strings in format "key" = "value";. In code pdf417 framework uses only "key" values, which are in runtime translated to correct "value".

Modifying strings files is the same as modifying any other resource file.

1. Find the strings file file in the Xcode (by expanding Frameworks group, pdf417.embeddedframework subgroup under Resources)
2. Right click it and select delete option. When asked, choose Remove reference option.
3. Add a new strings file with the same name. You can use the en.strings, de.strings and hr.strings files from the development packages as a template.
4. Test to see that everything works as it should!

pdf417 framework at runtime decides which language it should use by observing the flag you set while initializing the Coordinator object. For the reminder, the flag is:

```objective-c
// Set the language. You can use "en", "de", "hr", if not specified, phone default will be used.
// Use this according to your app localization strategy
[coordinatorSettings setValue:@"en" forKey:kPPLanguage];
```
    	
## How to license pdf417.mobi framework for your commercial project

We want pdf417.mobi framework to be your first choice for scanning barcodes in your iOS or Android apps. That's why we enable you to use pdf417.mobi completely free of charge in your development phase or in non commercial projects, for as many developers as you need. To obtain commercial license, follow the simple steps defined on our website [www.pdf417.mobi](www.pdf417.mobi).

## Credits

pdf417 SDK was created for PhotoPay project by [PhotoPay Ltd.](http://photopay.net). It powers several mobile banking apps like:

- [Erste Bank netbanking app for Erste Bank Austria](https://itunes.apple.com/at/app/erste-bank-sparkasse-osterreich/id437840915?mt=8)
- [Erste mBanking app for Erste Bank Croatia](https://itunes.apple.com/us/app/erste-mbanking/id477066660?mt=8)
- [m-Hypo:-) app for Hypo Alpe-Adria-Bank Croatia](https://itunes.apple.com/us/app/m-hypo/id529756500?mt=8).
- [RBA na dlanu app for Raiffeisenbank Austria d.d.](https://itunes.apple.com/us/app/rba-na-dlanu/id450788819).

## Contact

For any inquiries, additional information or instructions please contact us at <pdf417@photopay.net> our follow our page on Twitter ([@417pdf](https://twitter.com/417pdf)).
