//
//  PPDotsAnimationLayer.h
//  BarcodeFramework
//
//  Created by Jura on 06/06/14.
//  Copyright (c) 2014 PhotoPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPYOverlaySubview.h"

/**
 A wrapper around CAShapeLayer which is used for presenting a status about barcode detections

 The layer is used to draw dots representing barcodes
 */
@interface PPYDotsOverlaySubview : NSObject<PPYOverlaySubview>

/* Animation layer for barcode tracking */
@property (nonatomic, retain) CAShapeLayer* dotsLayer;

/** Color of the dots */
@property (nonatomic, retain) UIColor* dotsColor;

/** Width of the dots */
@property (nonatomic, assign) CGFloat dotsStrokeWidth;

/** Radius of dots */
@property (nonatomic, assign) CGFloat dotsRadius;

/** Duration of the animation */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 Initializes the layer
 */
- (id)initWithFrame:(CGRect)frame;

@end
