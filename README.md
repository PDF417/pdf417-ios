<p align="center" >
  <a href="http://www.pdf417.mobi">
    <img src="https://raw.githubusercontent.com/wiki/pdf417/pdf417-ios/Images/Logo.png" alt="pdf417 SDK for iOS" title="pdf417 SDK for iOS"/>
  </a>
</p>

# _PDF417.mobi_ SDK for iOS

[![Build Status](https://travis-ci.org/PDF417/pdf417-ios.png)](https://travis-ci.org/PDF417/pdf417-ios)
[![Pod Version](http://img.shields.io/cocoapods/v/PPpdf417.svg?style=flat)](http://cocoadocs.org/docsets/PPpdf417/)

_PDF417.mobi_ SDK for iOS enables you to perform scans of various barcodes in your app. You can integrate the SDK into your app simply by following the instructions below and your app will be able to scan and process data from the following barcode standards:

* [PDF417 barcode](https://en.wikipedia.org/wiki/PDF417)
* [QR code](https://en.wikipedia.org/wiki/QR_code)
* [Code 128](https://en.wikipedia.org/wiki/Code_128)
* [Code 39](https://en.wikipedia.org/wiki/Code_39)
* [EAN 13](https://en.wikipedia.org/wiki/International_Article_Number_(EAN))
* [EAN 8](https://en.wikipedia.org/wiki/EAN-8)
* [UPC A](https://en.wikipedia.org/wiki/Universal_Product_Code)
* [UPC E](https://en.wikipedia.org/wiki/Universal_Product_Code)
* [ITF](https://en.wikipedia.org/wiki/Interleaved_2_of_5)

Using _PDF417.mobi_ in your app requires a valid license key. You can obtain a free trial license key by registering to [Microblink dashboard](https://microblink.com/login). After registering, you will be able to generate a license key for your app. The license key is bound to [bundle identifier](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/ConfiguringYourApp/ConfiguringYourApp.html) of your app, so please make sure you enter the correct bundle identifier when asked.

For more information on how to integrate _PDF417.mobi_ SDK into your app read the instructions below. Make sure you read the latest [Release notes](https://github.com/PDF417/pdf417-ios/blob/master/Release%20notes.md) for the most recent changes and improvements.

# Table of contents

- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Advanced PDF417.mobi integration instructions](#advanced-integration)
	- [Built-in overlay view controllers and overlay subviews](#ui-customizations)
		- [Using `MBBBarcodeOverlayViewController`](#using-pdf417-overlay-viewcontroller)
		- [Custom overlay view controller](#using-custom-overlay-viewcontroller)
	- [Direct processing API](#direct-api-processing)
		- [Using Direct API for `NSString` recognition (parsing)](#direct-api-string-processing)
- [`MBBRecognizer` and available recognizers](#recognizer)
- [List of available recognizers](#available-recognizers)
	- [Frame Grabber Recognizer](#frame-grabber-recognizer)
	- [Success Frame Grabber Recognizer](#success-frame-grabber-recognizer)
	- [PDF417 recognizer](#pdf417-recognizer)
	- [Barcode recognizer](#barcode-recognizer)
- [Localization](#localization)
- [Troubleshooting](#troubleshooting)
	- [Integration problems](#troubleshooting-integration-problems)
	- [SDK problems](#troubleshooting-sdk-problems)
		- [Licencing problems](#troubleshooting-licensing-problems)
		- [Other problems](#troubleshooting-other-problems)
	- [Frequently asked questions and known problems](#troubleshooting-faq)
- [Additional info](#info)


# <a name="requirements"></a> Requirements

SDK package contains Pdf417Mobi framework and one or more sample apps which demonstrate framework integration. The framework can be deployed in **iOS 9.0 or later**.

SDK performs significantly better when the images obtained from the camera are focused. Because of that, the SDK can have lower performance on iPad 2 and iPod Touch 4th gen devices, which [don't have camera with autofocus](http://www.adweek.com/socialtimes/ipad-2-rear-camera-has-tap-for-auto-exposure-not-auto-focus/12536). 
# <a name="quick-start"></a> Quick Start

## Getting started with PDF417.mobi SDK

This Quick Start guide will get you up and performing OCR scanning as quickly as possible. All steps described in this guide are required for the integration.

This guide closely follows the pdf417-sample app in the Samples folder of this repository. We highly recommend you try to run the sample app. The sample app should compile and run on your device, and in the iOS Simulator.

The source code of the sample app can be used as the reference during the integration.

### 1. Initial integration steps

#### Using CocoaPods

- Since the libraries are stored on [Git Large File Storage](https://git-lfs.github.com), you need to install git-lfs by running these commands:
```shell
brew install git-lfs
git lfs install
```

- **Be sure to restart your console after installing Git LFS**
- **Note:** if you already did try adding SDK using cocoapods and it's not working, first install the git-lfs and then clear you cocoapods cache. This should be sufficient to force cocoapods to clone PDF417.mobi SDK, if it still doesn't work, try deinitializing your pods and installing them again.
- Project dependencies to be managed by CocoaPods are specified in a file called `Podfile`. Create this file in the same directory as your Xcode project (`.xcodeproj`) file.

- If you don't have podfile initialized run the following in your project directory.
```
pod init
```

- Copy and paste the following lines into the TextEdit window:

```ruby
platform :ios, '9.0'
target 'Your-App-Name' do
    pod 'PPpdf417', '~> 8.0.1'
end
```

- Install the dependencies in your project:

```shell
$ pod install
```

- From now on, be sure to always open the generated Xcode workspace (`.xcworkspace`) instead of the project file when building your project:

```shell
open <YourProjectName>.xcworkspace
```

#### Integration without CocoaPods


-[Download](https://github.com/Pdf417/pdf417-ios/releases) latest release (Download .zip or .tar.gz file starting with PDF417.mobi. DO NOT download Source Code as GitHub does not fully support Git LFS)

OR

Clone this git repository:

- Since the libraries are stored on [Git Large File Storage](https://git-lfs.github.com), you need to install git-lfs by running these commands:
```shell
brew install git-lfs
git lfs install
```

- **Be sure to restart your console after installing Git LFS**

- To clone, run the following shell command:

```shell
git clone git@github.com:PDF417.mobi/pdf417-ios.git
```

- Copy Pdf417Mobi.xcframework to your project folder.

- In your Xcode project, open the Project navigator. Drag the Pdf417Mobi.xcframework file to your project, ideally in the Frameworks group, together with other frameworks you're using. When asked, choose "Create groups", instead of the "Create folder references" option.

![Adding Pdf417Mobi.xcframework to your project](https://user-images.githubusercontent.com/1635933/89505694-535a1680-d7ca-11ea-8c65-678f158acae9.png)

- Since Pdf417Mobi.xcframework is a dynamic framework, you also need to add it to embedded binaries section in General settings of your target.

![Adding Pdf417Mobi.xcframework to embedded binaries](https://user-images.githubusercontent.com/1635933/89793425-238e7400-db26-11ea-9556-6eedeb6dcc95.png)

- Include the additional frameworks and libraries into your project in the "Linked frameworks and libraries" section of your target settings.

    - libc++.tbd
    - libiconv.tbd
    - libz.tbd

![Adding Apple frameworks to your project](https://raw.githubusercontent.com/wiki/blinkocr/blinkocr-ios/Images/02%20-%20Add%20Libraries.png)

### 2. Referencing header file

In files in which you want to use scanning functionality place import directive.

Swift

```swift
import Pdf417Mobi
```

Objective-C

```objective-c
#import <Pdf417Mobi/Pdf417Mobi.h>
```

### 3. Initiating the scanning process

To initiate the scanning process, first decide where in your app you want to add scanning functionality. Usually, users of the scanning library have a button which, when tapped, starts the scanning process. Initialization code is then placed in touch handler for that button. Here we're listing the initialization code as it looks in a touch handler method.

Swift

```swift
class ViewController: UIViewController, MBBDocumentOverlayViewControllerDelegate  {

    var pdf417Recognizer: MBBPdf417Recognizer?
    var barcodeRecognizer: MBBBarcodeRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        MBBMicroblinkSDK.share().setLicenseResource("license", withExtension: "txt", inSubdirectory: "", for: Bundle.main, errorCallback: nil)
    }

    @IBAction func didTapScan(_ sender: AnyObject) {

        /** Create barcode recognizer */
        self.barcodeRecognizer = MBBBarcodeRecognizer()
        self.barcodeRecognizer?.scanQrCode = true

        self.pdf417Recognizer = MBBPdf417Recognizer()

        /** Create barcode settings */
        let settings : MBBBarcodeOverlaySettings = MBBBarcodeOverlaySettings()

        /** Crate recognizer collection */
        let recognizerList = [self.barcodeRecognizer!, self.pdf417Recognizer!]
        let recognizerCollection : MBBRecognizerCollection = MBBRecognizerCollection(recognizers: recognizerList)

        /** Create your overlay view controller */
        let barcodeOverlayViewController : MBBBarcodeOverlayViewController = MBBBarcodeOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)

        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)

        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
}
```

Objective-C

```objective-c
@interface ViewController () <MBBDocumentOverlayViewControllerDelegate>

@property (nonatomic, strong) MBBPdf417Recognizer *pdf417Recognizer;
@property (nonatomic, strong) MBBBarcodeRecognizer *barcodeRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBBMicroblinkSDK.sharedInstance setLicenseResource:@"blinkid-license" withExtension:@"txt" inSubdirectory:@"" for:Bundle.main errorCallback: nil];
}


- (IBAction)didTapScan:(id)sender {

    /** Create barcode recognizer */
    self.barcodeRecognizer = [MBBBarcodeRecognizer new];
    self.barcodeRecognizer.scanQrCode = true;

    self.pdf417Recognizer = [MBBPdf417Recognizer new];

    /** Create barcode settings */
    MBBBarcodeOverlaySettings *settings = [MBBBarcodeOverlaySettings new];

    /** Crate recognizer collection */
    NSArray *recognizerList = @[self.barcodeRecognizer!, self.pdf417Recognizer!];
    MBBRecognizerCollection *recognizerCollection = [[MBBRecognizerCollection alloc] initWithRecognizers:recognizerList];

    /** Create your overlay view controller */
    MBBBarcodeOverlayViewController *barcodeOverlayViewController = [[MBBBarcodeOverlayViewController alloc] initWithSettings:settings recognizerCollection:recognizerCollection delegate:self];

    /** Create recognizer view controller with wanted overlay view controller */
    UIViewController *recognizerRunneViewController = [MBBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:barcodeOverlayViewController];

    /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self. present:recognizerRunneViewController animated:true completion:nil];
}

@end
```

### 4. License key

A valid license key is required to initalize scanning. You can generate a free trial license key, after you register, at [Microblink developer dashboard](https://microblink.com/login).

You can include the license key in your app by passing a string or a file with license key.
**Note** that you need to set the license key before intializing scanning. Ideally in `AppDelegate` or `viewDidLoad` before initializing any recognizers.

#### License key as string
You can pass the license key as a string, the following way:

Swift

```swift
MBBMicroblinkSDK.shared().setLicenseKey("LICENSE-KEY")
```

Objective-C

```objective-c
[[MBBMicroblinkSDK sharedInstance] setLicenseKey:@"LICENSE-KEY"];
```

#### License key as file
Or you can include the license key, with the code below. Please make sure that the file that contains the license key is included in your project and is copied during **Copy Bundle Resources** build phase.

Swift

```swift
MBBMicroblinkSDK.shared().setLicenseResource("license-key-file", withExtension: "txt", inSubdirectory: "directory-to-license-key", for: Bundle.main, errorCallback: nil)
```

Objective-C

```objective-c
[[MBBMicroblinkSDK sharedInstance] setLicenseResource:@"license-key-file" withExtension:@"txt" inSubdirectory:@"" forBundle:[NSBundle mainBundle, errorCallback: nil]];
```

If the licence is invalid or expired then the methods above will throw an **exception**.

### 5. Registering for scanning events

In the previous step, you instantiated [`MBBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios//Classes/MBBBarcodeOverlayViewController.html) object with a delegate object. This object gets notified on certain events in scanning lifecycle. In this example we set it to `self`. The protocol which the delegate has to implement is [`MBBBarcodeOverlayViewControllerDelegate`](http://pdf417.github.io/pdf417-ios//Protocols/MBBBarcodeOverlayViewControllerDelegate.html) protocol. It is necessary to conform to that protocol. We will discuss more about protocols in [Advanced integration section](#advanced-integration). You can use the following default implementation of the protocol to get you started.

Swift

```swift
func documentOverlayViewControllerDidFinishScanning(_ documentOverlayViewController: MBBDocumentOverlayViewController, state: MBBRecognizerResultState) {

    // this is done on background thread
    // check for valid state
    if state == .valid {

        // first, pause scanning until we process all the results
        documentOverlayViewController.recognizerRunnerViewController?.pauseScanning()

        DispatchQueue.main.async(execute: {() -> Void in
            // All UI interaction needs to be done on main thread
        })
    }
}

func documentOverlayViewControllerDidTapClose(_ documentOverlayViewController: MBBDocumentOverlayViewController) {
    // Your action on cancel
}
```

Objective-C

```objective-c
- (void)documentOverlayViewControllerDidFinishScanning:(MBBDocumentOverlayViewController *)documentOverlayViewController state:(MBBRecognizerResultState)state {

    // this is done on background thread
    // check for valid state
    if (state == MBBRecognizerResultStateValid) {

        // first, pause scanning until we process all the results
        [documentOverlayViewController.recognizerRunnerViewController pauseScanning];

        dispatch_async(dispatch_get_main_queue(), ^{
            // All UI interaction needs to be done on main thread
        });
    }
}

- (void)documentOverlayViewControllerDidTapClose:(MBBDocumentOverlayViewController *)documentOverlayViewController {
    // Your action on cancel
}
```

# <a name="advanced-integration"></a> Advanced PDF417.mobi integration instructions
This section covers more advanced details of PDF417.mobi integration.

1. [First part](#ui-customizations) will cover the possible customizations when using UI provided by the SDK.
2. [Second part](#using-document-overlay-viewcontroller) will describe how to embed [`MBBRecognizerRunnerViewController's delegates`](http://pdf417.github.io/pdf417-ios/Protocols.html) into your `UIViewController` with the goal of creating a custom UI for scanning, while still using camera management capabilites of the SDK.
3. [Third part](#direct-api-processing) will describe how to use the [`MBBRecognizerRunner`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerRunner.html) (Direct API) for recognition directly from `UIImage` without the need of camera or to recognize camera frames that are obtained by custom camera management.
4. [Fourth part](#recognizer) will describe recognizer concept and available recognizers.


## <a name="ui-customizations"></a> Built-in overlay view controllers and overlay subviews

Within PDF417.mobi SDK there are several built-in overlay view controllers and scanning subview overlays that you can use to perform scanning. 
### <a name="using-pdf417-overlay-viewcontroller"></a> Using `MBBBarcodeOverlayViewController`

[`MBBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBBarcodeOverlayViewController.html) is overlay view controller best suited for performing scanning of various barcodes. It has [`MBBBarcodeOverlayViewControllerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBBarcodeOverlayViewControllerDelegate.html) delegate which can be used out-of-the-box to perform scanning using the default UI. Here is an example how to use and initialize [`MBBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBBarcodeOverlayViewController.html):

Swift
```swift
/** Create your overlay view controller */
let barcodeOverlayViewController : MBBBarcodeOverlayViewController = MBBBarcodeOverlayViewController(settings: barcodeSettings, recognizerCollection: recognizerCollection, delegate: self)

/** Create recognizer view controller with wanted overlay view controller */
let recognizerRunneViewController : UIViewController = MBBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
self.present(recognizerRunneViewController, animated: true, completion: nil)
```

Objective-C
```objective-c
MBBBarcodeOverlayViewController *overlayVC = [[MBBBarcodeOverlayViewController alloc] initWithSettings:settings recognizerCollection: recognizerCollection delegate:self];
UIViewController<MBBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
[self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
```

As you can see, when initializing [`MBBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBBarcodeOverlayViewController.html), we are sending delegate property as `self`. To get results, we need to conform to [`MBBBarcodeOverlayViewControllerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBBarcodeOverlayViewControllerDelegate.html) protocol.
### <a name="using-custom-overlay-viewcontroller"></a> Custom overlay view controller

Please check our Samples for custom implementation of overlay view controller.

Overlay View Controller is an abstract class for all overlay views.

It's responsibility is to provide meaningful and useful interface for the user to interact with.

Typical actions which need to be allowed to the user are:

- intuitive and meaniningful way to guide the user through scanning process. This is usually done by presenting a "viewfinder" in which the user need to place the scanned object
- a way to cancel the scanning, typically with a "cancel" or "back" button
- a way to power on and off the light (i.e. "torch") button

PDF417.mobi SDK always provides it's own default implementation of the Overlay View Controller for every specific use. Your implementation should closely mimic the default implementation as it's the result of thorough testing with end users. Also, it closely matches the underlying scanning technology.

For example, the scanning technology usually gives results very fast after the user places the device's camera in the expected way above the scanned object. This means a progress bar for the scan is not particularly useful to the user. The majority of time the user spends on positioning the device's camera correctly. That's just an example which demonstrates careful decision making behind default camera overlay view.

### 1. Subclassing

To use your custom overlay with Microblink's camera view, you must first subclass [`MBBCustomOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBCustomOverlayViewController.html) and implement the overlay behaviour conforming wanted protocols.

### 2. Protocols

There are five [`MBBRecognizerRunnerViewController`](http://pdf417.github.io/pdf417-ios/Protocols/MBBRecognizerRunnerViewController.html) protocols and one overlay protocol [`MBBOverlayViewControllerInterface`](http://pdf417.github.io/pdf417-ios/Protocols/MBBOverlayViewControllerInterface.html).

Five `RecognizerRunnerView` protocols are:
- [`MBBScanningRecognizerRunnerViewControllerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBScanningRecognizerRunnerViewControllerDelegate.html)
- [`MBBDetectionRecognizerRunnerViewControllerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBDetectionRecognizerRunnerViewControllerDelegate.html)
- [`MBBOcrRecognizerRunnerViewControllerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBOcrRecognizerRunnerViewControllerDelegate.html)
- [`MBBDebugRecognizerRunnerViewControllerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBDebugRecognizerRunnerViewControllerDelegate.html)
- [`MBBRecognizerRunnerViewControllerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBRecognizerRunnerViewControllerDelegate.html)

In `viewDidLoad`, other protocol conformation can be done and it's done on `recognizerRunnerViewController` property of [`MBBOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBOverlayViewController.html), for example:

Swift and Objective-C
```swift
self.scanningRecognizerRunnerViewControllerDelegate = self;
```

### 3. Initialization
In [Quick Start](#quick-start) guide it is shown how to use a default overlay view controller. You can now swap default view controller with your implementation of `CustomOverlayViewController`

Swift
```swift
let recognizerRunnerViewController : UIViewController = MBBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: CustomOverlayViewController)
```

Objective-C
```objective-c
UIViewController<MBBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:CustomOverlayViewController];
```

## <a name="direct-api-processing"></a> Direct processing API

This guide will in short present you how to process UIImage objects with PDF417.mobi SDK, without starting the camera video capture.

With this feature you can solve various use cases like:
	- recognizing text on images in Camera roll
	- taking full resolution photo and sending it to processing
	- scanning barcodes on images in e-mail etc.

DirectAPI-sample demo app here will present UIImagePickerController for taking full resolution photos, and then process it with PDF417.mobi SDK to get scanning results using Direct processing API.

Direct processing API is handled with [`MBBRecognizerRunner`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerRunner.html). That is a class that handles processing of images. It also has protocols as [`MBBRecognizerRunnerViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerRunnerViewController.html).
Developer can choose which protocol to conform:

- [`MBBScanningRecognizerRunnerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBScanningRecognizerRunnerDelegate.html)
- [`MBBDetectionRecognizerRunnerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBDetectionRecognizerRunnerDelegate.html)
- [`MBBDebugRecognizerRunnerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBDebugRecognizerRunnerDelegate.html)
- [`MBBOcrRecognizerRunnerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBOcrRecognizerRunnerDelegate.html)

In example, we are conforming to [`MBBScanningRecognizerRunnerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBScanningRecognizerRunnerDelegate.html) protocol.

To initiate the scanning process, first decide where in your app you want to add scanning functionality. Usually, users of the scanning library have a button which, when tapped, starts the scanning process. Initialization code is then placed in touch handler for that button. Here we're listing the initialization code as it looks in a touch handler method.

Swift
```swift
func setupRecognizerRunner() {
    var recognizers = [MBBRecognizer]()
    pdf417Recognizer = MBBPdf417Recognizer()
    recognizers.append(pdf417Recognizer!)
    let recognizerCollection = MBBRecognizerCollection(recognizers: recognizers)
    recognizerRunner = MBBRecognizerRunner(recognizerCollection: recognizerCollection)
    recognizerRunner?.scanningRecognizerRunnerDelegate = self
}

func processImageRunner(_ originalImage: UIImage) {
    var image: MBBImage? = nil
    if let anImage = originalImage {
        image = MBBImage(uiImage: anImage)
    }
    image?.cameraFrame = true
    image?.orientation = MBBProcessingOrientation.left
    let _serialQueue = DispatchQueue(label: "com.microblink.DirectAPI-sample-swift")
    _serialQueue.async(execute: {() -> Void in
        self.recognizerRunner?.processImage(image!)
    })
}

func recognizerRunner(_ recognizerRunner: MBBRecognizerRunner, didFinishScanningWith state: MBBRecognizerResultState) {
    if blinkInputRecognizer.result.resultState == MBBRecognizerResultStateValid {
        // Handle result
    }
}
```

Objective-C
```objective-c
- (void)setupRecognizerRunner {
    NSMutableArray<MBBRecognizer *> *recognizers = [[NSMutableArray alloc] init];

    self.pdf417Recognizer = [[MBBPdf417Recognizer alloc] init];

    [recognizers addObject: self.pdf417Recognizer];

    MBBRecognizerCollection *recognizerCollection = [[MBBRecognizerCollection alloc] initWithRecognizers:recognizers];

    self.recognizerRunner = [[MBBRecognizerRunner alloc] initWithRecognizerCollection:recognizerCollection];
    self.recognizerRunner.scanningRecognizerRunnerDelegate = self;
}

- (void)processImageRunner:(UIImage *)originalImage {
    MBBImage *image = [MBBImage imageWithUIImage:originalImage];
    image.cameraFrame = YES;
    image.orientation = MBBProcessingOrientationLeft;
    dispatch_queue_t _serialQueue = dispatch_queue_create("com.microblink.DirectAPI-sample", DISPATCH_QUEUE_SERIAL);
    dispatch_async(_serialQueue, ^{
        [self.recognizerRunner processImage:image];
    });
}

- (void)recognizerRunner:(nonnull MBBRecognizerRunner *)recognizerRunner didFinishScanningWithState:(MBBRecognizerResultState)state {
    if (self.blinkInputRecognizer.result.resultState == MBBRecognizerResultStateValid) {
        // Handle result
    }
}
```

Now you've seen how to implement the Direct processing API.

In essence, this API consists of two steps:

- Initialization of the scanner.
- Call of `- (void)processImage:(MBBImage *)image;` method for each UIImage or CMSampleBufferRef you have.


### <a name="direct-api-string-processing"></a> Using Direct API for `NSString` recognition (parsing)

Some recognizers support recognition from `NSString`. They can be used through Direct API to parse given `NSString` and return data just like when they are used on an input image. When recognition is performed on `NSString`, there is no need for the OCR. Input `NSString` is used in the same way as the OCR output is used when image is being recognized.
Recognition from `String` can be performed in the same way as recognition from image.
The only difference is that user should call `- (void)processString:(NSString *)string;` on [`MBBRecognizerRunner`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerRunner.html).

# <a name="recognizer"></a> `MBBRecognizer` and available recognizers

## The `MBBRecognizer` concept

The [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) is the basic unit of processing within the SDK. Its main purpose is to process the image and extract meaningful information from it. As you will see [later](#available-recognizers), the SDK has lots of different [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects that have various purposes.

Each [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) has a [`MBBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerResult.html) object, which contains the data that was extracted from the image. The [`MBBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerResult.html) object is a member of corresponding [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) object its lifetime is bound to the lifetime of its parent [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) object. If you need your `MBBRecognizerResult` object to outlive its parent [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) object, you must make a copy of it by calling its method `copy`.

While [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) object works, it changes its internal state and its result. The [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) object's [`MBBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerResult.html) always starts in `Empty` state. When corresponding [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) object performs the recognition of given image, its [`MBBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerResult.html) can either stay in `Empty` state (in case [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html)failed to perform recognition), move to `Uncertain` state (in case [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) performed the recognition, but not all mandatory information was extracted) or move to `Valid` state (in case [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) performed recognition and all mandatory information was successfully extracted from the image).

As soon as one [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) object's [`MBBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerResult.html) within [`MBBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerCollection.html) given to `MBBRecognizerRunner` or `MBBRecognizerRunnerViewController` changes to `Valid` state, the `onScanningFinished` callback will be invoked on same thread that performs the background processing and you will have the opportunity to inspect each of your [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects' [`MBBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerResult.html) to see which one has moved to `Valid` state.

As soon as `onScanningFinished` method ends, the `MBBRecognizerRunnerViewController` will continue processing new camera frames with same [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects, unless `paused`. Continuation of processing or `reset` recognition will modify or reset all [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects's [`MBBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerResult.html). When using built-in activities, as soon as `onScanningFinished` is invoked, built-in activity pauses the `MBBRecognizerRunnerViewController` and starts finishing the activity, while saving the [`MBBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerCollection.html) with active [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html).

## `MBBRecognizerCollection` concept

The [`MBBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerCollection.html) is is wrapper around [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects that has array of [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects that can be used to give [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects to `MBBRecognizerRunner` or `MBBRecognizerRunnerViewController` for processing.

The [`MBBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerCollection.html) is always constructed with array `[[MBBRecognizerCollection alloc] initWithRecognizers:recognizers]` of [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects that need to be prepared for recognition (i.e. their properties must be tweaked already).

The [`MBBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerCollection.html) manages a chain of [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects within the recognition process. When a new image arrives, it is processed by the first [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) in chain, then by the second and so on, iterating until a [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) object's [`MBBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerResult.html) changes its state to `Valid` or all of the [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects in chain were invoked (none getting a `Valid` result state).

You cannot change the order of the [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects within the chain - no matter the order in which you give [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects to [`MBBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerCollection.html), they are internally ordered in a way that provides best possible performance and accuracy. Also, in order for SDK to be able to order [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects in recognition chain in a best way possible, it is not allowed to have multiple instances of [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects of the same type within the chain. Attempting to do so will crash your application.

# <a name="available-recognizers"></a> List of available recognizers

This section will give a list of all [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) objects that are available within PDF417.mobi SDK, their purpose and recommendations how they should be used to get best performance and user experience.

## <a name="frame-grabber-recognizer"></a> Frame Grabber Recognizer

The [`MBBFrameGrabberRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBFrameGrabberRecognizer.html) is the simplest recognizer in SDK, as it does not perform any processing on the given image, instead it just returns that image back to its `onFrameAvailable`. Its result never changes state from empty.

This recognizer is best for easy capturing of camera frames with `MBBRecognizerRunnerViewController`. Note that [`MBBImage`](http://pdf417.github.io/pdf417-ios/Classes/MBBImage.html) sent to `onFrameAvailable` are temporary and their internal buffers all valid only until the `onFrameAvailable` method is executing - as soon as method ends, all internal buffers of [`MBBImage`](http://pdf417.github.io/pdf417-ios/Classes/MBBImage.html) object are disposed. If you need to store [`MBBImage`](http://pdf417.github.io/pdf417-ios/Classes/MBBImage.html) object for later use, you must create a copy of it by calling `copy`.

## <a name="success-frame-grabber-recognizer"></a> Success Frame Grabber Recognizer

The [`MBBSuccessFrameGrabberRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBSuccessFrameGrabberRecognizer.html) is a special `MBBecognizer` that wraps some other [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) and impersonates it while processing the image. However, when the [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) being impersonated changes its [`MBBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerResult.html) into `Valid` state, the [`MBBSuccessFrameGrabberRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBSuccessFrameGrabberRecognizer.html) captures the image and saves it into its own [`MBBSuccessFrameGrabberRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBBSuccessFrameGrabberRecognizerResult.html) object.

Since [`MBBSuccessFrameGrabberRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBSuccessFrameGrabberRecognizer.html)  impersonates its slave [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) object, it is not possible to give both concrete [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) object and `MBBSuccessFrameGrabberRecognizer` that wraps it to same `MBBRecognizerCollection` - doing so will have the same result as if you have given two instances of same [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) type to the [`MBBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerCollection.html) - it will crash your application.

This recognizer is best for use cases when you need to capture the exact image that was being processed by some other [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizer.html) object at the time its [`MBBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBBRecognizerResult.html) became `Valid`. When that happens, `MBBSuccessFrameGrabberRecognizer's` `MBBSuccessFrameGrabberRecognizerResult` will also become `Valid` and will contain described image.

## <a name="pdf417-recognizer"></a> PDF417 recognizer

The [`MBBPdf417Recognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBPdf417Recognizer.html) is recognizer specialised for scanning [PDF417 2D barcodes](https://en.wikipedia.org/wiki/PDF417). This recognizer can recognize only PDF417 2D barcodes - for recognition of other barcodes, please refer to [BarcodeRecognizer](#barcode-recognizer).

This recognizer can be used in any overlay view controller, but it works best with the [`MBBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBBarcodeOverlayViewController.html), which has UI best suited for barcode scanning.

## <a name="barcode-recognizer"></a> Barcode recognizer

The [`MBBBarcodeRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBBarcodeRecognizer.html) is recognizer specialised for scanning various types of barcodes. This recognizer should be your first choice when scanning barcodes as it supports lots of barcode symbologies, including the [PDF417 2D barcodes](https://en.wikipedia.org/wiki/PDF417), thus making [PDF417 recognizer](#pdf417-recognizer) possibly redundant, which was kept only for its simplicity.

You can enable multiple barcode symbologies within this recognizer, however keep in mind that enabling more barcode symbologies affect scanning performance - the more barcode symbologies are enabled, the slower the overall recognition performance. Also, keep in mind that some simple barcode symbologies that lack proper redundancy, such as [Code 39](https://en.wikipedia.org/wiki/Code_39), can be recognized within more complex barcodes, especially 2D barcodes, like [PDF417](https://en.wikipedia.org/wiki/PDF417).

This recognizer can be used in any overlay view controller, but it works best with the [`MBBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBBarcodeOverlayViewController.html), which has UI best suited for barcode scanning.
# <a name="localization"></a> Localization

The SDK is localized on following languages: Arabic, Chinese simplified, Chinese traditional, Croatian, Czech, Dutch, Filipino, French, German, Hebrew, Hungarian, Indonesian, Italian, Malay, Portuguese, Romanian, Slovak, Slovenian, Spanish, Thai, Vietnamese.

If you would like us to support additional languages or report incorrect translation, please contact us at [help.microblink.com](http://help.microblink.com).

If you want to add additional languages yourself or change existing translations, you need to set `customLocalizationFileName` property on [`MBBMicroblinkApp`](http://pdf417.github.io/pdf417-ios/Classes/MBBMicroblinkApp.html) object to your strings file name.

For example, let's say that we want to change text "Scan the front side of a document" to "Scan the front side" in BlinkID sample project. This would be the steps:
* Find the translation key in en.strings file inside Pdf417Mobi.framework
* Add a new file MyTranslations.strings to the project by using "Strings File" template
* With MyTranslations.string open, in File inspector tap "Localize..." button and select English
* Add the translation key "blinkid_generic_message" and the value "Scan the front side" to MyTranslations.strings
* Finally in AppDelegate.swift in method `application(_:, didFinishLaunchingWithOptions:)` add `MBBMicroblinkApp.instance()?.customLocalizationFileName = "MyTranslations"`

# <a name="troubleshooting"></a> Troubleshooting

## <a name="troubleshooting-integration-problems"></a> Integration problems

In case of problems with integration of the SDK, first make sure that you have tried integrating it into XCode by following [integration instructions](#quick-start).

If you have followed [XCode integration instructions](#quick-start) and are still having integration problems, please contact us at [help.microblink.com](http://help.microblink.com).

## <a name="troubleshooting-sdk-problems"></a> SDK problems

In case of problems with using the SDK, you should do as follows:

### <a name="troubleshooting-licensing-problems"></a> Licencing problems

If you are getting "invalid licence key" error or having other licence-related problems (e.g. some feature is not enabled that should be or there is a watermark on top of camera), first check the console. All licence-related problems are logged to error log so it is easy to determine what went wrong.

When you have determine what is the licence-relate problem or you simply do not understand the log, you should contact us [help.microblink.com](http://help.microblink.com). When contacting us, please make sure you provide following information:

* exact Bundle ID of your app (from your `info.plist` file)
* licence that is causing problems
* please stress out that you are reporting problem related to iOS version of PDF417.mobi SDK
* if unsure about the problem, you should also provide excerpt from console containing licence error

### <a name="troubleshooting-other-problems"></a> Other problems

If you are having problems with scanning certain items, undesired behaviour on specific device(s), crashes inside PDF417.mobi SDK or anything unmentioned, please do as follows:
	
* Contact us at [help.microblink.com](http://help.microblink.com) describing your problem and provide following information:
	* log file obtained in previous step
	* high resolution scan/photo of the item that you are trying to scan
	* information about device that you are using
	* please stress out that you are reporting problem related to iOS version of PDF417.mobi SDK

## <a name="troubleshooting-faq"></a> Frequently asked questions and known problems
Here is a list of frequently asked questions and solutions for them and also a list of known problems in the SDK and how to work around them.

#### Note on ARM Macs

We are supporting `ARM64 Device` slice through our `.xcframework` format.
We are still in development supporting `ARM64 Simulator` slice for newly released ARM Macs and we will update our SDK with `ARM64 Simulator` support as soon as development is done.

#### In demo everything worked, but after switching to production license I get `NSError` with `MBBMicroblinkSDKRecognizerErrorDomain` and `MBBRecognizerFailedToInitalize` code as soon as I construct specific [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBBRecognizer.html) object

Each license key contains information about which features are allowed to use and which are not. This `NSError` indicates that your production license does not allow using of specific `MBBRecognizer` object. You should contact [support](http://help.microblink.com) to check if provided licence is OK and that it really contains all features that you have purchased.

#### I get `NSError` with `MBBMicroblinkSDKRecognizerErrorDomain` and `MBBRecognizerFailedToInitalize` code with trial license key

Whenever you construct any [`MBBRecognizer`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBBRecognizer.html) object or, a check whether license allows using that object will be performed. If license is not set prior constructing that object, you will get `NSError` with `MBBMicroblinkSDKRecognizerErrorDomain` and `MBBRecognizerFailedToInitalize` code. We recommend setting license as early as possible in your app.

#### Undefined Symbols on Architecture armv7

Make sure you link your app with iconv and Accelerate frameworks as shown in [Quick start](#quick-start).
If you are using Cocoapods, please be sure that you've installed `git-lfs` prior to installing pods. If you are still getting this error, go to project folder and execute command `git-lfs pull`.

### Crash on armv7 devices

SDK crashes on armv7 devices if bitcode is enabled. We are working on it.

#### In my `didFinish` callback I have the result inside my `MBBRecognizer`, but when scanning activity finishes, the result is gone

This usually happens when using [`MBBRecognizerRunnerViewController`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBBRecognizerRunnerViewController.html) and forgetting to pause the [`MBBRecognizerRunnerViewController`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBBRecognizerRunnerViewController.html) in your `didFinish` callback. Then, as soon as `didFinish` happens, the result is mutated or reset by additional processing that `MBBRecognizer` performs in the time between end of your `didFinish` callback and actual finishing of the scanning activity. For more information about statefulness of the `MBBRecognizer` objects, check [this section](#recognizer-concept).

#### Unsupported architectures when submitting app to App Store

Pdf417Mobi.framework is a dynamic framework which contains slices for all architectures - device and simulator. If you intend to extract .ipa file for ad hoc distribution, you'll need to preprocess the framework to remove simulator architectures.

Ideal solution is to add a build phase after embed frameworks build phase, which strips unused slices from embedded frameworks.

Build step is based on the one provided here: http://ikennd.ac/blog/2015/02/stripping-unwanted-architectures-from-dynamic-libraries-in-xcode/

```shell
APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

# This script loops through the frameworks embedded in the application and
# removes unused architectures.
find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

EXTRACTED_ARCHS=()

for ARCH in $ARCHS
do
echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
done

echo "Merging extracted architectures: ${ARCHS}"
lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
rm "${EXTRACTED_ARCHS[@]}"

echo "Replacing original executable with thinned version"
rm "$FRAMEWORK_EXECUTABLE_PATH"
mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

done
```

### Disable logging

Logging can be disabled by calling `disableMicroblinkLogging` method on [`MBBLogger`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBBLogger.html) instance.
# <a name="info"></a> Additional info

Complete API reference can be found [here](http://pdf417.github.io/pdf417-ios/index.html). 

For any other questions, feel free to contact us at [help.microblink.com](http://help.microblink.com).