//
//  MBSuccessFrameGrabberRecognizer.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 22/12/2017.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBRecognizer.h"
#import "MBSuccessFrameGrabberRecognizerResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognizer that can returns success frame.
 */
MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBBSuccessFrameGrabberRecognizer : MBBRecognizer<NSCopying>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRecognizer:(MBBRecognizer *)recognizer NS_SWIFT_NAME(init(recognizer:)) NS_DESIGNATED_INITIALIZER;

/**
 * SuccessFrameGrabber recognizer results
 */
@property (nonatomic, strong, readonly) MBBSuccessFrameGrabberRecognizerResult *result;

/**
 * Slave recognizer that is wrapped with SuccessFrameGrabber
 */
@property (nonatomic, strong, readonly) MBBRecognizer *slaveRecognizer;

@end

NS_ASSUME_NONNULL_END
