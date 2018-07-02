//
//  CustomOverlay.h
//  pdf417-sample
//
//  Created by Dino Gustin on 05/03/2018.
//  Copyright © 2018 MicroBlink. All rights reserved.
//

#import <MicroBlink/MicroBlink.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBCustomOverlayViewControllerDelegate;

@interface CustomOverlay : MBOverlayViewController <MBOverlayViewControllerInterface>

+ (instancetype)initFromStoryboardWithSettings:(MBSettings *)settings andDelegate:(id<MBCustomOverlayViewControllerDelegate>)delegate;

@end

@protocol MBCustomOverlayViewControllerDelegate <NSObject>

- (void)customOverlayViewControllerDidFinishScanning:(nonnull CustomOverlay *)overlayViewController state:(MBRecognizerResultState)state;

- (void)customOverlayViewControllerDidTapClose:(nonnull CustomOverlay *)overlayViewController;

@end

NS_ASSUME_NONNULL_END
