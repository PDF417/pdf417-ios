//
//  PPOverlayViewController.h
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 5/28/13.
//  Copyright (c) 2013 Racuni.hr. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "PPDetectionStatus.h"

@protocol PPOverlayViewControllerDelegate;
@class PPOcrResult;

/**
 Overlay View Controller is an abstract class for all overlay views placed on top PhotoPay's 
    Camera View Controller.
 
 It's responsibility is to provide meaningful and useful interface for the user to interact with.
 
 Typical actions which need to be allowed to the user are:
 
 - intuitive and meaniningful way to guide the user through scanning process. 
    This is usually done by presenting a "viewfinder" in which the user need to place the scanned object
 - a way to cancel the scanining, typically with a "cancel" or "back" button
 - a way to power on and off the light (i.e. "torch") button
 
 PhotoPay always provides it's own default implementation of the Overlay View Controller for 
 every specific use. Your implementation should closely mimic the default implementation as 
 it's the result of thorough testing with end users. Also, it closely matches the underlying 
 scanning technology.
 
 For example, the scanning technology usually gives results very fast after the user places 
 the device's camera in the expected way above the scanned object. This means a progress bar 
 for the scan is not particularly useful to the user. The majority of time the user spends 
 on positioning the device's camera correctly. That's just an example which demonstrates careful 
 decision making behind default camera overlay view.
 
 ### Initialization
 
 To use your custom overlay with PhotoPay's camera view, you must subclass PPOverlayViewController 
 and specify it when initializing CameraViewController:
 
    PPCameraOverlayViewController *overlayViewController =
        [[PPCameraOverlayViewController alloc] initWithNibName:@"PPCameraOverlayViewController" bundle:nil];
 
    // Create camera view controller
    UIViewController *cameraViewController =
        [coordinator cameraViewControllerWithDelegate:self overlayViewController:overlayViewController];
 
 Note: if you create camera view controller without specifying overlay view, the default overlay implementation will be used:
 
    // Create camera view controller
    UIViewController *cameraViewController = [coordinator cameraViewControllerWithDelegate:self];
 
 As with any view controller, you are responsible for specifying UI elements and handling their actions.
 Besides that, there are some requirements for interaction with Camera View Controller. See PPOverlayViewController's 
 methods for more details.
 
 ### Handling orientation changes
 
 Camera view controller is always presented in Portrait mode, but nevertheless, your overlay view be presented in 
 the current device orientation. There are two ways to handle orientation changes.
 
 The first, built in way is a simple way to achieve autorotation. Your Overlay View Controller only needs to 
 implement standard UIViewController methods which specify which orientations are supported. For example, to support 
 only landscape orientations, you need to add the following methods to your Overlay View Controller implementation.
 
    - (BOOL)shouldAutorotate {
        return YES;
    }
 
    - (NSUInteger)supportedInterfaceOrientations {
        return UIInterfaceOrientationMaskLandscape;
    }
 
    - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
        return UIInterfaceOrientationLandscapeRight;
    }
 
    - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
 
 If `shouldAutorotate` method returns YES, your Overlay View Controller will automatically rotate to
 support all orientations returned by `supportedInterfaceOrientations` method. You are responsible for
 standard iOS techniques (auto-layout or autoresizing masks) to adjust the UI to new device orientation.
 
 The other method gives you full control over the orientation changes. There are orientation handling methods:
 
    - (void)cameraViewController:(id)cameraViewController willRotateToOrientation:(UIDeviceOrientation)orientation;
    - (void)cameraViewController:(id)cameraViewController didRotateToOrientation:(UIDeviceOrientation)orientation;
 
 You can use those methods to fully replace your view hierarchy for the specific device orientation.
 With this approach you have full control over rotation of your views, but you'll need more work to get the
 desired effect. To use this approach, you only need to specify that your view controller doesn't
 want to autorotate (which is also by default):
 
    - (BOOL)shouldAutorotate {
        return NO;
    }
 
 All of PhotoPay's default overlay views are implemented in this way and have custom rotation animations.
 
 ### Steps for providing custom Camera Overlay View
 
 1. Create a subclass of `PPOverlayViewController`. You can use XIB for user interface, 
    or create UI from code.
 
 2. See if there are any events received from `CameraViewController` which you need 
    to handle for your UI hierarchy
 
 3. Implement your view hierarchy.
 
    If you have a Cancel button in your view, don't forget to call `overlayViewControllerWillCloseCamera:` 
    method on overlay's delegate object when cancel is pressed.
 
    If you have Torch button, dont forget to check if Torch should be displayed by using 
    `overlayViewControllerShouldDisplayTorch:` method, and to report new torch state with 
    `overlayViewController:willSetTorch:` method.
 
 4. Handle orientation changes, either by implementing standard UIViewController autorotation 
    metods, or by custom rotation management on rotation events.
 
 */
@interface PPOverlayViewController : UIViewController {
    id<PPOverlayViewControllerDelegate> delegate_;
}

/** 
 Overlay View's delegate object. Responsible for sending messages to PhotoPay's 
 Camera View Controller
 */
@property (nonatomic, assign) id<PPOverlayViewControllerDelegate> delegate;

