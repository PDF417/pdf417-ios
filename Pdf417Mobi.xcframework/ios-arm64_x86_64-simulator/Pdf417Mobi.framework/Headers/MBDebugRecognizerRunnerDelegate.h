//
//  MBDebugRecognizerRunnerDelegate.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 04/01/2018.
//

@class MBBRecognizerRunner;
@class MBBImage;

/**
 * Protocol for obtaining debug metadata
 */
@protocol MBBDebugRecognizerRunnerDelegate <NSObject>
@optional

/**
 * Scanning library did output debug image
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void)recognizerRunner:(nonnull MBBRecognizerRunner *)recognizerRunner didOutputDebugImage:(nonnull MBBImage *)image;

/**
 * Scanning library did output debug text
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void)recognizerRunner:(nonnull MBBRecognizerRunner *)recognizerRunner didOutputDebugText:(nonnull NSString *)text;

@end
