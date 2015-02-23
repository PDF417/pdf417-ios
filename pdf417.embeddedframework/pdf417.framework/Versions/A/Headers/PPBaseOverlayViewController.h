//
//  PPBaseOverlayViewController.h
//  BarcodeFramework
//
//  Created by Jura on 06/06/14.
//  Copyright (c) 2014 PhotoPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPOverlayViewController.h"
#import "PPOverlaySubview.h"

/**
 * Common base class for PhotoPay default overlay view controllers
 */
@interface PPBaseOverlayViewController : PPOverlayViewController

/**
 Array with overlay subviews
 */
@property (nonatomic, strong) NSMutableArray* overlaySubviews;

@property (nonatomic, weak) id<PPOverlaySubviewDelegate> overlaySubviewsDelegate;

@end
