//
//  MBSuccessFrameGrabberRecognizerResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 22/12/2017.
//

#import <Foundation/Foundation.h>
#import "MBMicroblinkDefines.h"
#import "MBRecognizerResult.h"

@class MBBImage;

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognizer that returns SuccessFrameGrabber result.
 */
MB_CLASS_AVAILABLE_IOS(8.0)

@interface MBBSuccessFrameGrabberRecognizerResult : MBBRecognizerResult<NSCopying>

MB_INIT_UNAVAILABLE

/**
 * Success frame MBBImage of successful frame
 */
@property (nonatomic, strong, readonly) MBBImage *successFrame;

@end

NS_ASSUME_NONNULL_END
