//
//  PPOverlayViewController.h
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 5/28/13.
//  Copyright (c) 2013 MicroBlink Ltd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#import "MBScanningRecognizerRunnerViewController.h"
#import "PPMicroBlinkDefines.h"
#import "MBOverlayContainerViewController.h"

#import "MBRecognizerResult.h"
#import "MBDisplayableQuadDetection.h"
#import "MBDisplayablePointsDetection.h"

#import "PPLivenessAction.h"
#import "PPLivenessError.h"
#import "MBOverlayViewControllerInterface.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBOcrRecognizerRunnerViewDelegate;
@protocol MBDetectionRecognizerRunnerViewDelegate;
@protocol MBScanningRecognizerRunnerViewDelegate;
@protocol MBRecognizerRunnerViewControllerDelegate;
@protocol MBDebugRecognizerRunnerViewDelegate;

@class PPOcrLayout;
@class PPMetadata;
@class PPRecognizerResult;


/**
 Overlay View Controller is an abstract class for all overlay views placed on top PhotoPay's Camera View Controller.

 It's responsibility is to provide meaningful and useful interface for the user to interact with.

 Typical actions which need to be allowed to the user are:

 - intuitive and meaniningful way to guide the user through scanning process. This is usually done by presenting a
    "viewfinder" in which the user need to place the scanned object
 - a way to cancel the scanining, typically with a "cancel" or "back" button
 - a way to power on and off the light (i.e. "torch") button

 PhotoPay always provides it's own default implementation of the Overlay View Controller for every specific use.
 Your implementation should closely mimic the default implementation as it's the result of thorough testing with
 end users. Also, it closely matches the underlying scanning technology.

 For example, the scanning technology usually gives results very fast after the user places the device's camera in the
 expected way above the scanned object. This means a progress bar for the scan is not particularly useful to the user.
 The majority of time the user spends on positioning the device's camera correctly. That's just an example which
 demonstrates careful decision making behind default camera overlay view.

 PhotoPay demo project in your development package contain `PPCameraOverlayViewController` class, an example of
 custom overlay view implementation.

 # Initialization

 To use your custom overlay with PhotoPay's camera view, you must subclass MBOverlayViewController and
 specify it when initializing CameraViewController:

    PPCameraOverlayViewController *overlayViewController =
        [[PPCameraOverlayViewController alloc] initWithNibName:@"PPCameraOverlayViewController" bundle:nil];

    // Create camera view controller
    UIViewController *cameraViewController =
        [coordinator cameraViewControllerWithDelegate:self overlayViewController:overlayViewController];

 Note: if you create camera view controller without specifying overlay view, the default overlay implementation will be used:

    // Create camera view controller
    UIViewController *cameraViewController =
        [coordinator cameraViewControllerWithDelegate:self];

 As with any view controller, you are responsible for specifying UI elements and handling their actions.
 Besides that, there are some requirements for interaction with Camera View Controller.

 # Interaction with CameraViewController

 CameraViewController is a Container view controller to the MBOverlayViewController instances.
 For more about Container View Controllers, read official Apple [View Controller Programming Guide].

 Also, each instance of MBOverlayViewController and it's subclasses has access to the Container View Controller.

    // Overlay View's delegate object. Responsible for sending messages
    // to PhotoPay's Camera View Controller
    @property (nonatomic, assign) id<MBOverlayContainerViewController> containerViewController;

 # Handling orientation changes

 Camera view controller is always presented in Portrait mode, but nevertheless, your overlay view be presented in the
 current device orientation. There are two ways to handle orientation changes.

 The first, built in way is a simple way to achieve autorotation. Your Overlay View Controller only needs to implement
 standard UIViewController methods which specify which orientations are supported. For example, to support only landscape
 orientations, you need to add the following methods to your Overlay View Controller implementation.

    - (NSUInteger)supportedInterfaceOrientations {
        return UIInterfaceOrientationMaskLandscape;
    }

    - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
        return UIInterfaceOrientationLandscapeRight;
    }

    - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation ==
 UIInterfaceOrientationLandscapeRight);
    }

 Your Overlay View Controller will automatically rotate to support all orientations returned by `supportedInterfaceOrientations`
 method. You are responsible for standard iOS techniques (auto-layout or autoresizing masks) to adjust the UI to new
 device orientation.

 You can manually disable autorotation by initializing `PPCoordinator` object with the following setting:

    [coordinatorSettings setValue:@(NO) forKey:kPPOverlayShouldAutorotate];


 # Steps for providing custom Camera Overlay View

 1. Create a subclass of `MBOverlayViewController`. You can use XIB for user interface, or create UI from code.

 2. See if there are any events received from `CameraViewController` which you need to handle for your UI hierarchy

 3. Implement your view hierarchy.

    If you have a Cancel button in your view, don't forget to call `overlayViewControllerWillCloseCamera:`
    method on overlay's delegate object when cancel is pressed.

    If you have Torch button, dont forget to check if Torch should be displayed by using
    `overlayViewControllerShouldDisplayTorch:` method, and to report new torch state with
    `overlayViewController:willSetTorch:` method.

 4. Handle orientation changes, either by implementing standard UIViewController autorotation metods,
    or by custom rotation management on rotation events.

 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBOverlayViewController : UIViewController

/**
 Overlay View's delegate object. Responsible for sending messages to PhotoPay's
 Camera View Controller
 */
@property (nonatomic, weak) UIViewController<MBOverlayContainerViewController> *containerViewController;

@property (nonatomic, weak) id<MBOverlayViewControllerInterface> overlayViewControllerInterfaceDelegate;

/**
 Overlay View's recognizer runner controller. Responsible for sending messages to camera view controller
 */
@property (nonatomic, strong) UIViewController<MBRecognizerRunnerViewController> *recognizerRunnerViewController;


/**
 Scanning region in which the scaning is performed.
 Image is cropped to this region.

 Should be provided in the following coordinate system.
 - Upper left point has coordinates (0.0f, 0.0f) and corresponds to upper left corner of the overlay view
 - Lower right corner has coordinates (1.0f, 1.0f) and corresponds to lower right corner of the overlay view

 CGRect provided here specifies the origin (upper left point) of the scanning region, and the size of the
 region in hereby described coordinating system.
 */
@property (nonatomic) CGRect scanningRegion;

/**
 * If YES, default camera overlay will display Cancel button.
 * Usually, if camera is displayed inside Navigation View Controler, this is reasonable to set to NO.
 *
 * Default: YES.
 */
@property (nonatomic, assign) BOOL showCloseButton;

/**
 * If YES, default camera overlay will display Torch button.
 * Usually, if camera is displayed inside Navigation View Controler, this is reasonable to set to NO.
 *
 * Default: YES.
 */
@property (nonatomic, assign) BOOL showTorchButton;

/**
 * If YES, default camera overlay will display Status bar.
 * Usually, if camera is displayed inside Navigation View Controler, this is reasonable to set to YES.
 *
 * Default: NO.
 */
@property (nonatomic, assign) BOOL showStatusBar;

@end

NS_ASSUME_NONNULL_END
