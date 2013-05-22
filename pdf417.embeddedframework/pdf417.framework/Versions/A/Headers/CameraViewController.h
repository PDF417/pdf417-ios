//
//  CameraViewController.h
//  BarcodeFramework
//
//  Created by Jurica Cerovec on 5/12/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DetectionStatus.h"

@class PPBarcodeCoordinator;
@class PPScanningResult;

@interface CameraViewController : UIViewController

/** Orientation of HUD on screen */
@property (nonatomic, assign) UIInterfaceOrientationMask orientationHudMask;

/** Margin of the viewfinder on the screen, default is 5px */
@property (nonatomic, assign) CGFloat marginViewfinder;

/** Margin of the hud inside the viewfinder. Default is the same as marginViewfidner */
@property (nonatomic, assign) CGFloat marginHud;

/** Initializes the view controller */
- (id)initWithCoordinator:(PPBarcodeCoordinator*)inCoordinator
       shouldPresentModal:(BOOL)inPresentModal
   shouldPresentDebugInfo:(BOOL)inPresentDebugInfo
        shouldPresentHelp:(BOOL)inPresentHelp
       shouldPresentToast:(BOOL)inPresentToast
                isValid:(BOOL)isValid;

/** Scanning control */
- (void) pauseScanning;
- (void) resumeScanning;

/** check to see if the device is not supported */
+ (BOOL) isDeviceNotSupportedWithError:(NSError **)anError;

@end

/**
 * Delegate functions
 */
@protocol PPCameraViewDelegate<NSObject>

@required

/** Called when the recognition of a current image is initiated */
- (void)coordinatorDidStartDetection:(id)coordinator;

/** Determines if the images should be passed to the calling application */
- (BOOL)coordinatorShouldObtainAdditionalData:(id)coordinator;

/** Called when coordinator obtaines intermediate images */
- (void)coordinator:(id)coordinator obtainedImage:(UIImage*)image withName:(NSString*)name type:(NSString*)type;

/** Called when coordinator obtaines intermediate images */
- (void)coordinator:(id)coordinator obtainedText:(NSString*)name withName:(NSString*)name type:(NSString*)type;

/** Called when the recognition manager finds the element on the image and returns
 the coordinates of found element */
- (void)coordinator:(id)coordinator didFindLocation:(NSArray*)cornerPoints withStatus:(PPDetectionStatus)status;

/** Called when the recognition of a current image starts */
- (void)coordinatorDidStartRecognition:(id)coordinator;

/** Called when the recognition of a current image finishes with result */
- (void)coordinator:(id)coordinator didFinishRecognitionWithResult:(PPScanningResult*)result;

/** Called when the recognition times out and returns the best result found */
- (void)coordinator:(id)coordinator didTimeoutWithResult:(PPScanningResult*)result;

/** Called when the recognition times out and returns the best result found */
- (void)coordinator:(id)coordinator didPublishProgress:(float)progress;

@end
