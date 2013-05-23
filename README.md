# pdf417.mobi integration instructions

The package contains the pdf417 framework and a sample app to demonstrate its integration. Framework can be deployed on iOS 4.3 or later and iPhone 3GS or newer. This README accompanies the sample app and shows how to setup basic functionality as well as perform some customization.

## How to integrate the pdf417.mobi framework in your project

1. Drag the pdf417.embeddedframework into the Frameworks Group in your Xcode project. The framework
consists of code, headers, resources, strings, images and everything it needs to function properly.

2. Include the following frameworks and libraries into your project:
	- AVFoundation
	- AudioToolbox
	- CoreMedia
	- CoreVideo
	- CoreGraphics
	- libstdc++.dylib
	- libz.dylib
	- libiconv.dylib
	- OpenGLES
	- QuartzCore
	
3. Find the build settings for your target. Set the architectures (ARCHS) setting to armv7. This is needed because pdf417.embeddedframework currently supports only armv7 architectures. This means your app app will be a few MBs smaller (since armv7s build will not be included), but will still work with iPhone 3GS and newer.
	
4. In files in which you want to use barcode scanning, place import directive

		#import <pdf417/PPBarcode.h>

5. pdf417 framework uses it's own `CameraViewController` to present the UI. You should decide where you want to show this UI and write the following initialization code there. The initialization procedure consists of the following steps:

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
        	return;
    	}

	Then you need to setup pdf417 initialization parameters. Parameters are placed in a `NSMutableDictionary` object. 
	This is where you set which barcode formats are scanned (currently QR code and pdf417) and where you can set language used in pdf417 framework. 
    
    	// Create object which stores pdf417 framework settings
   		NSMutableDictionary* coordinatorSettings = [[NSMutableDictionary alloc] init];
    
    	// Set YES/NO for scanning pdf417 barcode standard (default YES)
    	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizePdf417Key];
    	
    	// Set YES/NO for scanning qr code barcode standard (default NO)
    	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeQrCodeKey];
		
	There are more, optional settings values. For example:
		
	    // present modal (recommended and default) - make sure you dismiss the view controller when done
    	// you also can set this to NO and push camera view controller to navigation view controller 
    	[coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPPresentModal];
    	
    	// You can set orientation mask for allowed orientations, default is UIInterfaceOrientationMaskAll
    	[coordinatorSettings setValue:[NSNumber numberWithInt:UIInterfaceOrientationMaskAll] forKey:kPPHudOrientation];
		
		// Define the sound filename played on successful recognition
		NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
		[coordinatorSettings setValue:soundPath forKey:kPPSoundFile];
    	
    Also, this is where you can set language used in pdf417 framework, this can currently be only `en` (English), `de` (German) and `hr` (Croatian). Other languages can be supported on demand. If you don't specify the language, default user language will be used, so use this feature according to your application's localization strategy.
    	
    	// Set the language. You can use "en", "de", "hr", if not specified, phone default will be used.
    	// Use this according to your app localization strategy
    	[coordinatorSettings setValue:@"en" forKey:kPPLanguage];
		
	Now you can initialize `PPBarcodeCoordinator` object and use it to create `PPCameraViewController` which controls scanning UI. You can present it on navigation view controller, but we recommend presenting it modally with these methods:
	
		/**
 		 * Method presents a modal view controller and uses non deprecated method in iOS 6
 		 */
		- (void)presentCameraViewController:(UIViewController*)cameraViewController {
    		cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    		if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        		[self presentViewController:cameraViewController animated:YES completion:nil];
    		} else {
        		[self presentModalViewController:cameraViewController animated:YES];
    		}
		}

		/**
 		 * Method dismisses a modal view controller and uses non deprecated method in iOS 6
 		 */
		- (void)dismissCameraViewController {
    		if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        		[self dismissViewControllerAnimated:YES completion:nil];
    		} else {
        		[self dismissModalViewControllerAnimated:YES];
    		}
		}
		
	With these methods you can present camera view controller like this (this code doesn't use ARC, but with ARC you just follow the conventions as usual):
	
	    // Allocate the recognition coordinator object
   		PPBarcodeCoordinator *coordinator = [[PPBarcodeCoordinator alloc] initWithSettings:coordinatorSettings];
   		[coordinatorSettings release];
    
    	// Create camera view controller
    	UIViewController *cameraViewController = [coordinator cameraViewControllerWithDelegate:self];
    
    	// present it modally
    	cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    	[self presentCameraViewController:cameraViewController];
    	
    	[coordinator release];

6. In the last step, you had to create `CameraViewController` with a delegate object. This object gets notified
on certain events in pdf417 scanning lifecycle. In this example we set it to `self`, but any object can be used. The protocol which the delegate has to implement is `PPBarcodeDelegate` protocol and it consists of 2 required methods:
		
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
				 
	For example, your implementation of these methods can be (if you presented camera view controller modally):

		- (void)cameraViewControllerWasClosed:(UIViewController *)cameraViewController {
    		[self dismissCameraViewControllerModal:[self useModalCameraView]];
		}

		- (void)cameraViewController:(UIViewController *)cameraViewController obtainedResult:(PPScanningResult *)result {
    
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
    		[self dismissCameraViewControllerModal:[self useModalCameraView]];
		}
		
7. The package contains the framework and a sample application you can easily run to see how integration works in practice.

## Retrieving scanning results
		
Recognition results are returned via `PPScanningResult` object. You use this object to read barcode type and barcode data.

`PPScanningResult` has a field named `type` which is enum (identification) of the type of the barcode which was scanned. This can currently be only `PPScanningResultPdf417` (for pdf417) and `PPScanningResultQrCode` (for QR code).

The field named `data` contains the bytes scanned from the actual barcode. These are raw bytes which are written in the barcode. No encoding for this is assumed, since this is a responsibility of the user of the library.

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

		// Set the language. You can use "en", "de", "hr", if not specified, phone default will be used.
    	// Use this according to your app localization strategy
    	[coordinatorSettings setValue:@"en" forKey:kPPLanguage];
		
## Additional info
 
 For any inquiries, additional information or instructions please contact us at <jurica.cerovec@photopay.net>