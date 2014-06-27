//
//  PPOcrLineAnimationViewLayer.m
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 19/11/13.
//  Copyright (c) 2013 Racuni.hr. All rights reserved.
//

#import "PPYViewfinderOverlaySubview.h"

@interface PPYViewfinderOverlaySubview ()

@end

@implementation PPYViewfinderOverlaySubview

- (id)initWithFrame:(CGRect)frame {
    
    self = [super init];
    if (self) {
        _initialViewfinderMargin = PP_IS_IPAD ? 18.0f : 12.0f;
        _initialColor = [[UIColor redColor] retain];
        _successColor = [[UIColor greenColor] retain];
        _strokeWidth = PP_IS_IPAD ? 6.0f : 4.0f;
        _animationDuration = 0.1f;

        CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self initTrackingLayerWithBounds:bounds];
    }
    
    return self;
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
    newShapeLayer.lineWidth = [self strokeWidth];
    newShapeLayer.lineJoin = kCALineJoinRound;
    
    [self setTrackingLayer:newShapeLayer];
    [newShapeLayer release];
}

- (void)setDefaultPath {
    NSArray *trackingPoints = [self defaultCornersWithBounds:self.trackingLayer.bounds];
    UIColor *trackingColor = [self initialColor];
    [self setCornersPosition:trackingPoints color:trackingColor duration:0.4f];
}

- (NSArray*)defaultCornersWithBounds:(CGRect)bounds {
    NSArray *layerCorners = [[[NSArray alloc] initWithObjects:
                                [NSValue valueWithCGPoint:CGPointMake([self initialViewfinderMargin], [self initialViewfinderMargin])],
                                [NSValue valueWithCGPoint:CGPointMake(bounds.size.width - [self initialViewfinderMargin], bounds.size.height - [self initialViewfinderMargin])],
                                [NSValue valueWithCGPoint:CGPointMake([self initialViewfinderMargin], bounds.size.height - [self initialViewfinderMargin])],
                                [NSValue valueWithCGPoint:CGPointMake(bounds.size.width - [self initialViewfinderMargin], [self initialViewfinderMargin])], nil] autorelease];
    return layerCorners;
}

- (void)dealloc {
    [[self trackingLayer] setDelegate:nil];
    [_trackingLayer release];

    [_initialColor release];
    [_successColor release];
    
    [super dealloc];
}

#pragma mark - PPOverlaySubview

- (void)addToSuperview:(UIView*)superview {
    CALayer* viewLayer = superview.layer;
    [viewLayer insertSublayer:[self trackingLayer] below:[[viewLayer sublayers] objectAtIndex:0]];
    [self setDefaultPath];
}

- (void)overlayWillRemoveAllAnimations {
    self.delegate = nil;
    [[self trackingLayer] removeAllAnimations];
}

- (void)setFrame:(CGRect)frame {
    [self trackingLayer].frame = frame;
    [self setDefaultPath];
}

- (void)overlayDidFindLocation:(NSArray*)cornerPoints
                    withStatus:(PPDetectionStatus)status {

    CGRect bounds = self.trackingLayer.bounds;
    
    BOOL nothingDetected = cornerPoints == nil || [cornerPoints count] < 2;
    BOOL areaDetected = !nothingDetected && ((status & PPDetectionStatusPdf417Success) > 0 ||
                                             (((status & PPDetectionStatusSuccess) > 0) && [cornerPoints count] == 4));
    BOOL fallbackDetected = !nothingDetected && ((status & PPDetectionStatusFallbackSuccess) > 0);

    UIColor* trackingColor = nil;
    NSArray* trackingPoints = nil;
    
    if (areaDetected) {
        trackingPoints = cornerPoints;
        trackingColor = [self successColor];
    } else if (fallbackDetected) {
        trackingPoints = [self defaultCornersWithBounds:bounds];
        trackingColor = [self initialColor];
    } else {
        trackingPoints = [self defaultCornersWithBounds:bounds];
        trackingColor = [self initialColor];
    }

    [self setCornersPosition:trackingPoints
                       color:trackingColor
                    duration:[self animationDuration]];
}

#pragma mark - Utils

