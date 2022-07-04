//
//  MBPointDetectorSubview.h
//  MicroblinkDev
//
//  Created by Dino Gustin on 02/05/2018.
//

#import "MBDisplayablePointsDetection.h"

/**
 * Protocol for processing MBBDisplayablePointsDetection. Subviews implementing this protocol process and draw points on the screen (e.g. flashing dots)
 */
@protocol MBBPointDetectorSubview <NSObject>

/**
 * This method should be called when MBBDisplayablePointsDetection is obtained and points need to be drawn/redrawn.
 */
- (void)detectionFinishedWithDisplayablePoints:(MBBDisplayablePointsDetection *)displayablePointsDetection;

/**
 * This method should be called when MBBDisplayablePointsDetection is obtained and points need to be drawn/redrawn with camera preview zoom enabled by setting previewZoomScale property on cameraSettings.
 */
- (void)detectionFinishedWithDisplayablePoints:(MBBDisplayablePointsDetection *)displayablePointsDetection originalRectangle:(CGRect)originalRect relativeRectangle:(CGRect)relativeRectangle;

@end
