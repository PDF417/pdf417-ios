//
//  PPDotsAnimationLayer.m
//  BarcodeFramework
//
//  Created by Jura on 06/06/14.
//  Copyright (c) 2014 PhotoPay. All rights reserved.
//

#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag
#endif

#import "PPYDotsOverlaySubview.h"

@interface PPYDotsOverlaySubview ()

@end

@implementation PPYDotsOverlaySubview

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super init];

    if (self) {
        _dotsColor = [[UIColor greenColor] retain];
        _dotsStrokeWidth = PP_IS_IPAD ? 6.0f : 4.0f;
        _dotsRadius = 4.0f;
        _animationDuration = 0.1f;

        CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self initDotsLayerWithBounds:bounds];
    }

    return self;
}

- (void)initDotsLayerWithBounds:(CGRect)bounds {
    CAShapeLayer *newDotsLayer = [[CAShapeLayer alloc] init];
    [self setDotsLayer:newDotsLayer];
    [newDotsLayer release];
    
    _dotsLayer.frame = bounds;
    _dotsLayer.contentsGravity = kCAGravityResize;
    _dotsLayer.strokeColor = [[self dotsColor] CGColor];
    _dotsLayer.fillColor = [[UIColor clearColor] CGColor];
    _dotsLayer.opacity = 0.8f;
    _dotsLayer.delegate = self;
    _dotsLayer.lineWidth = [self dotsStrokeWidth];
    _dotsLayer.masksToBounds = YES;

    CGMutablePathRef newPath = CGPathCreateMutable();
    _dotsLayer.path = newPath;
    CGPathRelease(newPath);
}

- (void)dealloc {
    [[self dotsLayer] setDelegate:nil];
    [_dotsLayer release];

    [_dotsColor release];

    [super dealloc];
}

#pragma mark - PPOverlaySubview

- (void)addToSuperview:(UIView*)superview {
    CALayer* viewLayer = superview.layer;
    [viewLayer insertSublayer:[self dotsLayer] below:[[viewLayer sublayers] objectAtIndex:0]];
}

- (void)setFrame:(CGRect)frame {
    [self dotsLayer].frame = frame;
}

- (void)overlayWillRemoveAllAnimations {
    [[self dotsLayer] removeAllAnimations];
}

- (void)overlayDidFindLocation:(NSArray*)points
                    withStatus:(PPDetectionStatus)status {

    BOOL nothingDetected = points == nil || [points count] < 2;
    BOOL barcodeDetected = !nothingDetected && ((status & PPDetectionStatusQRSuccess) > 0 ||
                                                (((status & PPDetectionStatusSuccess) > 0) && [points count] == 2));

    UIColor *color;
    
    if (barcodeDetected) {
        color = [self dotsColor];
    } else {
        color = [UIColor clearColor];
    }

    [self setDotsPosition:points
                    color:color];
}

#pragma mark - Utils

- (void)setDotsPosition:(NSArray*)dotsPoints
                  color:(UIColor*)color {

    CGMutablePathRef dotsPath = CGPathCreateMutable();
    [self createPath:dotsPath withDots:dotsPoints];

    [self dotsLayer].path = dotsPath;
    [self startDotAnimation:[color CGColor] duration:[self animationDuration]];

    CGPathRelease(dotsPath);
}

- (void)startDotAnimation:(CGColorRef)toColor
                 duration:(NSTimeInterval)duration {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];

    animation.repeatCount = 1;
    animation.autoreverses = NO;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    CAShapeLayer *layer = (CAShapeLayer*)[[self dotsLayer] presentationLayer];
	animation.fromValue = (id)layer.strokeColor;
	animation.toValue = (id)toColor;
    animation.duration = duration;

	[[self dotsLayer] addAnimation:animation forKey:@"path"];
    [self dotsLayer].strokeColor = toColor;
}

- (void)createPath:(CGMutablePathRef)path
          withDots:(NSArray*)dots {

    if (dots != nil) {
        for (int i = 0; i < [dots count]; i++) {
            CGPoint point = [[dots objectAtIndex:i] CGPointValue];
            CGPathMoveToPoint(path, nil, point.x + [self dotsRadius], point.y);
            CGPathAddArc(path, nil, point.x, point.y, [self dotsRadius], 0, 2 * M_PI, YES);
        }
        if ([dots count] > 1) {
            CGPoint point = [[dots objectAtIndex:0] CGPointValue];
            CGPathMoveToPoint(path, nil, point.x, point.y);
            CGPathCloseSubpath(path);
        }
    }
}

@end
