<p align="center" >
  <img src="https://raw.github.com/PDF417/pdf417-ios/assets/pdf417-git-logo.png" alt="pdf417 SDK for iOS" title="pdf417 SDK for iOS">
</p>

[![Build Status](https://travis-ci.org/PDF417/pdf417-ios.png)](https://travis-ci.org/PDF417/pdf417-ios)

pdf417 SDK for iOS is small and powerful tool for enabling barcode scanning in your apps. It's reliable, fast, and customizable. It's distributed as both framework and CococaPod so it's very easy to integrate. pdf417 SDK works on both iPhones and iPads on iOS 5.1.1 or later. 

The SDK supports pdf417 barcodes, QR codes, 1D Barcodes, as well as scanning and parsing data from USA drivers licenses (USDL).

SDK offers very easy way of defining custom scanning user interfaces.

For more info, visit [http://pdf417.mobi](http://pdf417.mobi).

Important: if you require deployment targets older than iOS 5.1.1 please contact us on <pdf417@photopay.net>. We can support iOS 4.3 and newer on demand.

This document is structured as follows:

1. [Integration](#0100)
	- [Cocoapods](#0101)
	- [Classic integration](#0102)
2. [Retrieving scanning results](#0200)
	- [Barcode results](#0201)
	- [US Driver's License results](#0202)
3. [Setting scanning region](#0300)
4. [Using ARC](#0400)
5. [Custom user interface](#0500)
6. [Resource files and localization](#0600)
7. [Licensing pdf417.mobi framework for commercial projects](#0700)
8. [Credits](#0800)
9. [Contact](#0900)

## <a name="0100"></a> Integration

### <a name="0101"></a> Cocoapods

CocoaPods is the recommended way to add pdf417 SDK to your project.

1. Add a pod entry for PPpdf417 to your Podfile `pod 'PPpdf417',  '~> 3.1.0'`
2. Install the pod(s) by running `pod install`.
3. Go to classic integration step 3.

### <a name="0102"></a> Classic integration

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
		return nil;
	}
	```
	
	Then you need to setup pdf417 initialization parameters. Parameters are placed in a `NSMutableDictionary` object. 
	This is where you set which barcode formats are scanned (currently US Drivers licenses, PDF417, QR code and 1D barcode types) and where you can set language used in pdf417 framework.  

	```objective-c
	// Create object which stores pdf417 framework settings
	NSMutableDictionary* coordinatorSettings = [[NSMutableDictionary alloc] init];
	
	// Set YES/NO for scanning pdf417 barcode standard (default YES, if available by license)
	[coordinatorSettings setValue:@(YES) forKey:kPPRecognizePdf417Key];
	
	// Set YES/NO for scanning qr code barcode standard (default NO)
	[coordinatorSettings setValue:@(YES) forKey:kPPRecognizeQrCodeKey];
	
	// Set YES/NO for scanning US drivers license barcode standards (default YES, if available by license)
	[coordinatorSettings setValue:@(NO) forKey:kPPRecognizeUSDLKey];
	
	// Set YES/NO for scanning all 1D barcode standards (default NO). Use this if you're not sure
	// which barcode type you need to scan. Specific values for each barcode type (listed below)
	// overrides this value. This means that you can say YES for all 1D barcodes and set NO for
	// Code 128 and Code 39 to disable them.
	[coordinatorSettings setValue:@(YES) forKey:kPPRecognize1DBarcodesKey];
	
	// Set YES/NO for scanning code 128 barcode standard (default NO)
	[coordinatorSettings setValue:@(YES) forKey:kPPRecognizeCode128Key];
	
	// Set YES/NO for scanning code 39 barcode standard (default NO)
	[coordinatorSettings setValue:@(YES) forKey:kPPRecognizeCode39Key];
	
	// Set YES/NO for scanning EAN 8 barcode standard (default NO)
	[coordinatorSettings setValue:@(YES) forKey:kPPRecognizeEAN8Key];
	
	// Set YES/NO for scanning EAN 13 barcode standard (default NO)
	[coordinatorSettings setValue:@(YES) forKey:kPPRecognizeEAN13Key];
	
	// Set YES/NO for scanning ITF barcode standard (default NO)
	[coordinatorSettings setValue:@(YES) forKey:kPPRecognizeITFKey];
	
	// Set YES/NO for scanning UPCA barcode standard (default NO)
	[coordinatorSettings setValue:@(YES) forKey:kPPRecognizeUPCAKey];
	
	// Set YES/NO for scanning UPCE barcode standard (default NO)
	[coordinatorSettings setValue:@(YES) forKey:kPPRecognizeUPCEKey];
	
	// Set YES/NO for scanning Aztec barcode standard (default NO)
	[coordinatorSettings setValue:@(NO) forKey:kPPRecognizeAztecKey];
	
	// Set YES/NO for scanning DataMatrix barcode standard (default NO)
	[coordinatorSettings setValue:@(NO) forKey:kPPRecognizeDataMatrixKey];
	```
	
	You can use pdf417 SDK free of change and without license key for development and non-commercial projects. Once you obtain a commercial license key from [www.pdf417.mobi](www.pdf417.mobi), you can set it like this:
	
	```objective-c
	/**
	 Set your license key here.
	 This license key allows setting overlay views for this application ID: net.photopay.barcode.pdf417-sample
	 To test your custom overlays, please use this demo app directly or visit our website www.pdf417.mobi for commercial license
	 */
	[coordinatorSettings setValue:@"Enter_License_Key_Here" forKey:kPPLicenseKey];
		
	/**
	 If you use enterprise license, set the owner name of the licese.
	 If you use regular per app license, leave this line commented.
	 */
	// [coordinatorSettings setValue:@"Owner name" forKey:kPPLicenseOwner];
	```
	
	You can also set the resolution which you would like to use for barcode scanning. There are four different options, but you should set only one:
	
	```objective-c
	// There are 4 resolution modes:
	//      kPPUseVideoPreset640x480
	//      kPPUseVideoPresetMedium
	//      kPPUseVideoPresetHigh
	//      kPPUseVideoPresetHighest
	//      kPPUseVideoPresetPhoto
	// Set only one.
	[coordinatorSettings setValue:@(YES) forKey:kPPUseVideoPresetHigh];
	```
	
    As a rule of thumb, use the following values:
    
    1. For PDF417 barcodes with 15 or more columns, use `kPPUseVideoPresetHighest`.
    2. For PDF417 with 5 or less columns, use `kPPUseVideoPreset640x480`
    3. Otherwise, it's recommended to use `kPPUseVideoPresetHigh`. This is also the default value.
    4. Only if that's your unavoidable requirement, use `kPPUseVideoPresetPhoto`
    
    If the license key is valid for your application, this will automatically unlock the pdf417 SDK, remove the watermark from the camera view and enable all features to be used in your app.
		
    There are more, optional settings values. For example:

	```objective-c
	// present modal (recommended and default) - make sure you dismiss the view controller when done
	// you also can set this to NO and push camera view controller to navigation view controller 
	[coordinatorSettings setValue:@(YES) forKey:kPPPresentModal];
	
	// Set this if you want to use front facing camera
	[coordinatorSettings setValue:@(NO) forKey:kPPUseFrontFacingCamera];
	
	// Set this to true to scan even barcode not compliant with standards
	// For example, malformed PDF417 barcodes which were incorrectly encoded
	// Use only if necessary because it slows down the recognition process
	[coordinatorSettings setValue:@(YES) forKey:kPPScanUncertainBarcodes];
	
	// Use automatic scale detection feature. This normally should not be used.
	// The only situation where this helps in getting better scanning results is
	// when using kPPUseVideoPresetPhoto on iPad devices.
	// Video preview resoution of 2045x1536 in that case is very large and autoscale helps.
	[coordinatorSettings setValue:@(NO) forKey:kPPUseAutoscaleDetection];
	
	// Set this to true to scan barcodes which don't have quiet zone (white area) around it
	// Use only if necessary because it slows down the recognition process
	[coordinatorSettings setValue:@(YES) forKey:kPPAllowNullQuietZone];
	
	// Set this to true to allow scanning barcodes with inverted intensities (i.e. white barcodes on black background)
	// NOTE: this options doubles the frame processing time
	[coordinatorSettings setValue:@(YES) forKey:kPPAllowInverseBarcodes];
	
	// if for some reason overlay should not autorotate
	// for example, if Navigation View controller on which Camera is presented handles rotation by itself
	// of when FormSheet or PageSheet modal view is used on iPads
	// then, disable rotation for overlays. Use this carefully.
	// Autorotation is YES by defalt
	[coordinatorSettings setValue:@(YES) forKey:kPPOverlayShouldAutorotate];
		
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
	
	// Create camera view controller
	UIViewController *cameraViewController = [coordinator cameraViewControllerWithDelegate:self];
	
	// present it modally
	cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:cameraViewController animated:YES completion:nil];
	```
	
5. In the last step, you had to create `CameraViewController` with a delegate object. This object gets notified on certain events in pdf417 scanning lifecycle. In this example we set it to `self`, but any object can be used. The protocol which the delegate has to implement is `PPBarcodeDelegate` protocol and it consists of 2 required methods:
	
	```objective-c	
	/**
	 * Barcode library was closed. 
	 *
	 * This is where the Barcode library's UIViewController should be dismissed
	 * if it's presented modally.
	 */
	- (void)cameraViewControllerWasClosed:(UIViewController<PPScanningViewController>*)cameraViewController;
	
	/**
	 * Barcode library did output scanning results. Do your next steps here.
	 *
	 * Depending on how you want to treat the result, you might want to
	 * dismiss the Barcode library's UIViewController here.
	 *
	 * This method is the default way for getting access to results of scanning.
	 *
	 * Note: 
	 * - there may be more 0, 1, or more than one scanning results.
	 * - each scanning result belongs to a common PPBaseResult type. Check it's property resultType to get the actual type
	 * - handle different types differently
	 * 
	 * @see PPBaseResult
	 * @see PPScanningResult
	 * @see PPUSDLResult
	 */
	- (void)cameraViewController:(UIViewController<PPScanningViewController>*)cameraViewController
			didOutputResults:(NSArray*)results;
	```
			 
	For example, your implementation of these methods can be (if you presented camera view controller modally):
	
	```objective-c
	- (void)cameraViewControllerWasClosed:(id<PPScanningViewController>)cameraViewController {
		// this stops the scanning and dismisses the camera screen
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	
	- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController
				didOutputResults:(NSArray *)results {
		for (PPBaseResult* result in results) {
		        if ([result resultType] == PPBaseResultTypeBarcode && [result isKindOfClass:[PPScanningResult class]]) {
		            PPScanningResult* scanningResult = (PPScanningResult*)result;
		            [self processScanningResult:scanningResult cameraViewController:cameraViewController];
		        }
		
		        if ([result resultType] == PPBaseResultTypeUSDL && [result isKindOfClass:[PPUSDLResult class]]) {
		            PPUSDLResult* usdlResult = (PPUSDLResult*)result;
		            [self processUSDLResult:usdlResult cameraViewController:cameraViewController];
		        }
	    };
	}
	```
		
	Optionally, you can implement a callback which gives you the image which resulted with a successfull scan. Sometimes it makes sense to present the image to the user, but that depends on the use case.
	
	```objective-c
	- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController
	didMakeSuccessfulScanOnImage:(UIImage *)image {
	    [[self imageView] setImage:image];
	}
	```
	
## <a name="0200"></a> Retrieving scanning results

Recognition results are returned via `PPBaseResult` object. Use this object's `resultType` property to see the exact type of returned result. 		

For now, `resultType` can be one of two possible values:

- `PPBaseResultTypeBarcode`	- in this case returned result object is actually of type `PPScanningResult`, so you can safely cast it. See the section on PPScanningResults for more details on how to get information from it.
- `PPBaseResultTypeUSDL` - in this case returned object is of type `PPUSDLResult`. You can safely cast it. See section on PPUSDLResults for more details.

## <a name="0201"></a> Barcode results

#### Result type

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
   
#### Result bytes

The field named `data` contains the bytes scanned from the actual barcode. These are raw bytes which are written in the barcode. No encoding for this is assumed, since this is a responsibility of the user of the library. This byte array is guaranteed to terminate with `\0` character, so you can safely convert it to string.

Since barcode can contain various data types besides strings, you can use the field `rawData` to obtain more detailed information from the barcode. This field is used to obtain images and other raw binary information encoded in the barcode.

#### Raw barcode elements (for non-textual data, images, encrypted values etc.)

`rawData` field is of a type `PPBarcodeDetailedData` which contains field `barcodeElements`. This is a `NSArray` that contains elements of type `PPBarcodeElement`. Each `PPBarcodeElement` contains two fields: `elementType`, which is enum (identification) of the type of that element and `elementBytes`, which contains raw byte data. Identification of the type can be `PPTextElement` or `PPByteElement`. 

If the type is `PPTextElement`, this means that data in field `elementBytes` can be safely understood as string. If the type is `PPByteElement`, the data in field `elementBytes` is arbitrary binary data. Of course, you can always interpret both element types as string, if you like so. In such case, you would get the same information as with the `data` field of the `PPScanningResult`  object

If you are able to decode raw data without the need of elaborate structure information, then you can send message `getAllData` to object of type `PPBarcodeDetailedData`. Twhis will return `NSData` that will contain raw bytes of whole barcode.

#### Uncertain barcodes

`isUncertain` field is of a type BOOL. If this value is `YES`, this means that the scanning library found the result, but the scanned barcode is malformed, or not encoded according to a barcode standard.

If this value is `YES`, we advise you to perform some kind of integrity check on the obtained value. If the value doesn't pass your integration test, you can present the user some kind of message, or simply continue scanning until the your integration test has passed.


#### Exact barcode location on image

Each `PPBaseResult` object has a property `locationOnImage` which gives the exact position of the result on a video frame used in the recognition process.

```objective-c
/**
  Corner points of detected result. Points are given in image coordinate system
  (0, 0) - top left point on the image, (width, height) bottom right point on the image
  */
@property (nonatomic, retain) NSArray* locationOnImage;
```
	
Due to performance implications of passing video frames back-and-forth in the public API, this property can currently be used only in combination with `cameraViewController:didMakeSuccessfulScanOnImage:` method of `PPBarcodeDelegate` object. So, if you need to get the exact part of the image which resulted with successful scan, do the following:

1. Implement `cameraViewController:didMakeSuccessfulScanOnImage:` and store the UIimage object
2. in the `cameraViewController:didOutputResults:` find out the exact positions of results using `locationOnImage` property. Implement your handling after that using the stored UIImage object.  

### <a name="0202"></a> US Driver's License results

Documentation about obtaining data from scanned US Driver's licenses can be obtained in a separate document [DriversLicenses](DriversLicenses.md).

## <a name="0300"></a> Setting scanning region

You have two options for setting scanning regions.

1. If you use default camera overlay, i.e. for initializing cameraViewController you use:

	```objective-c
	// Create camera view controller
	UIViewController<PPScanningViewController>* cameraViewController = [coordinator cameraViewControllerWithDelegate:self];
	```
	
	in that case, set the scanning region in coordinatorSettings dictionary, like this:

	```objective-c
	// Set the scanning region, if necessary
	[coordinatorSettings setValue:[NSValue valueWithCGRect:CGRectMake(0.05, 0.05, 0.9, 0.9)] forKey:kPPScanningRoi];
	```
	
2. If you use custom camera overlay, you can set it's scanningRegion property, for example in `viewWillAppear:`

	```objective-c
	[self setScanningRegion:CGRectMake(0.15, 0.4, 0.7, 0.2)];
	```
	
You must specify CGRect object, where origin (0, 0), specifies upper left corner of the Overlay view. When Overlay view is in portrait, this corresponds to the upper left corner of the device screen.

## <a name="0400"></a> Using ARC

pdf417 Framework is ARC agnostic so you can safely use it in Both ARC and non-ARC projects. The sample code is given with ARC enabled, to adapt it in non-ARC environments, just add memory management code with [ARC guidelines](https://developer.apple.com/library/ios/#releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html)

## <a name="0500"></a> Custom user interface

Tips on producing custom Camera Overlay user interfaces can be found in separate document [CustomUI](CustomUI.md).

## <a name="0600"></a> Resource files and localization

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
    	
## <a name="0700"></a> Licensing pdf417.mobi framework for commercial projects

We want pdf417.mobi framework to be your first choice for scanning barcodes in your iOS or Android apps. That's why we enable you to use pdf417.mobi completely free of charge in your development phase or in non commercial projects, for as many developers as you need. To obtain commercial license, follow the simple steps defined on our website [www.pdf417.mobi](http://www.pdf417.mobi).

## <a name="0800"></a> Credits

pdf417 SDK was created for PhotoPay project by [PhotoPay Ltd.](http://photopay.net). It powers several mobile banking apps like:

- [Erste Bank netbanking app for Erste Bank Austria](https://itunes.apple.com/at/app/erste-bank-sparkasse-osterreich/id437840915?mt=8)
- [Erste mBanking app for Erste Bank Croatia](https://itunes.apple.com/us/app/erste-mbanking/id477066660?mt=8)
- [m-Hypo:-) app for Hypo Alpe-Adria-Bank Croatia](https://itunes.apple.com/us/app/m-hypo/id529756500?mt=8).
- [RBA na dlanu app for Raiffeisenbank Austria d.d.](https://itunes.apple.com/us/app/rba-na-dlanu/id450788819).

For more references, visit [www.pdf417.mobi](http://www.pdf417.mobi).

## <a name="0900"></a> Contact

For any inquiries, additional information or instructions please contact us at <pdf417@photopay.net> our follow our page on Twitter ([@417pdf](https://twitter.com/417pdf)).

