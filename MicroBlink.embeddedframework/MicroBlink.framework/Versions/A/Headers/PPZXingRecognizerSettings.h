//
//  PPZXingRecognizerSettings.h
//  Pdf417Framework
//
//  Created by Jura on 10/07/15.
//  Copyright (c) 2015 MicroBlink Ltd. All rights reserved.
//

#import "PPRecognizerSettings.h"

/**
 * Settings class for configuring ZXing Recognizer
 *
 * ZXIngRecognizer recognizer is used for scanning most of 1D barcode formats, and 2D format 
 * such as Aztec, DataMatrix and QR code
 */
@interface PPZXingRecognizerSettings : PPRecognizerSettings

/**
 * Set this to YES to scan Aztec 2D barcodes
 */
@property (nonatomic) BOOL scanAztec;

/**
 * Set this to YES to scan Code 128 1D barcodes
 */
@property (nonatomic) BOOL scanCode128;

/**
 * Set this to YES to scan Code 39 1D barcodes
 */
@property (nonatomic) BOOL scanCode39;

/**
 * Set this to YES to scan DataMatrix 2D barcodes
 */
@property (nonatomic) BOOL scanDataMatrix;

/**
 * Set this to YES to scan EAN 13 barcodes
 */
@property (nonatomic) BOOL scanEAN13;

/**
 * Set this to YES to scan EAN8 barcodes
 */
@property (nonatomic) BOOL scanEAN8;

/**
 * Set this to YES to scan ITF barcodes
 */
@property (nonatomic) BOOL scanITF;

/**
 * Set this to YES to scan QR barcodes
 */
@property (nonatomic) BOOL scanQR;

/**
 * Set this to YES to scan UPCA barcodes
 */
@property (nonatomic) BOOL scanUPCA;

/**
 * Set this to YES to scan UPCE barcodes
 */
@property (nonatomic) BOOL scanUPCE;

/**
 * Set this to YES to allow scanning barcodes with inverted intensities
 * (i.e. white barcodes on black background)
 *
 * NOTE: this options doubles the frame processing time
 */
@property (nonatomic) BOOL scanInverse;

@end
