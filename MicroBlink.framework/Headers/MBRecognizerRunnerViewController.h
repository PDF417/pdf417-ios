//
//  MBRecognizerRunnerViewController.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 13/12/2017.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#import "MBDetectionStatus.h"
#import "MBScanningBaseCameraViewController.h"
#import "MBSettings.h"
#import "PPMicroBlinkDefines.h"

@class MBSettings;
@class MBCameraCoordinator;

NS_ASSUME_NONNULL_BEGIN

/**
 * MBRecognizerRunnerViewController coordinates hardware control with the recognition algorithms,
 */
@interface MBRecognizerRunnerViewController : MBScanningBaseCameraViewController

@property (nonatomic, nullable) MBCameraCoordinator *cameraCoordinator;

- (instancetype)init NS_UNAVAILABLE;

/** Initializes the view controller */
- (instancetype)initWithSettings:(MBSettings *)settings NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
