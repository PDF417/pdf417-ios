<p align="center" >
  <img src="https://raw.github.com/PDF417/pdf417-ios/assets/pdf417-git-logo.png" alt="pdf417 SDK for iOS" title="pdf417 SDK for iOS">
</p>

[![Build Status](https://travis-ci.org/PDF417/pdf417-ios.png)](https://travis-ci.org/PDF417/pdf417-ios)

pdf417 SDK for iOS is small and powerful tool for enabling barcode scanning in your apps. It's reliable, fast, and customizable. It's distributed as both framework and CococaPod so it's very easy to integrate. pdf417 SDK works on both iPhones and iPads on iOS 5.1.1 or later. Besides PDF417 format, SDK supports QR codes and all 1D barcodes.

For more info visit http://pdf417.mobi

Important: if you require deployment targets older than iOS 5.1.1 please contact us on <pdf417@photopay.net>. We can support iOS 4.3 and newer on demand.

This document is structured as follows:

1. [Integration](#0100)
	- [Cocoapods](#0101)
	- [Classic integration](#0102)
2. [Retrieving scanning results](#0200)
	- [Barcode results](#0201)
3. [Setting scanning region](#0300)
4. [Using ARC](#0400)
5. [Custom user interface](#0500)
	- [Initialization](#0501)
	- [Interaction with CameraViewController](#0502)
	- [Notifications passed to CameraViewController](#0503)
	- [Handling orientation changes](#0504)
	- [Steps for providing custom Camera Overlay View](#0505)
6. [Resource files and localization](#0600)
7. [Licensing pdf417.mobi framework for commercial projects](#0700)
8. [Credits](#0800)
9. [Contact](#0900)

## <a name="0100"></a> Integration

### <a name="0101"></a> Cocoapods

CocoaPods is the recommended way to add pdf417 SDK to your project.

1. Add a pod entry for PPpdf417 to your Podfile `pod 'PPpdf417',  '~> 3.0.0'`
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
	
	Then you need to setup pdf417 initialization parameters. Parameters are placed in a `NSMutableDictionary` object. 
	This is where you set which barcode formats are scanned (currently US Drivers licenses, PDF417, QR code and 1D barcode types) and where you can set language used in pdf417 framework.  

		// Create object which stores pdf417 framework settings
		NSMutableDictionary* coordinatorSettings = [[NSMutableDictionary alloc] init];
		
		// Set YES/NO for scanning US drivers license barcode standards (default YES, if available by license)
    	[coordinatorSettings setValue:@(YES) forKey:kPPRecognizeUSDLKey];

		// Set YES/NO for scanning pdf417 barcode standard (default YES, if available by license)
		[coordinatorSettings setValue:@(YES) forKey:kPPRecognizePdf417Key];
    
		// Set YES/NO for scanning qr code barcode standard (default NO)
		[coordinatorSettings setValue:@(YES) forKey:kPPRecognizeQrCodeKey];

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
	
	You can use pdf417 SDK free of change and without license key for development and non-commercial projects. Once you obtain a commercial license key from [www.pdf417.mobi](www.pdf417.mobi), you can set it like this:
   
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
	
    You can also set the resolution which you would like to use for barcode scanning. There are four different options, but you should set only one:
    
		// There are 4 resolution modes:
    	//      kPPUseVideoPreset640x480
    	//      kPPUseVideoPresetMedium
    	//      kPPUseVideoPresetHigh
    	//      kPPUseVideoPresetHighest
    	// 		kPPUseVideoPresetPhoto
    	// Set only one.
    	[coordinatorSettings setValue:@(YES) forKey:kPPUseVideoPresetHigh];	
	
    As a rule of thumb, use the following values:
    
    1. For PDF417 barcodes with 15 or more columns, use `kPPUseVideoPresetHighest`.
    2. For PDF417 with 5 or less columns, use `kPPUseVideoPreset640x480`
    3. Otherwise, it's recommended to use `kPPUseVideoPresetHigh`. This is also the default value.
    4. Only if that's your unavoidable requirement, use `kPPUseVideoPresetPhoto`
    
    If the license key is valid for your application, this will automatically unlock the pdf417 SDK, remove the watermark from the camera view and enable all features to be used in your app.
		
    There are more, optional settings values. For example:

		// present modal (recommended and default) - make sure you dismiss the view controller when done
		// you also can set this to NO and push camera view controller to navigation view controller 
		[coordinatorSettings setValue:@(YES) forKey:kPPPresentModal];
	
		// Set this if you want to use front facing camera
		[coordinatorSettings setValue:@(YES) forKey:kPPUseFrontFacingCamera];
	
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
		
    Also, this is where you can set language used in pdf417 SDK, this can currently be only `en` (English), `de` (German) and `hr` (Croatian). Other languages can be supported on demand. If you don't specify the language, default user language will be used, so use this feature according to your application's localization strategy.
    
		// Set the language. You can use "en", "de", "hr", if not specified, phone default will be used.
		// Use this according to your app localization strategy
		[coordinatorSettings setValue:@"en" forKey:kPPLanguage];
		
    Now you can initialize `PPBarcodeCoordinator` object and use it to create `PPCameraViewController` which controls scanning UI. You can present it on navigation view controller or modally, whichever suits you best.

		// Allocate the recognition coordinator object
		PPBarcodeCoordinator *coordinator = [[PPBarcodeCoordinator alloc] initWithSettings:coordinatorSettings];
		[coordinatorSettings release];

		// Create camera view controller
		UIViewController *cameraViewController = [coordinator cameraViewControllerWithDelegate:self];

		// present it modally
		cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		[self presentViewController:cameraViewController animated:YES completion:nil];
    
		[coordinator release];
	
5. In the last step, you had to create `CameraViewController` with a delegate object. This object gets notified on certain events in pdf417 scanning lifecycle. In this example we set it to `self`, but any object can be used. The protocol which the delegate has to implement is `PPBarcodeDelegate` protocol and it consists of 2 required methods:
		
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
				 
	For example, your implementation of these methods can be (if you presented camera view controller modally):
	
		- (void)cameraViewControllerWasClosed:(id<PPScanningViewController>)cameraViewController {
			// this stops the scanning and dismisses the camera screen
			[self dismissViewControllerAnimated:YES completion:nil];
		}
		
		- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController
					didOutputResults:(NSArray *)results {
    		[results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    			if ([obj isKindOfClass:[PPBaseResult class]]) {
    				PPBaseResult* result = (PPBaseResult*)obj;
    				if ([result resultType] == PPBaseResultTypeBarcode && [result isKindOfClass:[PPScanningResult class]]) {
                		PPScanningResult* scanningResult = (PPScanningResult*)result;
                		[self processScanningResult:scanningResult cameraViewController:cameraViewController];
            		}
            		if ([result resultType] == PPBaseResultTypeUSDL && [result isKindOfClass:[PPUSDLResult class]]) {
                		PPUSDLResult* usdlResult = (PPUSDLResult*)result;
                		[self processUSDLResult:usdlResult cameraViewController:cameraViewController];
            		}
        		}
    		}];
		}
		
	Optionally, you can implement a callback which gives you the image which resulted with a successfull scan. Sometimes it makes sense to present the image to the user, but that depends on the use case.
	
		- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController
		didMakeSuccessfulScanOnImage:(UIImage *)image {
    		[[self imageView] setImage:image];
		}
	
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

	/**
 	 Corner points of detected result. Points are given in image coordinate system
 	 (0, 0) - top left point on the image, (width, height) bottom right point on the image
 	 */
	@property (nonatomic, retain) NSArray* locationOnImage;
	
Due to performance implications of passing video frames back-and-forth in the public API, this property can currently be used only in combination with `cameraViewController:didMakeSuccessfulScanOnImage:` method of `PPBarcodeDelegate` object. So, if you need to get the exact part of the image which resulted with successful scan, do the following:

1. Implement `cameraViewController:didMakeSuccessfulScanOnImage:` and store the UIimage object
2. in the `cameraViewController:didOutputResults:` find out the exact positions of results using `locationOnImage` property. Implement your handling after that using the stored UIImage object.  

## <a name="0300"></a> Setting scanning region

You have two options for setting scanning regions.

1. If you use default camera overlay, i.e. for initializing cameraViewController you use:

		// Create camera view controller
		UIViewController<PPScanningViewController>* cameraViewController = [coordinator cameraViewControllerWithDelegate:self];
	
	then set the scanning region in coordinatorSettings dictionary, like this:

		// Set the scanning region, if necessary
		[coordinatorSettings setValue:[NSValue valueWithCGRect:CGRectMake(0.05, 0.05, 0.9, 0.9)] forKey:kPPScanningRoi];
	
2. If you use custom camera overlay, you can set it's scanningRegion property, for example in `viewWillAppear:`

	[self setScanningRegion:CGRectMake(0.15, 0.4, 0.7, 0.2)];
	
You must specify CGRect object, where origin (0, 0), specifies upper left corner of the Overlay view. When Overlay view is in portrait, this corresponds to the upper left corner of the device screen.

## <a name="0400"></a> Using ARC

pdf417 Framework is ARC agnostic which means you can safely use it in your ARC projects. Just follow the rules described in [ARC release notes](https://developer.apple.com/library/ios/#releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html)  and you'll be fine. This means you just need to remove retain/release calls from above code and use default strong ARC references.

## <a name="0500"></a> Custom user interface

Overlay View Controller is an abstract class for all overlay views placed on top PhotoPay's Camera View Controller.

It's responsibility is to provide meaningful and useful interface for the user to interact with.
 
Typical actions which need to be allowed to the user are:

- intuitive and meaniningful way to guide the user through scanning process. This is usually done by presenting a "viewfinder" in which the user need to place the scanned object
- a way to cancel the scanining, typically with a "cancel" or "back" button
- a way to power on and off the light (i.e. "torch") button
 
PhotoPay always provides it's own default implementation of the Overlay View Controller for every specific use. Your implementation should closely mimic the default implementation as it's the result of thorough testing with end users. Also, it closely matches the underlying scanning technology. 

For example, the scanning technology usually gives results very fast after the user places the device's camera in the expected way above the scanned object. This means a progress bar for the scan is not particularly useful to the user. The majority of time the user spends on positioning the device's camera correctly. That's just an example which demonstrates careful decision making behind default camera overlay view.

PhotoPay demo project in your development package contain `PPCameraOverlayViewController` class, an example of custom overlay view implementation.

### <a name="0501"></a> Initialization
 
To use your custom overlay with PhotoPay's camera view, you must subclass PPOverlayViewController and specify it when initializing CameraViewController:
 
    PPCameraOverlayViewController *overlayViewController = 
    	[[PPCameraOverlayViewController alloc] initWithNibName:@"PPCameraOverlayViewController" bundle:nil];
 
    // Create camera view controller
    UIViewController *cameraViewController = 
    	[coordinator cameraViewControllerWithDelegate:self overlayViewController:overlayViewController];
 
Note: if you create camera view controller without specifying overlay view, the default overlay implementation will be used:

	// Create camera view controller
	UIViewController *cameraViewController = 
		[coordinator cameraViewControllerWithDelegate:self];
	
As with any view controller, you are responsible for specifying UI elements and handling their actions. Besides that, there are some requirements for interaction with Camera View Controller. 

### <a name="0502"></a> Interaction with CameraViewController

CameraViewController is a Container view controller to the PPOverlayViewController instances. For more about Container View Controllers, read official Apple [View Controller Programming Guide].

Also, each instance of PPOverlayViewController and it's subclasses has access to the Container View Controller.

	/** 
 	 Overlay View's delegate object. Responsible for sending messages to PhotoPay's 
	 Camera View Controller
 	 */
	@property (nonatomic, assign) id<PPOverlayContainerViewController> containerViewController;

#### Events received from Container CameraViewController

PPCameraOverlayViewController gets notified by CameraViewController on various scanning events. Here is a list of all events and the methods which get called in turn:

1. Camera view appears and the scanning resumes. This happens when the camera view is opened, or when the app enters foreground with camera view displayed. The method called on this event is

		- (void)cameraViewControllerDidResumeScanning:(id<PPScanningViewController>)cameraViewController;

2. Camera view disappears and the scanning pauses. This happens when the camera view is closed, or when the app enters background with camera view displayed. The method called on this event is
	
		- (void)cameraViewControllerDidStopScanning:(id<PPScanningViewController>)cameraViewController;
	
3. Camera view reports the progress of the current OCR/barcode scanning recognition cycle. Note: this is not the actual progress from the moment camera appears. This might not be meaningful for the user in all cases.

		- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
          	  	  didPublishProgress:(float)progress;
	
4. Camera view reports the status of the object detection. Scanning status contain information about whether the scan was successful, whether the user holds the device too far from the object, whether the angles was too high, or the object isn't seen on the camera in it's entirety. If the object was found, the corner points of the object are returned.

		- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
             		 didFindLocation:(NSArray*)cornerPoints
                  		  withStatus:(PPDetectionStatus)status;
                  		  
5. Camera view reports obtained OCR result. Besides the OCR result itself, we get the ID of the result so we can 
 distinguish consecutive results of the same area on the image
 
		- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
          		  didObtainOcrResult:(PPOcrResult*)ocrResult
                	  withResultName:(NSString*)resultName;
                       
6. Camera view controller started the new recognition cycle. Since recognition is done on video frames, there might be multiple recognition cycles before the scanning completes. Method which is called on this event is:

		- (void)cameraViewControllerDidStartRecognition:(id<PPScanningViewController>)cameraViewController;
               
7. Camera view controller ended the recognition cycle with a certain Scanning result. The scanning result cannot be considered as valid, sometimes here are received objects which contain only partial scanning information. Use this method only if you need UI update on this event (although this is unnecessary in many cases). If you're interested in valid data, use cameraViewController:didOutputResult: method.

		- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController 
		didFinishRecognitionWithResult:(id)result;

8. Camera view controller ended the recognition cycle with a list of results. The scanning results can be considered as valid, meaning it can be presented to the user for inspection. Also, note that the actual result will be passed to your PPPhotoPayDelegate object.

		- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
            	    didOutputResults:(NSArray*)results;

9. UIViewController's method called when a rotation to a given interface orientation is about to happen

		- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                		duration:(NSTimeInterval)duration;

10. UIViewController's method called immediately after the rotation from a given interface orientation happened

		- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;

11. UIViewController's method called inside an animation block. Any changes you make to your UIView's inside this method will be animated

		- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         		 duration:(NSTimeInterval)duration;

### <a name="0503"></a> Notifications passed to Container CameraViewController

Overlay View Controller also needs to notify CameraViewController on certain events. Those are events specified by `PPOverlayContainerViewController` protocol. 

Notification sent when Overlay View Controller wants to close camera, for example, by pressing Cancel button.

	- (void)overlayViewControllerWillCloseCamera:(PPOverlayViewController*)overlayViewController;

Overlay View Controller should ask it's delegete if it's necessary to display Torch (Light) button. Torch button is not necessary if the device doesn't support torch mode (e.g. iPad devices).

	- (BOOL)overlayViewControllerShouldDisplayTorch:(PPOverlayViewController*)overlayViewController;

Overlay View Controller must notify it's delegete to set the torch mode to On or Off

	- (void)overlayViewController:(id)overlayViewController
                 	 willSetTorch:(BOOL)isTorchOn;
                 	 
### Other information getters in `PPOverlayContainerViewController`
                 	 
Overlay View Controller should know if it's presented modally or on navigation view controller. Use this method to ask if it's necessary to display Cancel button. (When on navigation view controller, button back is presented by default). This method replaced old method overlayViewControllerShouldDisplayCancel.
	
	- (BOOL)isPresentedModally;

Overlay View Controller can ask it's delegete about the status of Torch

	- (BOOL)isTorchOn;

Overlay View Controller can get Video Capture Preview Layer object from it's delegete.

	- (AVCaptureVideoPreviewLayer*)getPreviewLayer;

### <a name="0504"></a> Handling orientation changes

Camera view controller is always presented in Portrait mode, but nevertheless, your overlay view be presented in the current device orientation. There are two ways to handle orientation changes.

The first, built in way is a simple way to achieve autorotation. Your Overlay View Controller only needs to implement standard UIViewController methods which specify which orientations are supported. For example, to support only landscape orientations, you need to add the following methods to your Overlay View Controller implementation.

	- (NSUInteger)supportedInterfaceOrientations {
    	return UIInterfaceOrientationMaskLandscape;
	}

	- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    	return UIInterfaceOrientationLandscapeRight;
	}

	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
	}
	
Your Overlay View Controller will automatically rotate to support all orientations returned by `supportedInterfaceOrientations` method. You are responsible for standard iOS techniques (auto-layout or autoresizing masks) to adjust the UI to new device orientation.

You can manually disable autorotation by initializing `PPCoordinator` object with the following setting:

	[coordinatorSettings setValue:@(NO) forKey:kPPOverlayShouldAutorotate];

### <a name="0505"></a> Steps for providing custom Camera Overlay View

1. Create a subclass of `PPOverlayViewController`. You can use XIB for user interface, or create UI from code.

2. See if there are any events received from `CameraViewController` which you need to handle for your UI hierarchy

3. Implement your view hierarchy. 

	If you have a Cancel button in your view, don't forget to call `overlayViewControllerWillCloseCamera:` method on overlay's delegate object when cancel is pressed. 

	If you have Torch button, dont forget to check if Torch should be displayed by using `overlayViewControllerShouldDisplayTorch:` method, and to report new torch state with `overlayViewController:willSetTorch:` method. 

4. Handle orientation changes, either by implementing standard UIViewController autorotation metods, or by custom rotation management on rotation events.

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
