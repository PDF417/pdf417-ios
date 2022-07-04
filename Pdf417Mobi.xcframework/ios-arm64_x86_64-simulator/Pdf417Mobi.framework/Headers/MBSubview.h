//
//  MBSubview.h
//  BarcodeFramework
//
//  Created by Jura on 06/06/14.
//  Copyright (c) 2015 Microblink Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBMicroblinkDefines.h"

NS_ASSUME_NONNULL_BEGIN


@protocol MBBSubviewDelegate;

/**
 Base class for all overlay subviews
 */
MB_CLASS_AVAILABLE_IOS(8.0)
@interface MBBSubview : UIView

/** Delegate which is notified on Overlay events */
@property (nonatomic, weak, nullable) id<MBBSubviewDelegate> delegate;

@end

/**
 * Protocol which all objects interested in receiving information about overlay subviews need to implement
 */
@protocol MBBSubviewDelegate <NSObject>

/** Delegate method called when animation starts */
- (void)subviewAnimationDidStart:(MBBSubview *)subview;

/** Delegate method called when animation finishes */
- (void)subviewAnimationDidFinish:(MBBSubview *)subview;

@end

NS_ASSUME_NONNULL_END