/**
 Scanning region used by pdf417.mobi
 */
@property (nonatomic, assign) CGRect scanningRegion;

/**
 Camera view appears and the scanning resumes. This happens when the camera view
 is opened, or when the app enters foreground with camera view displayed.
 */
- (void)cameraViewControllerDidResumeScanning:(id)cameraViewController;

/** 
 Camera view disappears and the scanning pauses. This happens when the camera view 
 is closed, or when the app enters background with camera view displayed.
 */
- (void)cameraViewControllerDidStopScanning:(id)cameraViewController;

/** 
 Camera view controller started the new recognition cycle. Since recognition is done 
 on video frames, there might be multiple recognition cycles before the scanning completes 
 */
- (void)cameraViewControllerDidStartRecognition:(id)cameraViewController;

/** 
 Camera view reports the progress of the current OCR/barcode scanning recognition cycle. 
 Note: this is not the actual progress from the moment camera appears. 
 This might not be meaningful for the user in all cases. 
 */
- (void)cameraViewController:(id)cameraViewController
          didPublishProgress:(float)progress;

/**
 Camera view reports the status of the object detection. Scanning status contain information 
 about whether the scan was successful, whether the user holds the device too far from 
 the object, whether the angles was too high, or the object isn't seen on the camera in 
 it's entirety. If the object was found, the corner points of the object are returned.
 */
- (void)cameraViewController:(id)cameraViewController
             didFindLocation:(NSArray*)cornerPoints
                  withStatus:(PPDetectionStatus)status;

/**
 Camera view resports obtained ocr result
 
 Besides the ocr result itself, we get the ID of the result so we can 
 distinguish consecutive results of the same area on the image
 */
- (void)cameraViewController:(id)cameraViewController
          didObtainOcrResult:(PPOcrResult*)ocrResult
                withResultName:(NSString*)resultName;

/** 
 Camera view controller ended the recognition cycle with a certain Scanning result. 
 The scanning result might be considered as valid, meaning it can be presented to the user for inspection. 
 Use this method only if you need UI update on this event (although this is unnecessary in many cases). 
 The actual result will be passed to your PPPhotoPayDelegate object. 
 */
- (void)cameraViewController:(id)cameraViewController
didFinishRecognitionWithResult:(id)result;

/**
 Camera view controller ended the recognition cycle with a certain Scanning result, but the 
 timeout occurred in the meantime. The scanning result cannot be considered as full and valid, 
 but it still might be useful to the user. Use this method only if you need UI update on 
 this event (although this is unnecessary in many cases).
 */
- (void)cameraViewController:(id)cameraViewController
        didTimeoutWithResult:(id)result;

/** 
 Camera view controller will start the rotation to specific device orientation.
 
 Deprecated. Use UIViewController's method 
 - willRotateToInterfaceOrientation:duration:
 */
- (void)cameraViewController:(id)cameraViewController
     willRotateToOrientation:(UIDeviceOrientation)orientation __deprecated;

/**
 UIViewController's method called when a rotation to a given 
 interface orientation is about to happen
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration;

/** 
 Camera view controller did complete the rotation to specific device orientation. 
 
 Deprecated. Use UIViewController's method
 - didRotateFromInterfaceOrientation:
 */
- (void)cameraViewController:(id)cameraViewController
      didRotateToOrientation:(UIDeviceOrientation)orientation __deprecated;

/**
 UIViewController's method called immediately after the rotation from a given
 interface orientation happened
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;

/**
 UIViewController's method called inside an animation block. Any changes you make
 to your UIView's inside this method will be animated
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration;

@end


/**
 Overlay View Controller also needs to notify CameraViewController on certain events. 
 Those are events specified by PPOverlayViewControllerDelegate protocol.
 */
@protocol PPOverlayViewControllerDelegate <NSObject>

@required

/** 
 Notification sent when Overlay View Controller wants to close camera, for example, 
 by pressing Cancel button.
 */
- (void)overlayViewControllerWillCloseCamera:(id)overlayViewController;

/** 
 Overlay View Controller should ask it's delegete if it's necessary to display Cancel button. 
 This might not always be necessary, for example, when Camera View Controller is 
 presented on Navigation View Controller which has it's own Back button.
 */
- (BOOL)overlayViewControllerShouldDisplayCancel:(id)overlayViewController;

/**
 Overlay View Controller should ask it's delegete if it's necessary to display Torch (Light) button. 
 Torch button is not necessary if the device doesn't support torch mode (e.g. iPad devices).
 */
- (BOOL)overlayViewControllerShouldDisplayTorch:(id)overlayViewController;

/** 
 Overlay View Controller must notify it's delegete to set the torch mode to On or Off
 */
- (void)overlayViewController:(id)overlayViewController
                 willSetTorch:(BOOL)isTorchOn;

/**
 Overlay View Controller can ask it's delegete about the status of Torch
 */
- (BOOL)isTorchOn;

/**
 Overlay View Controller can get Video Capture Preview Layer object from it's delegete.
 */
- (AVCaptureVideoPreviewLayer*)getPreviewLayer;

@end