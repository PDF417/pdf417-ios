//
//  PPOcrLineAnimationViewLayer.m
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 19/11/13.
//  Copyright (c) 2013 Racuni.hr. All rights reserved.
//

#import "PPYOverlayAnimationViewLayer.h"
#import "PPYOverlayAnimationViewUtils.h"
#import <pdf417/PPBarcode.h>

@interface PPYOverlayAnimationViewLayer ()

@property (nonatomic, retain) UIColor* initialColor;
@property (nonatomic, retain) UIColor* successColor;
@property (nonatomic, assign) CGFloat viewfinderMargin;

@end

@implementation PPYOverlayAnimationViewLayer

- (id)initWithFrame:(CGRect)frame
       initialColor:(UIColor*)initialColor
       successColor:(UIColor*)successColor {
    
    self = [super init];
    if (self) {
        _initialColor = initialColor;
        [_initialColor retain];
        
        _successColor = successColor;
        [_successColor retain];
        
        _viewfinderMargin = PP_IS_IPAD ? 18.0f : 12.0f;
        
        CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        [self initTrackingLayerWithBounds:bounds];
        [self initDotsLayerWithBounds:bounds];
    }
    
    return self;
}

- (NSArray*)defaultCornersWithBounds:(CGRect)bounds {
    NSArray *layerCorners = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:CGPointMake([self viewfinderMargin], [self viewfinderMargin])],
                             [NSValue valueWithCGPoint:CGPointMake(bounds.size.width - [self viewfinderMargin], bounds.size.height - [self viewfinderMargin])],
                             [NSValue valueWithCGPoint:CGPointMake([self viewfinderMargin], bounds.size.height - [self viewfinderMargin])],
                             [NSValue valueWithCGPoint:CGPointMake(bounds.size.width - [self viewfinderMargin], [self viewfinderMargin])],
                             nil];
    [layerCorners autorelease];
    return layerCorners;
}

- (void)initTrackingLayerWithBounds:(CGRect)bounds {
    CAShapeLayer *newShapeLayer = [[CAShapeLayer alloc] init];
    newShapeLayer.frame = bounds;
    newShapeLayer.contentsGravity = kCAGravityResize;
    newShapeLayer.strokeColor = [[self initialColor] CGColor];
    newShapeLayer.fillColor = [[UIColor clearColor] CGColor];
    newShapeLayer.opacity = 1.0f;
    newShapeLayer.delegate = self;
    newShapeLayer.masksToBounds = YES;
    newShapeLayer.lineWidth = [PPYOverlayAnimationViewLayer getStrokeWidth];
    newShapeLayer.lineJoin = kCALineJoinRound;
    
    [self setTrackingLayer:newShapeLayer];
    [newShapeLayer release];
    
    NSArray* layerCorners = [self defaultCornersWithBounds:bounds];
    CGMutablePathRef newPath = CGPathCreateMutable();
    [PPYOverlayAnimationViewUtils createPath:newPath withCorners:layerCorners forSize:bounds];
    self.trackingLayer.path = newPath;
    CGPathRelease(newPath);
}

- (void)initDotsLayerWithBounds:(CGRect)bounds {
    CAShapeLayer *newDotsLayer = [[CAShapeLayer alloc] init];
    
    [self setDotsLayer:newDotsLayer];
    [newDotsLayer release];
    _dotsLayer.frame = bounds;
    _dotsLayer.contentsGravity = kCAGravityResize;
    _dotsLayer.strokeColor = [[self successColor] CGColor];
    _dotsLayer.fillColor = [[UIColor clearColor] CGColor];
    _dotsLayer.opacity = 0.8f;
    _dotsLayer.delegate = self;
    _dotsLayer.lineWidth = [PPYOverlayAnimationViewLayer getStrokeWidth];
    _dotsLayer.masksToBounds = YES;
    
    CGMutablePathRef newPath = CGPathCreateMutable();
    _dotsLayer.path = newPath;
    CGPathRelease(newPath);
}

- (void)setFrame:(CGRect)frame {
    [self trackingLayer].frame = frame;
    [self dotsLayer].frame = frame;
    
    NSArray* layerCorners = [self defaultCornersWithBounds:frame];
    CGMutablePathRef newPath = CGPathCreateMutable();
    [PPYOverlayAnimationViewUtils createPath:newPath withCorners:layerCorners forSize:frame];
    [self startAnimationToPath:newPath duration:0.4f]; // to match rotation duration
    [self startAnimationToColor:[[self initialColor] CGColor] duration:0.4f];
    CGPathRelease(newPath);
}

- (void)dealloc {
    [[self trackingLayer] setDelegate:nil];
    [_trackingLayer release];
    
    [[self dotsLayer] setDelegate:nil];
    [_dotsLayer release];
    
    [super dealloc];
}

+ (CGFloat)getStrokeWidth {
    CGFloat strokeWidth = PP_IS_IPAD ? 6.0f : 4.0f;
    return strokeWidth;
}

