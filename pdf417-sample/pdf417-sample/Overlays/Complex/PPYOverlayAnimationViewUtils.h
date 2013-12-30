//
//  PPOverlayAnimationViewUtils.h
//  BarcodeFramework
//
//  Created by Jurica Cerovec on 22/12/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPYOverlayAnimationViewUtils : NSObject

+ (double)getSquaredNorm:(CGPoint)point;

+ (double)getDistanceBetweenPoint:(CGPoint)point andSecond:(CGPoint)second;

+ (void)createPath:(CGMutablePathRef)path withCorners:(NSArray*)corners forSize:(CGRect)size;

+ (void)createPath:(CGMutablePathRef)path withDots:(NSArray*)dots forSize:(CGRect)size;

+ (CGPoint)getPointBetweenFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint offsetFromFirstPoint:(int)offset;

+ (CGPoint)getPointBetweenFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint offsetFromSecondPoint:(int)offset;

+ (CGFloat)getViewfinderBaseLength;

@end
