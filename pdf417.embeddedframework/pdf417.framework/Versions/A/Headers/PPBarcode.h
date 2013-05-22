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
#import "CameraViewController.h"
#import "PPScanningResult.h"

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
- (void)cameraViewControllerWasClosed:(UIViewController*)cameraViewController;

/**
 * Barcode library obtained a valid result. Do your next steps here.
 *
 * Depending on how you want to treat the result, you might want to
 * dismiss the Barcode library's UIViewController here.
 */
- (void)cameraViewController:(UIViewController*)cameraViewController
              obtainedResult:(PPScanningResult*)result;

@end
