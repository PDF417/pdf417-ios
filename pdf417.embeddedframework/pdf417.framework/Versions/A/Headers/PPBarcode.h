//
//  PPBarcode.h
//  BarcodeFramework
//
//  Created by Jurica Cerovec on 5/12/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPApp.h"
#import "PPBarcodeCoordinator.h"
#import "PPSettings.h"
#import "PPScanningResult.h"
#import "PPUSDLResult.h"
#import "PPBaseResult.h"
#import "PPDetectionStatus.h"
#import "PPOverlayViewController.h"
#import "PPScanningViewController.h"

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
 * Barcode library obtained a valid result. Check the resultType of the result object so that you know
 * which exact value you recieved.
 *
 * Do your next steps in this method.
 *
 * Depending on how you want to treat the result, you might want to
 * dismiss the Barcode library's UIViewController here.
 */
- (void)cameraViewController:(UIViewController<PPScanningViewController>*)cameraViewController
          obtainedBaseResult:(PPBaseResult*)result;

@optional

/**
 * Barcode library obtained a valid scanning (barcode) result. Do your next steps here.
 *
 * Depending on how you want to treat the result, you might want to
 * dismiss the Barcode library's UIViewController here.
 *
 * Deprecated from version 2.6. Will be removed in 3.0. Use cameraViewController:obtainedBaseResult
 */
- (void)cameraViewController:(UIViewController<PPScanningViewController>*)cameraViewController
              obtainedResult:(PPScanningResult*)result;

/**
 Barcode library processed one video frame.
 
 The last video frame obtained before cameraViewController:obtainedBaseResult: is the one
 on which the scanning succeeded.
 */
- (void)cameraViewController:(UIViewController<PPScanningViewController>*)cameraViewController
               obtainedImage:(UIImage *)image
                    withName:(NSString *)name
                        type:(NSString *)type;

/**
 Barcode library published intermediate debug/text results.
 
 Intended for private PhotoPay use.
 */
- (void)cameraViewController:(UIViewController<PPScanningViewController>*)cameraViewController
                obtainedText:(NSString*)text
                    withName:(NSString*)name
                        type:(NSString*)type;

@end