- (void)setCornersPosition:(NSArray*)cornerPoints
                     color:(UIColor*)color
                  duration:(CGFloat)duration {
    CGMutablePathRef newPath = CGPathCreateMutable();
    
    [self createPath:newPath withCorners:cornerPoints];
    [self startAnimationToPath:newPath duration:duration];
    [self startAnimationToColor:[color CGColor] duration:[self animationDuration]];
    
    CGPathRelease(newPath);
}

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

    animation.delegate = self;
    [self.delegate overlaySubviewAnimationDidStart:self];
    
	[[self trackingLayer] addAnimation:animation forKey:@"path"];
    
    [self trackingLayer].path = toPath;
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    [self.delegate overlaySubviewAnimationDidFinish:self];
}

- (void)startAnimationToColor:(CGColorRef)toColor
                     duration:(NSTimeInterval)duration {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    
	animation.repeatCount = 1;
	animation.autoreverses = NO;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAShapeLayer *layer = (CAShapeLayer*)[[self trackingLayer] presentationLayer];
	animation.fromValue = (id)layer.strokeColor;
	animation.toValue = (id)toColor;
	animation.duration = duration / 2;
    
	[[self trackingLayer] addAnimation:animation forKey:@"strokeColor"];
    
    [self trackingLayer].strokeColor = toColor;
}

#pragma mark - Drawing

- (void)createPath:(CGMutablePathRef)path withCorners:(NSArray*)corners{
    CGPoint upperLeft = [[corners objectAtIndex:0] CGPointValue];
    CGPoint upperRight = [[corners objectAtIndex:1] CGPointValue];
    CGPoint lowerLeft = [[corners objectAtIndex:2] CGPointValue];
    CGPoint lowerRight = [[corners objectAtIndex:3] CGPointValue];

    CGPoint centroid = CGPointMake((upperLeft.x + upperRight.x + lowerLeft.x + lowerRight.x) / 4,
                                   (upperLeft.y + upperRight.y + lowerLeft.y + lowerRight.y) / 4);

    // get angles in respect to centroid
    NSMutableArray* alphas = [[NSMutableArray alloc] init];
    NSMutableArray* indexes = [[NSMutableArray alloc] init];
    for (int i = 0; i < [corners count]; i++) {
        CGPoint point = [[corners objectAtIndex:i] CGPointValue];
        [alphas addObject:[NSNumber numberWithDouble:atan2(point.y - centroid.y, point.x - centroid.x)]];
        [indexes addObject:[NSNumber numberWithInt:i]];
    }

    // sort according to angle
    for (int i = 0; i < [alphas count]; i++) {
        for (int j = i + 1; j < [alphas count]; j++) {
            if ([[alphas objectAtIndex:i] doubleValue] > [[alphas objectAtIndex:j] doubleValue]) {
                double tmp = [[alphas objectAtIndex:i] doubleValue];
                [alphas replaceObjectAtIndex:i withObject:[alphas objectAtIndex:j]];
                [alphas replaceObjectAtIndex:j withObject:[NSNumber numberWithDouble:tmp]];

                int index = [[indexes objectAtIndex:i] intValue];
                [indexes replaceObjectAtIndex:i withObject:[indexes objectAtIndex:j]];
                [indexes replaceObjectAtIndex:j withObject:[NSNumber numberWithDouble:index]];
            }
        }
    }

    // Find upper left point
    double uldist = DBL_MAX;
    int ulIndex = 0;
    for (int i = 0; i < [corners count]; i++) {
        CGPoint point = [[corners objectAtIndex:[[indexes objectAtIndex:i] intValue]] CGPointValue];
        double dist = [self getSquaredNorm:CGPointMake(point.x, point.y)];
        if (dist < uldist) {
            ulIndex = i;
            uldist = dist;
        }
    }
    // use others in clockwise order
    upperLeft = [[corners objectAtIndex:[[indexes objectAtIndex:(ulIndex+0)%4] intValue]] CGPointValue];
    upperRight = [[corners objectAtIndex:[[indexes objectAtIndex:(ulIndex+1)%4] intValue]] CGPointValue];
    lowerLeft = [[corners objectAtIndex:[[indexes objectAtIndex:(ulIndex+3)%4] intValue]] CGPointValue];
    lowerRight = [[corners objectAtIndex:[[indexes objectAtIndex:(ulIndex+2)%4] intValue]] CGPointValue];

    [alphas release];
    [indexes release];

    CGPoint holder;

	CGPathMoveToPoint(path, nil, upperLeft.x, upperLeft.y);

    CGFloat length = [self getViewfinderBaseLength];
    CGFloat percentage = 0.3f;

    double sideLength = [self getDistanceBetweenPoint:upperLeft andSecond:upperRight];
    length = MIN(length, sideLength * percentage);

    sideLength = [self getDistanceBetweenPoint:upperRight andSecond:lowerRight];
    length = MIN(length, sideLength * percentage);

    sideLength = [self getDistanceBetweenPoint:lowerRight andSecond:lowerLeft];
    length = MIN(length, sideLength * percentage);

    sideLength = [self getDistanceBetweenPoint:lowerLeft andSecond:upperLeft];
    length = MIN(length, sideLength * percentage);

    holder = [self getPointBetweenFirstPoint:upperLeft secondPoint:upperRight offsetFromFirstPoint:length];
	CGPathAddLineToPoint(path, nil, holder.x, holder.y);
    holder = [self getPointBetweenFirstPoint:upperLeft secondPoint:upperRight offsetFromSecondPoint:length];
	CGPathMoveToPoint(path, nil, holder.x, holder.y);
    CGPathAddLineToPoint(path, nil, upperRight.x, upperRight.y);

	holder = [self getPointBetweenFirstPoint:upperRight secondPoint:lowerRight offsetFromFirstPoint:length];
	CGPathAddLineToPoint(path, nil, holder.x, holder.y);
    holder = [self getPointBetweenFirstPoint:upperRight secondPoint:lowerRight offsetFromSecondPoint:length];
	CGPathMoveToPoint(path, nil, holder.x, holder.y);
    CGPathAddLineToPoint(path, nil, lowerRight.x, lowerRight.y);

    holder = [self getPointBetweenFirstPoint:lowerRight secondPoint:lowerLeft offsetFromFirstPoint:length];
	CGPathAddLineToPoint(path, nil, holder.x, holder.y);
    holder = [self getPointBetweenFirstPoint:lowerRight secondPoint:lowerLeft offsetFromSecondPoint:length];
	CGPathMoveToPoint(path, nil, holder.x, holder.y);
    CGPathAddLineToPoint(path, nil, lowerLeft.x, lowerLeft.y);

	holder = [self getPointBetweenFirstPoint:lowerLeft secondPoint:upperLeft offsetFromFirstPoint:length];
	CGPathAddLineToPoint(path, nil, holder.x, holder.y);
    holder = [self getPointBetweenFirstPoint:lowerLeft secondPoint:upperLeft offsetFromSecondPoint:length];
	CGPathMoveToPoint(path, nil, holder.x, holder.y);
    CGPathAddLineToPoint(path, nil, upperLeft.x, upperLeft.y);

	CGPathCloseSubpath(path);
}

