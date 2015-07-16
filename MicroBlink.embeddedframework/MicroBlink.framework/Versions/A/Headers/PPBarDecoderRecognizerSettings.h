//
//  PPBarDecoderRecognizerSettings.h
//  Pdf417Framework
//
//  Created by Jura on 10/07/15.
//  Copyright (c) 2015 MicroBlink Ltd. All rights reserved.
//

#import "PPRecognizerSettings.h"

/**
 * Settings class for configuring BarDecoder Recognizer
 *
 * BarDecoder recognizer is used for scanning Code 39 and Code 128 barcodes and is superior in performance
 * to ZXIngRecognizer
 */
@interface PPBarDecoderRecognizerSettings : PPRecognizerSettings

/**
 * Set this to YES to scan Code 39 barcodes
 */
@property (nonatomic) BOOL scanCode39;

/**
 * Set this to YES to scan Code 128 barcodes
 */
@property (nonatomic) BOOL scanCode128;

/**
 * Set this to YES to allow scanning barcodes with inverted intensities
 * (i.e. white barcodes on black background)
 *
 * NOTE: this options doubles the frame processing time
 */
@property (nonatomic) BOOL scanInverse;

/**
 * Use automatic scale detection feature. This normally should not be used.
 * The only situation where this helps in getting better scanning results is 
 * when using kPPUseVideoPresetPhoto on iPad devices. 
 * Video preview resoution of 2045x1536 in that case is very large and autoscale helps.
 */
@property (nonatomic) BOOL autoDetectScale;

/**
 * Set this to YES to enable scanning of lower resolution barcodes 
 * at cost of additional processing time.
 */
@property (nonatomic) BOOL tryHarder;

@end
