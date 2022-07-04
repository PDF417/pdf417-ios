//
//  MBRecognizerRunnerView.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 20/12/2017.
//

#import <Foundation/Foundation.h>

#import "MBMicroblinkDefines.h"
#import "MBRecognizerRunnerMetadataDelegates.h"
#import "MBScanningRecognizerRunnerDelegate.h"
#import "MBImageProcessingRecognizerRunnerDelegate.h"
#import "MBStringProcessingRecognizerRunnerDelegate.h"

@class MBBCoordinator;
@class MBBImage;
@class MBBRecognizerCollection;

NS_ASSUME_NONNULL_BEGIN

/**
 * Factory class containing static methods for creating camera view controllers.
 * Camera view controllers created this way will be managed internally by the SDK, and input frames will be processed.
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBBRecognizerRunner : NSObject

@property (nonatomic, strong, nonnull, readonly) MBBRecognizerRunnerMetadataDelegates *metadataDelegates;
@property (nonatomic, weak) id<MBBScanningRecognizerRunnerDelegate> scanningRecognizerRunnerDelegate;
@property (nonatomic, weak, nullable) id<MBBImageProcessingRecognizerRunnerDelegate> imageProcessingRecognizerRunnerDelegate;
@property (nonatomic, weak, nullable) id<MBBStringProcessingRecognizerRunnerDelegate> stringProcessingRecognizerRunnerDelegate;

@property (nonatomic, nullable) MBBCoordinator *coordinator;

- (instancetype)init NS_UNAVAILABLE;

/** Initializes the recognizer runner */
- (instancetype)initWithRecognizerCollection:(MBBRecognizerCollection *)recognizerCollection NS_DESIGNATED_INITIALIZER;

- (void)resetState;

- (void)resetState:(BOOL)hard;

/**
 * Cancels all dispatched, but not yet processed image processing requests issued with processImage.
 * NOTE: next call to processImage will resume processing.
 */
- (void)cancelProcessing;

/**
 * Processes a MBBImage object synchronously using current settings.
 * Since this method is synchronous, calling it from a main thread will switch the call to alternate thread internally and output a warning.
 *
 * Results are passed a delegate object given upon a creation of MBBCoordinator.
 *
 *  @param image            image for processing
 */
- (void)processImage:(MBBImage *)image;

/**
 * Processes a NSString object synchronously using current settings.
 * Since this method is synchronous, calling it from a main thread will switch the call to alternate thread internally and output a warning.
 *
 * Results are passed a delegate object given upon a creation of MBBCoordinator.
 *
 *  @param string            string for processing
 */
- (void)processString:(NSString *)string;

/**
 * Method which is used to apply MBBSettings object given by currentSettings property
 *
 * Usual use case is to update settings on the fly, to perform some complex scanning functionality
 * where a reconfiguration of the recognizers is needed.
 */
- (void)reconfigureRecognizers:(MBBRecognizerCollection *)recognizerCollection;

@end

NS_ASSUME_NONNULL_END
