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
@class PPCameraManager;

/**
 * This object is the mastermind of the scanning process.
 * It combines management of hardware (camera, accelerometer, etc) with
 * user logic
 */
@interface PPBarcodeCoordinator : NSObject

/** delegate object which will be control camera view related events */
@property (nonatomic, assign) id<PPCameraViewDelegate> viewDelegate;

/** delegate object for notifying the caller on recognition results */
@property (nonatomic, assign) id<PPBarcodeDelegate> barcodeDelegate;

/** flag indicating active recognizer */
@property (nonatomic, assign, getter = isActive, readonly) BOOL active;

/** Object which will take care of the camera */
@property (nonatomic, retain) PPCameraManager *cameraManager;

/** Plist file with help content */
@property (nonatomic, retain) NSString* helpContentFile;

/**
 * Initializes the object in proper state
 * Should always be used for initialization
 */
- (id)initWithSettings:(NSMutableDictionary*)inSettings;

/**
 * Method creates and shows a camera view controller
 * which is responsible for displaying the camera input on the phone screen.
 * Also, it is necessary to set a reference to PhotoPayDelegate object for
 * retrieving photopay results.
 *
 * Note the prefix create: the caller owns the returned object and is responsible for releasing it.
 */
- (UIViewController*)cameraViewControllerWithDelegate:(id<PPBarcodeDelegate>)delegate;

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

/** responds to tap events */
- (void)handleTapWithLocation:(CGPoint)tapPoint;

/** Torch mode is set to on or off */
- (void)setTorchEnabled:(BOOL)isEnabled;

/** starts the frame retreiving process */
- (void)startReceivingFrames;

/** stops the frame retreiving process */
- (void)stopReceivingFrames;

/** returns the video preview layer which will be shown on screen */
- (AVCaptureVideoPreviewLayer *) getVideoPreviewLayer;

/** returns the video input device which controls the frame taking */
- (AVCaptureDeviceInput *) getVideoInput;

/** Returns the size of video frames in pixels (eg 640, 480) */
- (CGSize)getApertureSize;

/** Plays sound which marks scan success */
- (void)playScanSuccesSound;

/**
 * This method is called when barcode scannning is unsupported 
 * on a specific device.
 * Error object contains description of the reason for that.
 */
+ (BOOL)isScanningUnsupported:(NSError **)error;

@end
