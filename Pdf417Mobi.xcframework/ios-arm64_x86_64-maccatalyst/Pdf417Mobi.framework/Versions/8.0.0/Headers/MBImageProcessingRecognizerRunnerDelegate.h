//
//  MBImageProcessingDelegate.h
//  Microblink
//
//  Created by DoDo on 07/05/2018.
//

@class MBBRecognizerRunner;
@class MBBImage;

@protocol MBBImageProcessingRecognizerRunnerDelegate <NSObject>
@required

/**
 * Called when MBBRecognizerRunner finishes processing given image.
 * NOTE: This method is called on background processing thread. Make sure that you dispatch all your UI API calls to main thread.
 */
- (void) recognizerRunner:(nonnull MBBRecognizerRunner *)recognizerRunner didFinishProcessingImage:(nonnull MBBImage *)image;

@end
