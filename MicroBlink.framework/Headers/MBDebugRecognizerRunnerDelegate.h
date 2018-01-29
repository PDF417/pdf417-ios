//
//  MBDebugRecognizerRunnerDelegate.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 04/01/2018.
//

@class MBRecognizerRunner;
@class PPMetadata;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol for obtaining debug metadata
 */
@protocol MBDebugRecognizerRunnerDelegate <NSObject>
@required
/**
 * Scanning library did output debug metadata
 */
- (void)recognizerRunnerDidOutputDebugMetadata:(nonnull MBRecognizerRunner *)recognizerRunner metadata:(PPMetadata *)metadata;

@end

NS_ASSUME_NONNULL_END
