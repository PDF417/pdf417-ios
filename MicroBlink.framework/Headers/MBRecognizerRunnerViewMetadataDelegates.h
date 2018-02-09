#import <Foundation/Foundation.h>
#import "PPMicroBlinkDefines.h"

@protocol MBDetectionRecognizerRunnerViewDelegate;
@protocol MBDebugRecognizerRunnerViewDelegate;

@class MBOverlayViewController;

NS_ASSUME_NONNULL_BEGIN

/**
 * Class containing all metadata delegates
 */
PP_CLASS_AVAILABLE_IOS(8.0)
@interface MBRecognizerRunnerViewMetadataDelegates : NSObject

@property (nonatomic, weak) MBOverlayViewController<MBDetectionRecognizerRunnerViewDelegate> *detectionRecognizerRunnerViewDelegate;
@property (nonatomic, weak) MBOverlayViewController<MBDebugRecognizerRunnerViewDelegate> *debugRecognizerRunnerViewDelegate;

@end

NS_ASSUME_NONNULL_END