- (double)getSquaredNorm:(CGPoint) point {
    return point.x*point.x + point.y*point.y;
}

- (double)getDistanceBetweenPoint:(CGPoint)point andSecond:(CGPoint)second {
    CGPoint a = CGPointMake(point.x - second.x, point.y - second.y);
    return sqrt([self getSquaredNorm:a]);
}

- (CGPoint)getPointBetweenFirstPoint:(CGPoint)firstPoint
                         secondPoint:(CGPoint)secondPoint
                offsetFromFirstPoint:(int)offset {

    double length = sqrt((firstPoint.x - secondPoint.x)*(firstPoint.x - secondPoint.x) + (firstPoint.y - secondPoint.y)*(firstPoint.y - secondPoint.y));
    if (length <= offset) return CGPointMake(secondPoint.x, secondPoint.y);

    double ratio = offset/length;
    CGPoint result = CGPointMake(firstPoint.x + ratio * (secondPoint.x - firstPoint.x), firstPoint.y + ratio * (secondPoint.y - firstPoint.y));
    return result;
}

- (CGPoint)getPointBetweenFirstPoint:(CGPoint)firstPoint
                         secondPoint:(CGPoint)secondPoint
               offsetFromSecondPoint:(int)offset {

    double length = sqrt((firstPoint.x - secondPoint.x)*(firstPoint.x - secondPoint.x) + (firstPoint.y - secondPoint.y)*(firstPoint.y - secondPoint.y));
    if (length <= offset) return CGPointMake(firstPoint.x, firstPoint.y);
    return [self getPointBetweenFirstPoint:firstPoint secondPoint:secondPoint offsetFromFirstPoint:length - offset];
}

- (CGFloat)getViewfinderBaseLength {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 90 : 60;
}

@end