#pragma mark - Event handler

- (void)animateToLocation:(NSArray*)cornerPoints
               withStatus:(PPDetectionStatus)status {
    CGRect bounds = self.trackingLayer.bounds;
    
//    LOGE([stringFromDetectionStatus(status) UTF8String]);
    
    BOOL nothingDetected = cornerPoints == nil || [cornerPoints count] < 4;
    BOOL barcodeDetected = !nothingDetected && ((status & PPDetectionStatusQRSuccess) > 0 || (status & PPDetectionStatusPdf417Success) > 0);
    BOOL payslipDetected = !nothingDetected && ((status & PPDetectionStatusSuccess) > 0);
    BOOL fallbackDetected = !nothingDetected && ((status & PPDetectionStatusFallbackSuccess) > 0);
    
    UIColor* dotsColor = nil;
    UIColor* trackingColor = nil;
    
    NSArray* dotsPoints = nil;
    NSArray* trackingPoints = nil;
    
    if (barcodeDetected) {
        dotsPoints = [cornerPoints copy];
        dotsColor = [self successColor];
        
        trackingPoints = [self defaultCornersWithBounds:bounds];
        trackingColor = [self initialColor];
    } else if (payslipDetected) {
        dotsPoints = [self defaultCornersWithBounds:bounds];
        dotsColor = [UIColor clearColor];
        
        trackingPoints = [cornerPoints copy];
        trackingColor = [self successColor];
    } else if (fallbackDetected) {
        dotsPoints = [self defaultCornersWithBounds:bounds];
        dotsColor = [UIColor clearColor];
        
        trackingPoints = [self defaultCornersWithBounds:bounds];
        trackingColor = [self successColor];
    } else {
        dotsPoints = [self defaultCornersWithBounds:bounds];
        dotsColor = [UIColor clearColor];
        
        trackingPoints = [self defaultCornersWithBounds:bounds];
        trackingColor = [self initialColor];
    }
    
    [self setDotsPosition:dotsPoints forBounds:bounds color:dotsColor];
    [self setCornersPosition:trackingPoints forBounds:bounds color:trackingColor];

}

- (void)setDotsPosition:(NSArray*)dotsPoints forBounds:(CGRect)bounds color:(UIColor*)color {
    CGMutablePathRef dotsPath = CGPathCreateMutable();
    
    [PPYOverlayAnimationViewUtils createPath:dotsPath withDots:dotsPoints forSize:bounds];
    [self dotsLayer].path = dotsPath;
    [self startDotAnimation:[color CGColor] duration:[[PPApp instance] animationDuration]];

    CGPathRelease(dotsPath);
}

- (void)setCornersPosition:(NSArray*)cornerPoints forBounds:(CGRect)bounds color:(UIColor*)color {
    CGMutablePathRef newPath = CGPathCreateMutable();
    
    [PPYOverlayAnimationViewUtils createPath:newPath withCorners:cornerPoints forSize:bounds];
    [self startAnimationToPath:newPath duration:[[PPApp instance] animationDuration]];
    [self startAnimationToColor:[color CGColor] duration:[[PPApp instance] animationDuration]];
    
    CGPathRelease(newPath);
}

#pragma mark - Animation methods

- (void)startAnimationToPath:(CGMutablePathRef)toPath
                    duration:(NSTimeInterval)duration {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    
	animation.repeatCount = 1;
	animation.autoreverses = NO;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CAShapeLayer *layer = (CAShapeLayer*)[[self trackingLayer] presentationLayer];
	animation.fromValue = (id)layer.path;
	animation.toValue = (id)toPath;
    animation.duration = duration;
    
    [animation setRemovedOnCompletion:NO];
    
	[[self trackingLayer] addAnimation:animation forKey:@"path"];
    
    [self trackingLayer].path = toPath;
    
}

- (void)startDotAnimation:(CGColorRef)toColor
                 duration:(NSTimeInterval)duration {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    animation.repeatCount = 1;
    animation.autoreverses = NO;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CAShapeLayer *layer = (CAShapeLayer*)[[self dotsLayer] presentationLayer];
	animation.fromValue = (id)layer.strokeColor;
	animation.toValue = (id)toColor;
    animation.duration = duration;
    
	[[self dotsLayer] addAnimation:animation forKey:@"path"];
    
    [self dotsLayer].strokeColor = toColor;
}

- (void)startAnimationToColor:(CGColorRef)toColor
                     duration:(NSTimeInterval)duration {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    
	animation.repeatCount = 1;
	animation.autoreverses = NO;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CAShapeLayer *layer = (CAShapeLayer*)[[self trackingLayer] presentationLayer];
	animation.fromValue = (id)layer.strokeColor;
	animation.toValue = (id)toColor;
	animation.duration = duration;
    
	[[self trackingLayer] addAnimation:animation forKey:@"strokeColor"];
    
    [self trackingLayer].strokeColor = toColor;
}

@end
