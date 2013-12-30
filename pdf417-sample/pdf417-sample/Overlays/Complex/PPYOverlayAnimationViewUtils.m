//
//  PPOverlayAnimationViewUtils.m
//  BarcodeFramework
//
//  Created by Jurica Cerovec on 22/12/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import "PPYOverlayAnimationViewUtils.h"

@implementation PPYOverlayAnimationViewUtils

+ (double)getSquaredNorm:(CGPoint) point {
    return point.x*point.x + point.y*point.y;
}

+ (double)getDistanceBetweenPoint:(CGPoint)point andSecond:(CGPoint)second {
    CGPoint a = CGPointMake(point.x - second.x, point.y - second.y);
    return sqrt([PPYOverlayAnimationViewUtils getSquaredNorm:a]);
}

+ (void)createPath:(CGMutablePathRef)path withCorners:(NSArray*)corners forSize:(CGRect)size {
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
        double dist = [PPYOverlayAnimationViewUtils getSquaredNorm:CGPointMake(point.x, point.y)];
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
    
    CGFloat length = [PPYOverlayAnimationViewUtils getViewfinderBaseLength];
    
    double sideLength = [PPYOverlayAnimationViewUtils getDistanceBetweenPoint:upperLeft andSecond:upperRight];
    if (length > sideLength * 0.3) {
        length = sideLength * 0.3;
    }
    sideLength = [PPYOverlayAnimationViewUtils getDistanceBetweenPoint:upperRight andSecond:lowerRight];
    if (length > sideLength * 0.3) {
        length = sideLength * 0.3;
    }
    sideLength = [PPYOverlayAnimationViewUtils getDistanceBetweenPoint:lowerRight andSecond:lowerLeft];
    if (length > sideLength * 0.3) {
        length = sideLength * 0.3;
    }
    sideLength = [PPYOverlayAnimationViewUtils getDistanceBetweenPoint:lowerLeft andSecond:upperLeft];
    if (length > sideLength * 0.3) {
        length = sideLength * 0.3;
    }
    
    holder = [PPYOverlayAnimationViewUtils getPointBetweenFirstPoint:upperLeft secondPoint:upperRight offsetFromFirstPoint:length];
	CGPathAddLineToPoint(path, nil, holder.x, holder.y);
    holder = [PPYOverlayAnimationViewUtils getPointBetweenFirstPoint:upperLeft secondPoint:upperRight offsetFromSecondPoint:length];
	CGPathMoveToPoint(path, nil, holder.x, holder.y);
    CGPathAddLineToPoint(path, nil, upperRight.x, upperRight.y);
    
	holder = [PPYOverlayAnimationViewUtils getPointBetweenFirstPoint:upperRight secondPoint:lowerRight offsetFromFirstPoint:length];
	CGPathAddLineToPoint(path, nil, holder.x, holder.y);
    holder = [PPYOverlayAnimationViewUtils getPointBetweenFirstPoint:upperRight secondPoint:lowerRight offsetFromSecondPoint:length];
	CGPathMoveToPoint(path, nil, holder.x, holder.y);
    CGPathAddLineToPoint(path, nil, lowerRight.x, lowerRight.y);
    
    holder = [PPYOverlayAnimationViewUtils getPointBetweenFirstPoint:lowerRight secondPoint:lowerLeft offsetFromFirstPoint:length];
	CGPathAddLineToPoint(path, nil, holder.x, holder.y);
    holder = [PPYOverlayAnimationViewUtils getPointBetweenFirstPoint:lowerRight secondPoint:lowerLeft offsetFromSecondPoint:length];
	CGPathMoveToPoint(path, nil, holder.x, holder.y);
    CGPathAddLineToPoint(path, nil, lowerLeft.x, lowerLeft.y);
    
	holder = [PPYOverlayAnimationViewUtils getPointBetweenFirstPoint:lowerLeft secondPoint:upperLeft offsetFromFirstPoint:length];
	CGPathAddLineToPoint(path, nil, holder.x, holder.y);
    holder = [PPYOverlayAnimationViewUtils getPointBetweenFirstPoint:lowerLeft secondPoint:upperLeft offsetFromSecondPoint:length];
	CGPathMoveToPoint(path, nil, holder.x, holder.y);
    CGPathAddLineToPoint(path, nil, upperLeft.x, upperLeft.y);
    
	CGPathCloseSubpath(path);
}

+ (void)createPath:(CGMutablePathRef)path withDots:(NSArray*)dots forSize:(CGRect)size {
    const int radius = 4;
    if (dots != nil) {
        for (int i = 0; i < [dots count]; i++) {
            CGPoint point = [[dots objectAtIndex:i] CGPointValue];
            CGPathMoveToPoint(path, nil, point.x + radius, point.y);
            CGPathAddArc(path, nil, point.x, point.y, radius, 0, 2*M_PI, YES);
        }
        if ([dots count] > 1) {
            CGPoint point = [[dots objectAtIndex:0] CGPointValue];
            CGPathMoveToPoint(path, nil, point.x, point.y);
        }
    }
    
    CGPathCloseSubpath(path);
}

+ (CGPoint)getPointBetweenFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint offsetFromFirstPoint:(int)offset {
    double length = sqrt((firstPoint.x - secondPoint.x)*(firstPoint.x - secondPoint.x) + (firstPoint.y - secondPoint.y)*(firstPoint.y - secondPoint.y));
    if (length <= offset) return CGPointMake(secondPoint.x, secondPoint.y);
    
    double ratio = offset/length;
    CGPoint result = CGPointMake(firstPoint.x + ratio * (secondPoint.x - firstPoint.x), firstPoint.y + ratio * (secondPoint.y - firstPoint.y));
    
    return result;
}

+ (CGPoint)getPointBetweenFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint offsetFromSecondPoint:(int)offset {
    double length = sqrt((firstPoint.x - secondPoint.x)*(firstPoint.x - secondPoint.x) + (firstPoint.y - secondPoint.y)*(firstPoint.y - secondPoint.y));
    
    if (length <= offset) return CGPointMake(firstPoint.x, firstPoint.y);
    
    return [PPYOverlayAnimationViewUtils getPointBetweenFirstPoint:firstPoint secondPoint:secondPoint offsetFromFirstPoint:length - offset];
}

+ (CGFloat)getViewfinderBaseLength {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 90 : 60;
}


@end
