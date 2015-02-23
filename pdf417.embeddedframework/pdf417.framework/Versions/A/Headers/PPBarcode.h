//
//  PPBarcode.h
//  BarcodeFramework
//
//  Created by Jurica Cerovec on 5/12/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import "PPApp.h"
#import "PPBarcodeCoordinator.h"
#import "PPSettings.h"
#import "PPScanningResult.h"
#import "PPUSDLResult.h"
#import "PPBaseResult.h"
#import "PPDetectionStatus.h"
#import "PPOverlayViewController.h"
#import "PPScanningViewController.h"

static NSString* debugDataFolderName = @"DebugData";

/**
 * Protocol for retrieving results from barcode library
 */
@protocol PPBarcodeDelegate <NSObject>

@required

/**
 * Barcode library was closed. 
 *
 * This is where the Barcode library's UIViewController should be dismissed
 * if it's presented modally.
 */
- (void)cameraViewControllerWasClosed:(UIViewController<PPScanningViewController>*)cameraViewController;

/**
 * Barcode library did output scanning results. Do your next steps here.
 *
 * Depending on how you want to treat the result, you might want to
 * dismiss the Barcode library's UIViewController here.
 *
 * This method is the default way for getting access to results of scanning.
 *
 * Note: 
 * - there may be more 0, 1, or more than one scanning results.
 * - each scanning result belongs to a common PPBaseResult type. Check it's property resultType to get the actual type
 * - handle different types differently
 * 
 * @see PPBaseResult
 * @see PPScanningResult
 * @see PPUSDLResult
 */
- (void)cameraViewController:(UIViewController<PPScanningViewController>*)cameraViewController
            didOutputResults:(NSArray*)results;

@optional

/**
 * Barcode library obtained a valid result. Check the resultType of the result object so that you know
 * which exact value you recieved. Do your next steps in this method.
 *
 * Depending on how you want to treat the result, you might want to
 * dismiss the Barcode library's UIViewController here.
 *
 * Deprecated from version 2.6.1. Will be removed in 3.0. Use cameraViewController:obtainedResults
 *
 * This method was limited to obtaining just one result from the scanning process. In 2.6.1 an option
 * for obtaining more than one results is added, and became default.
 *
 * @see PPBaseResult
 * @see PPScanningResult
 * @see PPUSDLResult
 */
- (void)cameraViewController:(UIViewController<PPScanningViewController>*)cameraViewController
          obtainedBaseResult:(PPBaseResult*)result __deprecated;

/**
 * Barcode library obtained a valid scanning (barcode) result. Do your next steps here.
 *
 * Depending on how you want to treat the result, you might want to
 * dismiss the Barcode library's UIViewController here.
 *
 * Deprecated from version 2.6. Will be removed in 3.0. Use cameraViewController:obtainedResults.
 * This method was limited to obtaining results only of type PPScanningResult, which in 2.6 became 
 * just one of multiple result types.
 *
 * @see PPScanningResult
 */
- (void)cameraViewController:(UIViewController<PPScanningViewController>*)cameraViewController
              obtainedResult:(PPScanningResult*)result __deprecated;

/**
 Barcode library processed a video frame with success.
 
 Implement this callback if you're interested in the image which resulted with a successful scan.
 */
- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController
didMakeSuccessfulScanOnImage:(UIImage*)image;

/**
 Barcode library output debug data with a given filename
 */
- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController
          didOutputDebugData:(NSData*)data
                    filename:(NSString*)filename;

@end