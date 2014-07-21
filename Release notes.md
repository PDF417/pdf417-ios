# Release notes

## 3.0.1
- Each `PPBaseResult` object now has attached information about it's location on processed video frame.
- Demo app updated to draw result position on image which resulted with successful scan

## 3.0.0
- Removed status bar properties from `PPScanningViewController` protocol. Replaced with `preferredStatusBarStyle` and `prefersStatusBarHidden` in `PPOverlayViewController`
- `kPPHudOrientation` replaced with `kPPOverlayShouldAutorotate`.
  - HUD orientation is now determined optimally inside pdf417 library
  - Autorotation can now be explicitly disallowed, e.g when presenting camera on `UINavigationController` or when presenting as FormSheet or PageSheet 
- Removed deprecated methods from `PPOverlayViewController`
- Fixed crash when Overlay those orientations which are not supported by the app. Now overlay works in that situations.
- Completely refactored "Complex Overlay" sample. Basically, it's open sourced implementation of internal pdf417 overlay.

## 2.6.1
- Added support for Photo camera preset
- Added option to automatically detect scale of the barcode on the image. This makes sense only when Photo preset is used.
- Added option to customize the status bar on camera screen
- Fixed "private selectors" issue which appears when publishing the app to app store
- Added a callback for obtaining the image which resulted with successful scan:
	`cameraViewController:didMakeSuccessfulScanOnImage:`
- Changes to API method for retrieving scanning results:

instead of using 

	- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
                  obtainedResult:(PPScanningResult*)result
         
Use:

	- (void)cameraViewController:(UIViewController<PPScanningViewController>*)cameraViewController
            	didOutputResults:(NSArray*)results;
            
New method adds an additional layers of abstraction to result obtaining. It makes possible several new features, most importantly, returning more than one recognition result, and returning results other than payslip scanning results (for example, pure OCR or barcode scanning results).

Objects passed in NSArray* `results` are always of type `PPBaseResult`. `PPScanningResult` (object passed in the all callback method) is now a subclass of `PPBaseResult`.

How to implement the new API?

1. Rename `cameraViewController:didFinishWithResult` to, i.e. `processScanningResult`
2. Implement `cameraViewController:didOutputResults`. Commonly, it can be implemented in the following way:

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
3. Test to see if it works.

## 2.6.0
- Improved scanning of Code39 and Code128 barcodes
- Added (basic) support for Aztec and DataMatrix barcodes
- Fixed autofocus problem on iPod Touch 4th Gen
- Package now contains additional file (buildCommit.txt) for easier point version bugfixes
- Fully updated license key generation and verification formats
- Improved scanning speed when using "allow null quiet zone" option
- Updated API for obtaining results in preparation for future API updates: see README.md file, Classic integration step 5.

## 2.5.3
- transition to new license key format

## 2.5.2
- Various bugfixes and performance improvements, especially when scanning uncertain barcodes

## 2.5.1
- Removed all redundant log outputs from iOS build

## 2.5.0
- Added feature for setting scanning region. See readme "Setting scanning region" for details on how to use it.

## 2.4.1
- iPod touch 5th gen now uses 720p video for scanning instead of 480p

## 2.4.0
- Added option to scan barcodes which have inverted intensities
- Added method `[PPBarcodeCoordinator getBuildVersionString]` that returns the internal library version string
- iOS7 deprecated methods are no longer used

## 2.3.1
- various bugfixes

## 2.3.0
- Added option to scan barcodes which don't have quite zone around them
- Improved scanning algorithm

## 2.2.0
- Added out of the box support for FormSheet/PageSheet presentation styles on iPads
- Fixed UI issues when presenting CameraViewController on NavigationViewController
- Refactored default OverlayViewController and provided in demo app. You can use it as a reference in creating your own custom overlays.

## 2.1.0
- Added support for arm64 platforms
- Raised deployment target to iOS 5.1.1. Older versions (up to iOS 4.3) are available on demand.

## 2.0.1
- Added support for front facing cameras

## 2.0.0
- Some type and naming changes in our API. But everything is still backwards compatible!
- Added very simple API for customizing camera overlay UI
- Added option for scanning uncertain barcodes (barcodes which are not encoded according to a standard). 
- API now supports pausing and resuming scanning without dismissing camera screen
- More advanced scanning library - able to scan barcodes on "worn out" plastic id cards

## 1.5.0
- The framework now has an interop feature. Barcode data can be serialized and deserialized in URLs. This means your app can easily subscribe for URL scan requests from other apps and return them scan results.
- Method name change fix in sample app.

## 1.4.1
- Fixed build issues with iOS Simulator when deployment target is set to iOS 7

## 1.4.0
- pdf417 framework can now be built for armv7s architecture which means faster performance on iPhone 5, 5C and 5S, and iPad 4.
- iOS 4.3 is no longer supported

## 1.3.0
- new, twice as fast method for scanning of pdf417 barcodes

## 1.2.4
- iPad 1 and other devices without camera now properly disabled.

## 1.2.3
- Fixed an issue which completely disabled pdf417 scanning on iPad2

## 1.2.2
- UI adjustments for iOS 7
- fixed name clashing with PayPal SDK

## 1.2.1
- bugfix for high resolution scanning on iPad mini.

## 1.2.0
- support for micro PDF417 standard
- support for damaged and non-standard PDF417 barcodes
- support for obtaining raw barcode result
- high resolution support (1080p)

## 1.1.1
- support for case insensitive bundle name matching when checking license key

## 1.1.0
- support for reading 1D barcodes

## 1.0.0
- Fixes for pdf417 scanning of barcodes with error correction 0 or 1
- Improved detection algorithm
- Licensing system fully functional
- Added Podfile for easier integration

## 0.9.0
- Scanning support for pdf417 and QR code
