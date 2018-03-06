//
//  CustomOverlay.h
//  pdf417-sample
//
//  Created by Dino Gustin on 05/03/2018.
//  Copyright © 2018 MicroBlink. All rights reserved.
//

#import <MicroBlink/MicroBlink.h>

@interface CustomOverlay : MBOverlayViewController <MBOverlayViewControllerInterface>

@end

@protocol MBCustomOverlayViewControllerDelegate <NSObject>

- (void)customOverlayViewControllerDidFinishScanning:(nonnull CustomOverlay *)overlayViewController state:(MBRecognizerResultState)state;

- (void)customOverlayViewControllerDidTapClose:(nonnull CustomOverlay *)overlayViewController;

@end
