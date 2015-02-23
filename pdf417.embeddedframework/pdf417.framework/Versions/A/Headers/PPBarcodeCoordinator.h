//
//  PPBarcodeCoordinator.h
//  BarcodeFramework
//
//  Created by Jurica Cerovec on 5/12/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PPBarcode.h"

@protocol PPCameraViewDelegate;
@protocol PPBarcodeDelegate;
@protocol PPScanningViewController;
@class PPCameraManager;
@class PPOverlayViewController;
@class PPAccelerometerManager;

/**
 * This object is the mastermind of the scanning process.
 * It combines management of hardware (camera, accelerometer, etc) with
 * user logic
 */
@interface PPBarcodeCoordinator : NSObject

/** delegate object which will be control camera view related events */
@property (nonatomic, weak) id<PPCameraViewDelegate> viewDelegate;

/** delegate object for notifying the caller on recognition results */
@property (nonatomic, weak) id<PPBarcodeDelegate> barcodeDelegate;

/** flag indicating active recognizer */
@property (nonatomic, assign, getter = isActive, readonly) BOOL active;

/** Object which will take care of the camera */
@property (nonatomic, strong) PPCameraManager *cameraManager;

/** We need an acceleration manager object because we're interested in events regarding device movement */
@property (nonatomic, strong) PPAccelerometerManager *accelerometerManager;

/** Orientation of toast messages */
@property (nonatomic, assign) UIInterfaceOrientationMask hudOrientation;

/**
 * Initializes the object in proper state
 * Should always be used for initialization
 */
- (instancetype)initWithSettings:(NSMutableDictionary*)inSettings;

/**
 * Method creates and shows a camera view controller
 * which is responsible for displaying the camera input on the phone screen.
 * Also, it is necessary to set a reference to PhotoPayDelegate object for
 * retrieving photopay results.
 *
 * Note the prefix create: the caller owns the returned object and is responsible for releasing it.
 */
- (UIViewController<PPScanningViewController>*)cameraViewControllerWithDelegate:(id<PPBarcodeDelegate>)delegate;

/**
 * Helper method for initializing with overlay view
 */
- (UIViewController<PPScanningViewController>*)cameraViewControllerWithDelegate:(id<PPBarcodeDelegate>)delegate
                                                          overlayViewController:(PPOverlayViewController*)overlayViewController;

/**
 * Starts the camera session, flash, torch and frame saving process. Also makes the camera do the autofocus
 * IMPORTANT: must be called only after initWithSettings...
 */
- (BOOL)start;

/**
 * Pauses the frame saving process and stops the camera session.
 * If called before stop, it's a noop.
 */
- (BOOL)stop;

/** Camera did load preview */
- (void)cameraDidLoad;

/** Torch mode is set to on or off */
- (void)setTorchEnabled:(BOOL)isEnabled;

/** starts the frame retreiving process */
- (void)startReceivingFrames;

/** stops the frame retreiving process */
- (void)stopReceivingFrames;

/** Returns the size of video frames in pixels (eg 640, 480) */
- (CGSize)getApertureSize;

/** Sets the scanning region. CGRect is given in coordinate system of the camera */
- (void)setScanningRegion:(CGRect)scanningRegion;

/** Plays sound which marks scan success */
- (void)playScanSuccesSound;

/** Updates the aperture size to current camera view size */
- (void)updateApertureSize;

/**
 * This method is called when barcode scannning is unsupported 
 * on a specific device.
 * Error object contains description of the reason for that.
 */
+ (BOOL)isScanningUnsupported:(NSError **)error;
    
/**
 * This method returns the string that contains the library build version
 * information.
 */
+ (NSString*)getBuildVersionString;

@end
