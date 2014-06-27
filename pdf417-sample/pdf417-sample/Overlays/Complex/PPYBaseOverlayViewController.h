//
//  PPBaseOverlayViewController.h
//  BarcodeFramework
//
//  Created by Jura on 06/06/14.
//  Copyright (c) 2014 PhotoPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pdf417/PPBarcode.h>

/**
 * Common base class for PhotoPay default overlay view controllers
 */
@interface PPYBaseOverlayViewController : PPOverlayViewController

/**
 Array with overlay subviews
 */
@property (nonatomic, retain) NSMutableArray* overlaySubviews;

@end
