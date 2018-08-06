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
* [Data Matrix](https://en.wikipedia.org/wiki/Data_Matrix)
* [Aztec](https://en.wikipedia.org/wiki/Aztec_Code)

Using _PDF417.mobi_ in your app requires a valid license key. You can obtain a demo license key by registering to [Microblink dashboard](https://microblink.com/login). After registering, you will be able to generate a license key for your app. The license key is bound to [bundle identifier](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/ConfiguringYourApp/ConfiguringYourApp.html) of your app, so please make sure you enter the correct bundle identifier when asked.

For more information on how to integrate _PDF417.mobi_ SDK into your app read the instructions below. Make sure you read the latest [Release notes](https://github.com/PDF417/pdf417-ios/blob/master/Release%20notes.md) for the most recent changes and improvements.

# Table of contents

* [Requirements](#requirements)
* [Quick Start](#quickStart)
* [Advanced PDF417.mobi integration instructions](#advancedIntegration)
    * [UI customizations of built-in `MBOverlayViewControllers` and `MBOverlaySubviews`](#uiCustomizations)
        * [Built-in overlay view controllers and overlay subviews](#builtInUIComponents)
    * [Using `MBBarcodeOverlayViewController`](#mbBarcodeOverlayViewcontroller)
    * [Custom overlay view controller](#recognizerRunnerViewController)
    * [Direct processing API](#directAPI)
* [`MBRecognizer` and available recognizers](#availableRecognizers)
    * [The `MBRecognizer` concept](#recognizerConcept)
    * [`MBRecognizerCollection` concept](#recognizerBCollection)
    * [List of available recognizers](#recognizerList)
        * [Frame Grabber Recognizer](#frameGrabberRecognizer)
        * [Success Frame Grabber Recognizer](#successFrameGrabberRecognizer)
        * [PDF417 recognizer](#pdf417Recognizer)
        * [Barcode recognizer](#barcodeRecognizer)
* [Troubleshooting](#troubleshoot)
    * [Integration problems](#integrationTroubleshoot)
    * [SDK problems](#sdkTroubleshoot)
    * [Frequently asked questions and known problems](#faq)
* [Additional info](#info)

# <a name="requirements"></a> Requirements

SDK package contains Microblink framework and one or more sample apps which demonstrate framework integration. The framework can be deployed in iOS 8.0 or later, iPhone 4S or newer and iPad 2 or newer.

SDK performs significantly better when the images obtained from the camera are focused. Because of that, the SDK can have lower performance on iPad 2 and iPod Touch 4th gen devices, which [don't have camera with autofocus](http://www.adweek.com/socialtimes/ipad-2-rear-camera-has-tap-for-auto-exposure-not-auto-focus/12536). 

# <a name="quickStart"></a> Quick Start

## Getting started with PDF417.mobi SDK

This Quick Start guide will help you to set up the scanning as quickly as possible. All steps described in this guide are required for the integration.

This guide sets up basic PDF417 and QR code scanning functionality, and closely follows the pdf417-sample app. We highly recommend you try to run the sample app. The sample app should compile and run on your device, and in the iOS Simulator. 

The source code of the sample app can be used as the reference during the integration.

### 1. Initial integration steps

#### Using CocoaPods

- [CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries.

- If you wish to use version v1.4.0 or above, you need to install [Git Large File Storage](https://git-lfs.github.com) by running these commands:
```shell
brew install git-lfs
git lfs install
```

- **Be sure to restart your console after installing Git LFS**

- Project dependencies to be managed by CocoaPods are specified in a file called `Podfile`. Create this file in the same directory as your Xcode project (`.xcodeproj`) file.

- Copy and paste the following lines into the TextEdit window:  

```ruby
platform :ios, '9.0'
    pod 'PPpdf417', '~> 7.1.0'
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

- [Download](https://github.com/pdf417/pdf417-ios/archive/master.zip) Pdf417.mobi SDK to your filesystem, or clone this git repository. Do that by running:

```shell
git clone git@github.com:PDF417/pdf417-ios.git
```
- Copy MicroBlink.framework and MicroBlink.bundle to your project folder.

- In your Xcode project, open the Project navigator. Drag the MicroBlink.framework and MicroBlink.bundle files to your project, ideally in the Frameworks group, together with other frameworks you're using. When asked, choose "Create groups", instead of the "Create folder references" option.

![Adding MicroBlink.framework to your project](https://raw.githubusercontent.com/wiki/pdf417/pdf417-ios/Images/01%20-%20Add%20Framework.jpg)

- Since Microblink.framework is a dynamic framework, you also need to add it to embedded binaries section in General settings of your target.

![Adding MicroBlink.framework to embedded binaries](https://raw.githubusercontent.com/wiki/pdf417/pdf417-ios/Images/03%20-%20Embed%20Binaries.png)

- Include the additional frameworks and libraries into your project in the "Linked frameworks and libraries" section of your target settings. 

    - libc++.tbd
    - libz.tbd
	- libiconv.tbd
	- AudioToolbox.framework
	- CoreMedia.framework
	- AssetsLibrary.framework

![Adding Apple frameworks to your project](https://raw.githubusercontent.com/wiki/pdf417/pdf417-ios/Images/02%20-%20Add%20Libraries.jpg)
	
### 2. Referencing header file
	
In files in which you want to use scanning functionality place import directive.

Swift

```swift
import MicroBlink
```

Objective-C

```objective-c
#import <MicroBlink/MicroBlink.h>
```

### 3. Initiating the scanning process

1. Before starting a recognition process, you need to obtain a license from [Microblink dashboard](https://microblink.com/login). After registering, you will be able to generate a trial license for your app. License is bound to [Bundle ID](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/AppID.html) of your app, so please make sure you enter the correct Bundle ID when asked. 

    You must ensure that license key is set before instantiating any other classes from the SDK, otherwise you will get an exception at runtime.

    Swift
    ```swift
    /** First, set license key as soon as possible */
    MBMicroblinkSDK.sharedInstance().setLicenseResource("<license_name>", withExtension: "<extension>", inSubdirectory: "<subdirectory-name>", for: <bundle>)
    ```

    Objective-C
    ```objective-c
    /** First, set license key as soon as possible */
    [[MBMicroblinkSDK sharedInstance] setLicenseResource:@"<license_name>" withExtension:@"t<extension>" inSubdirectory:@"<subdirectory-name>" forBundle:<bundle>];
    ```

2. To initiate the scanning process, first decide where in your app you want to add scanning functionality. Usually, users of the scanning library have a button which, when tapped, starts the scanning process. Initialization code is then placed in touch handler for that button. Here we're listing the initialization code as it looks in a touch handler method. It is important to hold reference of recognizer which you want to use.

    Swift
    ```swift
    @IBAction func didTapScan(_ sender: AnyObject) {

        /** Create barcode recognizer */
        self.barcodeRecognizer = MBBarcodeRecognizer()
        self.barcodeRecognizer?.scanQrCode = true
        
        self.pdf417Recognizer = MBPdf417Recognizer()
        
        /** Create barcode settings */
        let settings : MBBarcodeOverlaySettings = MBBarcodeOverlaySettings()
        
        /** Crate recognizer collection */
        let recognizerList = [self.barcodeRecognizer!, self.pdf417Recognizer!]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        let barcodeOverlayViewController : MBBarcodeOverlayViewController = MBBarcodeOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }
    ```

    Objective-C
    ```objective-c
    - (IBAction)didTapScan:(id)sender {
        
         /** Create recognizers */
        self.barcodeRecognizer = [[MBBarcodeRecognizer alloc] init];
        self.barcodeRecognizer.scanQR = YES;

        self.pdf417Recognizer = [[MBPdf417Recognizer alloc] init];
                
        MBBarcodeOverlaySettings* settings = [[MBBarcodeOverlaySettings alloc] init];
        
        NSMutableArray<MBRecognizer *> *recognizers = [[NSMutableArray alloc] init];
        [recognizers addObject:self.barcodeRecognizer];
        [recognizers addObject:self.pdf417Recognizer];
        
        /** Create recognizer collection */
        MBRecognizerCollection *recognizerCollection = [[MBRecognizerCollection alloc] initWithRecognizers:recognizers];

        MBBarcodeOverlayViewController *overlayVC = [[MBBarcodeOverlayViewController alloc] initWithSettings:settings recognizerCollection:recognizerCollection delegate:self];
        UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];

        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        [self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
    }
    ```

3. In this example, we are using `MBBarcodeOverlayViewController` which has `MBBarcodeOverlayViewControllerDelegate`. It is necessary to conform to that protocol. We will discuss more about protocols in [Advanced integration section](#advancedIntegration). You can obtain the scanning results in one of the methods of `MBBarcodeOverlayViewControllerDelegate` protocol.

    Swift
    ```swift
    // MARK: MBBarcodeOverlayViewControllerDelegate
    extension ViewController : MBBarcodeOverlayViewControllerDelegate {
        
        func barcodeOverlayViewControllerDidFinishScanning(_ barcodeOverlayViewController: MBBarcodeOverlayViewController, state: MBRecognizerResultState) {
            
            let recognizerRunnerViewController = barcodeOverlayViewController.recognizerRunnerViewController as MBRecognizerRunnerViewController
            /** This callback is done on background thread and you need to be careful to not do any UI operations on it */
            recognizerRunnerViewController.pauseScanning()
            
            var message: String = ""
            var title: String = ""
            
            if (self.barcodeRecognizer!.result.resultState == MBRecognizerResultState.valid) {
                // Result handling
            }
            /** Needs to be called on main thread beacuse everything prior is on background thread */
            DispatchQueue.main.async {
                // UI actions
            }
        }
        
        func barcodeOverlayViewControllerDidTapClose(_ barcodeOverlayViewController: MBBarcodeOverlayViewController) {
            // Close button tapped on overlay view controller
        }
        
    }
    ```

    Objective-C
    ```objective-c
    #pragma mark - MBBarcodeOverlayViewControllerDelegate
    - (void)barcodeOverlayViewControllerDidFinishScanning:(MBBarcodeOverlayViewController *)barcodeOverlayViewController state:(MBRecognizerResultState)state {
        /** This callback is done on background thread and you need to be careful to not do any UI operations on it */
        [barcodeOverlayViewController.recognizerRunnerViewController pauseScanning];
        if (self.barcodeRecognizer.result.resultState == MBRecognizerResultStateValid) {
        }      
        /** Needs to be called on main thread beacuse everything prior is on background thread */
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI actions
        });
    }
     - (void)barcodeOverlayViewControllerDidFinishScanning:(MBBarcodeOverlayViewController *)barcodeOverlayViewController {
        // Close button tapped on overlay view controller
    }
    ```

# <a name="advancedIntegration"></a> Advanced PDF417.mobi integration instructions
This section covers more advanced details of PDF417.mobi integration.

1. [First part](#uiCustomizations) will cover the possible customizations when using UI provided by the SDK.
2. [Second part](#recognizerRunnerViewController) will describe how to embed [`MBRecognizerRunnerViewController's delegates`](http://pdf417.github.io/pdf417-ios/Protocols.html) into your `UIViewController` with the goal of creating a custom UI for scanning, while still using camera management capabilites of the SDK.
3. [Third part](#directAPI) will describe how to use the [`MBRecognizerRunner`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerRunner.html) (Direct API) for recognition directly from `UIImage` without the need of camera or to recognize camera frames that are obtained by custom camera management.
4. [Fourth part](#availableRecognizers) will describe recognizer concept and available recognizers.

## <a name="uiCustomizations"></a> UI customizations of built-in `MBOverlayViewControllers` and `MBOverlaySubviews`

### <a name="builtInUIComponents"></a> Built-in overlay view controllers and overlay subviews

Within PDF417.mobi SDK there are several built-in overlay view controllers and scanning subview overlays that you can use to perform scanning.

#### `MBBarcodeOverlayViewController`

[`MBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBarcodeOverlayViewController.html) is overlay view controller best suited for performing scanning of various barcodes. It has [`MBBarcodeOverlayViewControllerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBarcodeOverlayViewControllerDelegate.html) delegate which can be used out of the box to perform scanning using the default UI.

## <a name="mbBarcodeOverlayViewcontroller"></a> Using `MBBarcodeOverlayViewController`

[`MBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBarcodeOverlayViewController.html) is built-in overlay view controller which is best suiteed to use while scanning various barcodes. As you have seen in [Quick Start](#quickStart), [`MBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBarcodeOverlayViewController.html) has [`MBBarcodeOverlaySettings`](http://pdf417.github.io/pdf417-ios/Classes/MBBarcodeOverlaySettings.html). Here is an example how to use and initialize [`MBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBarcodeOverlayViewController.html):

Swift
```swift
/** Create your overlay view controller */
let barcodeOverlayViewController : MBBarcodeOverlayViewController = MBBarcodeOverlayViewController(settings: barcodeSettings, andDelegate: self)

/** Create recognizer view controller with wanted overlay view controller */
let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
self.present(recognizerRunneViewController, animated: true, completion: nil)
```

Objective-C
```objective-c
MBBarcodeOverlayViewController *overlayVC = [[MBBarcodeOverlayViewController alloc] initWithSettings:settings andDelegate:self];
UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
[self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
```

As you can see, when initializing [`MBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBarcodeOverlayViewController.html), we are sending delegate property as `self`. To get results, we need to conform to [`MBBarcodeOverlayViewControllerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBBarcodeOverlayViewControllerDelegate.html) protocol.


## <a name="recognizerRunnerViewController"></a> Custom overlay view controller

Overlay View Controller is an abstract class for all overlay views.

It's responsibility is to provide meaningful and useful interface for the user to interact with.
 
Typical actions which need to be allowed to the user are:

- intuitive and meaniningful way to guide the user through scanning process. This is usually done by presenting a "viewfinder" in which the user need to place the scanned object
- a way to cancel the scanning, typically with a "cancel" or "back" button
- a way to power on and off the light (i.e. "torch") button
 
PDF417.mobi SDK always provides it's own default implementation of the Overlay View Controller for every specific use. Your implementation should closely mimic the default implementation as it's the result of thorough testing with end users. Also, it closely matches the underlying scanning technology. 

For example, the scanning technology usually gives results very fast after the user places the device's camera in the expected way above the scanned object. This means a progress bar for the scan is not particularly useful to the user. The majority of time the user spends on positioning the device's camera correctly. That's just an example which demonstrates careful decision making behind default camera overlay view.

### 1. Initialization
 
To use your custom overlay with MicroBlink's camera view, you must first subclass [`MBOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBOverlayViewController.html) and implement the overlay behaviour conforming wanted protocols.

### 2. Protocols

There are five [`MBRecognizerRunnerViewController`](http://pdf417.github.io/pdf417-ios/Protocols/MBRecognizerRunnerViewController.html) protocols.

Five `RecognizerRunnerView` protocols are:
- [`MBScanningRecognizerRunnerViewDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBScanningRecognizerRunnerViewDelegate.html)
- [`MBDetectionRecognizerRunnerViewDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBDetectionRecognizerRunnerViewDelegate.html)
- [`MBOcrRecognizerRunnerViewDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBOcrRecognizerRunnerViewDelegate.html)
- [`MBDebugRecognizerRunnerViewDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBDebugRecognizerRunnerViewDelegate.html)
- [`MBRecognizerRunnerViewControllerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBRecognizerRunnerViewControllerDelegate.html)

`MBCustomOverlayViewController`[`MBCustomOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBCustomOverlayViewController.html) class needs to be inherited by custom view controller and it needs to conform `MBScanningRecognizerRunnerViewControllerDelegate`. It contains all the properties needed for your custom view controller.

In `viewDidLoad`, `scanningRecognizerRunnerViewControllerDelegate` has to be set on `super` property: 

Swift and Objective-C
```swift
super.scanningRecognizerRunnerViewControllerDelegate = self;
```

### 3. Overlay subviews
Developer needs to know which subivew is needed for custom view controller. If you want to use built-in implementation we recommend to use [`MBModernViewfinderOverlaySubview`](http://pdf417.github.io/pdf417-ios/Classes/MBModernViewfinderOverlaySubview.html). In can be initialized in `viewDidLoad` method:

Swift
```swift
viewfinderSubview = MBModernViewfinderOverlaySubview()
viewfinderSubview.moveable = true
view.addSubview(viewfinderSubview)
```
Objective-C
```objective-c
self.viewfinderSubview = [[MBModernViewfinderOverlaySubview alloc] init];
self.viewfinderSubview.delegate = self.overlaySubviewsDelegate;
self.viewfinderSubview.moveable = YES;
[self.view addSubview:self.viewfinderSubview];
```

### 4. Initialization
In [Quick Start](#quickStart) guide it is shown how to use [`MBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Protocols/MBRecognizerRunnerViewController.html). You can now swap [`MBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Protocols/MBRecognizerRunnerViewController.html) with `CustomOverlayViewController`

Swift
```swift
let recognizerRunnerViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: CustomOverlayViewController)
```

Objective-C
```objective-c
UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:CustomOverlayViewController];
```


## <a name="directAPI"></a> Direct processing API

This guide will in short present you how to process UIImage objects with PDF417.mobi SDK, without starting the camera video capture.

With this feature you can solve various use cases like:
	- recognizing text on images in Camera roll
	- taking full resolution photo and sending it to processing
	- scanning barcodes on images in e-mail etc.

DirectAPI-sample demo app here will present UIImagePickerController for taking full resolution photos, and then process it with MicroBlink SDK to get scanning results using Direct processing API.

Direct processing API is handled with [`MBRecognizerRunner`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerRunner.html). That is a class that handles processing of images. It also has protocols as [`MBRecognizerRunnerViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerRunnerViewController.html).
Developer can choose which protocol to conform:

- [`MBScanningRecognizerRunnerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBScanningRecognizerRunnerDelegate.html)
- [`MBDetectionRecognizerRunnerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBDetectionRecognizerRunnerDelegate.html)
- [`MBDebugRecognizerRunnerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBDebugRecognizerRunnerDelegate.html)
- [`MBOcrRecognizerRunnerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBOcrRecognizerRunnerDelegate.html)

In example, we are conforming to [`MBScanningRecognizerRunnerDelegate`](http://pdf417.github.io/pdf417-ios/Protocols/MBScanningRecognizerRunnerDelegate.html) protocol.

To initiate the scanning process, first decide where in your app you want to add scanning functionality. Usually, users of the scanning library have a button which, when tapped, starts the scanning process. Initialization code is then placed in touch handler for that button. Here we're listing the initialization code as it looks in a touch handler method.

Swift
```swift
func setupRecognizerRunner() {
    var recognizers = [AnyHashable]() as? [MBRecognizer]
    pdf417Recognizer = MBPdf417Recognizer()
    recognizers.append(pdf417Recognizer)
    let settings = MBSettings()
    settings.uiSettings.recognizerCollection = MBRecognizerCollection(recognizers: recognizers)
    recognizerRunner = MBRecognizerRunner(settings: settings as? [String : Any] ?? [String : Any]())
    recognizerRunner.scanningRecognizerRunnerDelegate = self
}

func processImageRunner(_ originalImage: UIImage) {
    let image = MBImage(uiImage: originalImage)
    image.cameraFrame = true
    image.orientation = PPProcessingOrientationLeft
    let _serialQueue = DispatchQueue(label: "com.microblink.DirectAPI-sample")
    _serialQueue.async(execute: {() -> Void in
        self.recognizerRunner.processImage(image)
    })
}

func recognizerRunnerDidFinish(_ recognizerRunner: MBRecognizerRunner, state: MBRecognizerResultState) {
    if pdf417Recognizer.result.resultState == MBRecognizerResultStateValid {
        // Handle result
    }
}
```

Objective-C
```objective-c
- (void)setupRecognizerRunner {
    NSMutableArray<MBRecognizer *> *recognizers = [[NSMutableArray alloc] init];
    
    NSError *error;
    self.pdf417Recognizer = [[MBPdf417Recognizer alloc] init];
    
    [recognizers addObject:self.pdf417Recognizer];
    
    MBSettings* settings = [[MBSettings alloc] init];
    settings.uiSettings.recognizerCollection = [[MBRecognizerCollection alloc] initWithRecognizers:recognizers];
    
    self.recognizerRunner = [[MBRecognizerRunner alloc] initWithSettings:settings];
    self.recognizerRunner.scanningRecognizerRunnerDelegate = self;
}

- (void)processImageRunner:(UIImage *)originalImage {
    MBImage *image = [MBImage imageWithUIImage:originalImage];
    image.cameraFrame = YES;
    image.orientation = PPProcessingOrientationLeft;
    dispatch_queue_t _serialQueue = dispatch_queue_create("com.microblink.DirectAPI-sample", DISPATCH_QUEUE_SERIAL);
    dispatch_async(_serialQueue, ^{
        [self.recognizerRunner processImage:image];
    });
}

#pragma mark - MBScanningRecognizerRunnerDelegate
- (void)recognizerRunnerDidFinish:(MBRecognizerRunner *)recognizerRunner state:(MBRecognizerResultState)state {
    if (self.pdf417Recognizer.result.resultState == MBRecognizerResultStateValid) {
        // Handle result
    }
}
```

Now you've seen how to implement the Direct processing API.

In essence, this API consists of two steps:

- Initialization of the scanner.
- Call of processImage: method for each UIImage or CMSampleBufferRef you have.


# <a name="availableRecognizers"></a> `MBRecognizer` and available recognizers

## <a name="recognizerConcept"></a> The `MBRecognizer` concept

The [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) is the basic unit of processing within the SDK. Its main purpose is to process the image and extract meaningful information from it. As you will see [later](#recognizerList), the SDK has lots of different [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects that have various purposes.

Each [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) has a [`MBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerResult.html) object, which contains the data that was extracted from the image. The [`MBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerResult.html) object is a member of corresponding [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) object its lifetime is bound to the lifetime of its parent [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) object. If you need your `MBRecognizerRecognizer` object to outlive its parent [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) object, you must make a copy of it by calling its method `copy`.

While [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) object works, it changes its internal state and its result. The [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) object's [`MBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerResult.html) always starts in `Empty` state. When corresponding [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) object performs the recognition of given image, its [`MBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerResult.html) can either stay in `Empty` state (in case [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html)failed to perform recognition), move to `Uncertain` state (in case [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) performed the recognition, but not all mandatory information was extracted) or move to `Valid` state (in case [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) performed recognition and all mandatory information was successfully extracted from the image).

As soon as one [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) object's [`MBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerResult.html) within [`MBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerCollection.html) given to `MBRecognizerRunner` or `MBRecognizerRunnerViewController` changes to `Valid` state, the `onScanningFinished` callback will be invoked on same thread that performs the background processing and you will have the opportunity to inspect each of your [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects' [`MBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerResult.html) to see which one has moved to `Valid` state.

As soon as `onScanningFinished` method ends, the `MBRecognizerRunnerViewController` will continue processing new camera frames with same [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects, unless `paused`. Continuation of processing or `reset` recognition will modify or reset all [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects's [`MBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerResult.html). When using built-in activities, as soon as `onScanningFinished` is invoked, built-in activity pauses the `MBRecognizerRunnerViewController` and starts finishing the activity, while saving the [`MBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerCollection.html) with active [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html).

## <a name="recognizerBCollection"></a> `MBRecognizerCollection` concept

The [`MBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerCollection.html) is is wrapper around [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects that has array of [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects that can be used to give [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects to `MBRecognizerRunner` or `MBRecognizerRunnerViewController` for processing.

The [`MBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerCollection.html) is always constructed with array `[[MBRecognizerCollection alloc] initWithRecognizers:recognizers]` of [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects that need to be prepared for recognition (i.e. their properties must be tweaked already). 

The [`MBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerCollection.html) manages a chain of [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects within the recognition process. When a new image arrives, it is processed by the first [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) in chain, then by the second and so on, iterating until a [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) object's [`MBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerResult.html) changes its state to `Valid` or all of the [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects in chain were invoked (none getting a `Valid` result state).

You cannot change the order of the [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects within the chain - no matter the order in which you give [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects to [`MBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerCollection.html), they are internally ordered in a way that provides best possible performance and accuracy. Also, in order for SDK to be able to order [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects in recognition chain in a best way possible, it is not allowed to have multiple instances of [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects of the same type within the chain. Attempting to do so will crash your application.

## <a name="recognizerList"></a> List of available recognizers

This section will give a list of all [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) objects that are available within PDF417.mobi SDK, their purpose and recommendations how they should be used to get best performance and user experience.

### <a name="frameGrabberRecognizer"></a> Frame Grabber Recognizer

The [`MBFrameGrabberRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBFrameGrabberRecognizer.html) is the simplest recognizer in SDK, as it does not perform any processing on the given image, instead it just returns that image back to its `onFrameAvailable`. Its result never changes state from empty.

This recognizer is best for easy capturing of camera frames with `MBRecognizerRunnerViewController`. Note that [`MBImage`](http://pdf417.github.io/pdf417-ios/Classes/MBImage.html) sent to `onFrameAvailable` are temporary and their internal buffers all valid only until the `onFrameAvailable` method is executing - as soon as method ends, all internal buffers of [`MBImage`](http://pdf417.github.io/pdf417-ios/Classes/MBImage.html) object are disposed. If you need to store [`MBImage`](http://pdf417.github.io/pdf417-ios/Classes/MBImage.html) object for later use, you must create a copy of it by calling `copy`.

### <a name="successFrameGrabberRecognizer"></a> Success Frame Grabber Recognizer

The [`MBSuccessFrameGrabberRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBSuccessFrameGrabberRecognizer.html) is a special `MBecognizer` that wraps some other [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) and impersonates it while processing the image. However, when the [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) being impersonated changes its [`MBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerResult.html) into `Valid` state, the [`MBSuccessFrameGrabberRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBSuccessFrameGrabberRecognizer.html) captures the image and saves it into its own [`MBSuccessFrameGrabberRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBSuccessFrameGrabberRecognizerResult.html) object.

Since [`MBSuccessFrameGrabberRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBSuccessFrameGrabberRecognizer.html)  impersonates its slave [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) object, it is not possible to give both concrete [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) object and `MBSuccessFrameGrabberRecognizer` that wraps it to same `MBRecognizerCollection` - doing so will have the same result as if you have given two instances of same [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) type to the [`MBRecognizerCollection`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerCollection.html) - it will crash your application.

This recognizer is best for use cases when you need to capture the exact image that was being processed by some other [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizer.html) object at the time its [`MBRecognizerResult`](http://pdf417.github.io/pdf417-ios/Classes/MBRecognizerResult.html) became `Valid`. When that happens, `MBSuccessFrameGrabberRecognizer's` `MBSuccessFrameGrabberRecognizerResult` will also become `Valid` and will contain described image.

### <a name="pdf417Recognizer"></a> PDF417 recognizer

The [`MBPdf417Recognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBPdf417Recognizer.html) is recognizer specialised for scanning [PDF417 2D barcodes](https://en.wikipedia.org/wiki/PDF417). This recognizer can recognize only PDF417 2D barcodes - for recognition of other barcodes, please refer to [BarcodeRecognizer](#barcodeRecognizer).

This recognizer can be used in any overlay view controller, but it works best with the [`MBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBarcodeOverlayViewController.html), which has UI best suited for barcode scanning.

### <a name="barcodeRecognizer"></a> Barcode recognizer

The [`MBBarcodeRecognizer`](http://pdf417.github.io/pdf417-ios/Classes/MBBarcodeRecognizer.html) is recognizer specialised for scanning various types of barcodes. This recognizer should be your first choice when scanning barcodes as it supports lots of barcode symbologies, including the [PDF417 2D barcodes](https://en.wikipedia.org/wiki/PDF417), thus making [PDF417 recognizer](#pdf417Recognizer) possibly redundant, which was kept only for its simplicity.

You can enable multiple barcode symbologies within this recognizer, however keep in mind that enabling more barcode symbologies affect scanning performance - the more barcode symbologies are enabled, the slower the overall recognition performance. Also, keep in mind that some simple barcode symbologies that lack proper redundancy, such as [Code 39](https://en.wikipedia.org/wiki/Code_39), can be recognized within more complex barcodes, especially 2D barcodes, like [PDF417](https://en.wikipedia.org/wiki/PDF417).

This recognizer can be used in any overlay view controller, but it works best with the [`MBBarcodeOverlayViewController`](http://pdf417.github.io/pdf417-ios/Classes/MBBarcodeOverlayViewController.html), which has UI best suited for barcode scanning.

# <a name="troubleshoot"></a> Troubleshooting

## <a name="integrationTroubleshoot"></a> Integration problems

In case of problems with integration of the SDK, first make sure that you have tried integrating it into XCode by following [integration instructions](#quickStart).

If you have followed [XCode integration instructions](#quickStart) and are still having integration problems, please contact us at [help.microblink.com](http://help.microblink.com).

## <a name="sdkTroubleshoot"></a> SDK problems

In case of problems with using the SDK, you should do as follows:

### Licencing problems

If you are getting "invalid licence key" error or having other licence-related problems (e.g. some feature is not enabled that should be or there is a watermark on top of camera), first check the console. All licence-related problems are logged to error log so it is easy to determine what went wrong.

When you have determine what is the licence-relate problem or you simply do not understand the log, you should contact us [help.microblink.com](http://help.microblink.com). When contacting us, please make sure you provide following information:

* exact Bundle ID of your app (from your `info.plist` file)
* licence that is causing problems
* please stress out that you are reporting problem related to iOS version of PDF417.mobi SDK
* if unsure about the problem, you should also provide excerpt from console containing licence error

### Other problems

If you are having problems with scanning certain items, undesired behaviour on specific device(s), crashes inside PDF417.mobi SDK or anything unmentioned, please do as follows:
	
* Contact us at [help.microblink.com](http://help.microblink.com) describing your problem and provide following information:
	* log file obtained in previous step
	* high resolution scan/photo of the item that you are trying to scan
	* information about device that you are using
	* please stress out that you are reporting problem related to iOS version of PDF417.mobi SDK

## <a name="faq"></a> Frequently asked questions and known problems
Here is a list of frequently asked questions and solutions for them and also a list of known problems in the SDK and how to work around them.

#### <a name="featureNotSupportedByLicenseKey"></a> In demo everything worked, but after switching to production license I get `NSError` with `MBMicroblinkSDKRecognizerErrorDomain` and `MBRecognizerFailedToInitalize` code as soon as I construct specific [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBRecognizer.html) object

Each license key contains information about which features are allowed to use and which are not. This `NSError` indicates that your production license does not allow using of specific `MBRecognizer` object. You should contact [support](http://help.microblink.com) to check if provided licence is OK and that it really contains all features that you have purchased.

#### <a name="invalidLicenseKey"></a> I get `NSError` with `MBMicroblinkSDKRecognizerErrorDomain` and `MBRecognizerFailedToInitalize` code with trial license key

Whenever you construct any [`MBRecognizer`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBRecognizer.html) object or, a check whether license allows using that object will be performed. If license is not set prior constructing that object, you will get `NSError` with `MBMicroblinkSDKRecognizerErrorDomain` and `MBRecognizerFailedToInitalize` code. We recommend setting license as early as possible in your app.

#### <a name="undefinedSymbols"></a> Undefined Symbols on Architecture armv7

Make sure you link your app with iconv and Accelerate frameworks as shown in [Quick start](#quickStart). 
If you are using Cocoapods, please be sure that you've installed `git-lfs` prior to installing pods. If you are still getting this error, go to project folder and execute command `git-lfs pull`.

#### <a name="statefulRecognizer"></a> In my `didFinish` callback I have the result inside my `MBRecognizer`, but when scanning activity finishes, the result is gone

This usually happens when using [`MBRecognizerRunnerViewController`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBRecognizerRunnerViewController.html) and forgetting to pause the [`MBRecognizerRunnerViewController`](http://pdf417.github.io/pdf417-ios/docs/Classes/MBRecognizerRunnerViewController.html) in your `didFinish` callback. Then, as soon as `didFinish` happens, the result is mutated or reset by additional processing that `MBRecognizer` performs in the time between end of your `didFinish` callback and actual finishing of the scanning activity. For more information about statefulness of the `MBRecognizer` objects, check [this section](#recognizerConcept).

#### <a name="unsupportedArchitecture"></a> Unsupported architectures when submitting app to App Store

Microblink.framework is a dynamic framework which contains slices for all architectures - device and simulator. If you intend to extract .ipa file for ad hoc distribution, you'll need to preprocess the framework to remove simulator architectures. 

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

# <a name="info"></a> Additional info

Complete API reference can be found [here](http://pdf417.github.io/pdf417-ios/docs/index.html). 

For any other questions, feel free to contact us at [help.microblink.com](http://help.microblink.com).
