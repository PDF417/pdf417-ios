//
//  PPOcrLineAnimationViewLayer.h
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 19/11/13.
//  Copyright (c) 2013 Racuni.hr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <pdf417/PPBarcode.h>

/**
 A wrapper around CAShapeLayer which is used for presenting a status about payslip detection.
 
 The layer is used to draw a scanning window with a border and a viewwinder.
 */
@interface PPYOverlayAnimationViewLayer : NSObject

/**
 Initializes the layer.
 Places the window between upper and lower offset values in the provided frame
 Window is painted in the initial color
 */
- (id)initWithFrame:(CGRect)frame
       initialColor:(UIColor*)initialColor
       successColor:(UIColor*)successColor;

/* Animation layer for payslip tracking */
@property (nonatomic, retain) CAShapeLayer* trackingLayer;

/* Animation layer for barcode tracking */
@property (nonatomic, retain) CAShapeLayer* dotsLayer;

- (void)setFrame:(CGRect)frame;

- (void)animateToLocation:(NSArray*)cornerPoints
               withStatus:(PPDetectionStatus)status;

+ (CGFloat)getStrokeWidth;

@end
