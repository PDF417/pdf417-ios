//
//  PPCameraSettings.h
//  PhotoPayFramework
//
//  Created by Jura on 23/02/15.
//  Copyright (c) 2015 Microblink Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "MBMicroblinkDefines.h"

/**
 * Camera resolution preset
 */
typedef NS_ENUM(NSInteger, MBBCameraPreset) {

    /** 480p video will always be used */
    MBBCameraPreset480p,

    /** 720p video will always be used */
    MBBCameraPreset720p,
    
    /** 1080p video will always be used */
    MBBCameraPreset1080p,
    
    /** 4K video will always be used */
    MBBCameraPreset4K,

    /** The library will calculate optimal resolution based on the use case and device used */
    MBBCameraPresetOptimal,

    /** Device's maximal video resolution will be used. */
    MBBCameraPresetMax,

    /** Device's photo preview resolution will be used */
    MBBCameraPresetPhoto,
};

/**
 * Camera type
 */
typedef NS_ENUM(NSInteger, MBBCameraType) {

    /** Back facing camera */
    MBBCameraTypeBack,

    /** Front facing camera */
    MBBCameraTypeFront
};

/**
 * Camera autofocus restricion mode
 */
typedef NS_ENUM(NSInteger, MBBCameraAutofocusRestriction) {

    /** Default. Indicates that the autofocus system should not restrict the focus range. */
    MBBCameraAutofocusRestrictionNone,

    /** Indicates that the autofocus system should restrict the focus range for subject matter that is near to the camera. */
    MBBCameraAutofocusRestrictionNear,

    /** Indicates that the autofocus system should restrict the focus range for subject matter that is far from the camera. */
    MBBCameraAutofocusRestrictionFar,
};

/**
 * Settings class containing parameters for camera capture
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBBCameraSettings : NSObject <NSCopying>

/**
 * Camera preset. With this property you can set the resolution of the camera
 *
 * Default: MBBCameraPresetOptimal
 */
@property (nonatomic, assign) MBBCameraPreset cameraPreset;

/**
 * Camera type. You can choose between front and back facing.
 *
 * Default: MBBCameraTypeBack
 */
@property (nonatomic, assign) MBBCameraType cameraType;

/**
 * Interval between forcing two camera focuses. If <= 0, forced focuses arent performed
 * and only continuous autofocus mode will be used.
 *
 * Default
 *  - 10.0f for BlinkID and BlinkOCR product
 *  - 8.0f for PhotoPay, pdf417 and other products
 */
@property (nonatomic, assign) NSTimeInterval autofocusInterval;

/**
 * Range restriction for camera autofocus.
 *
 * Default: MBBCameraAutofocusRestrictionNone
 */
@property (nonatomic, assign) MBBCameraAutofocusRestriction cameraAutofocusRestriction;

/**
 * Gravity of Camera preview on screen.
 *
 * Default: AVLayerVideoGravityResizeAspectFill
 */
@property (nonatomic, weak) NSString *videoGravity;

/**
 * Point against which the autofocus will be performed
 *
 * Default (0.5f, 0.5f) - middle of the screen.
 */
@property (nonatomic, assign) CGPoint focusPoint;

/**
 * Tells whether camera input images should be mirrored horizontally before processing
 *
 * Default: NO
 */
@property (nonatomic) BOOL cameraMirroredHorizontally;

/**
 * Tells whether camera input images should be mirrored vertically before processing
 *
 * Default: NO
 */
@property (nonatomic) BOOL cameraMirroredVertically;

/**
 * Designated initializer. Initializes the object with default settings (see above for defaults)
 *
 *  @return object initialized with default values.
 */
- (instancetype)init;

/**
 * Returns an optimal AVFoundation session preset based on cameraPreset value.
 *
 * @return optimal AVFoundation session preset
 */
- (NSString *)calcSessionPreset;

/**
 * Returns an optimal AVFoundation autofocus range restriction value based on cameraAutofocusRestriction.
 *
 * @return optimal AVFoundation autofocus range restriction
 */
- (AVCaptureAutoFocusRangeRestriction)calcAutofocusRangeRestriction;

@end
