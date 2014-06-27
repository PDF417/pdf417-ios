//
//  PPOcrLineAnimationViewLayer.h
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 19/11/13.
//  Copyright (c) 2013 Racuni.hr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PPYOverlaySubview.h"

/**
 A wrapper around CAShapeLayer which is used for presenting a status about payslip and barcode detection.
 
 The layer is used to draw a scanning window with a viewwinder.
 */
@interface PPYViewfinderOverlaySubview : NSObject<PPYOverlaySubview>

/** Delegate which is notified on Overlay events */
@property (nonatomic, assign) id<PPOverlaySubviewDelegate> delegate;

/* Animation layer for viewfinder */
@property (nonatomic, retain) CAShapeLayer* trackingLayer;

/** Initial margin of the viewfinder */
@property (nonatomic, assign) CGFloat initialViewfinderMargin;

/** Initial Color of the viewfinder */
@property (nonatomic, retain) UIColor* initialColor;

/** Success Color of the viewfinder */
@property (nonatomic, retain) UIColor* successColor;

/** Width of the dots */
@property (nonatomic, assign) CGFloat strokeWidth;

/** Duration of the animation */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 Initializes the layer
 */
- (id)initWithFrame:(CGRect)frame;

@end
