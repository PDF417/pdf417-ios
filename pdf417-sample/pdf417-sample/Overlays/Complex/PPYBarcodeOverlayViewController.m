//
//  PPBarcodeOverlayViewController.m
//  BarcodeFramework
//
//  Created by Jura on 22/12/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag
#endif

#import <QuartzCore/QuartzCore.h>
#import "PPYBarcodeOverlayViewController.h"
#import "PPYViewfinderOverlaySubview.h"
#import "PPYDotsOverlaySubview.h"

@interface PPYBarcodeOverlayViewController ()

@end

@implementation PPYBarcodeOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** Create viewfinder Layer */
    [[self overlaySubviews] addObject:[[[PPYViewfinderOverlaySubview alloc] initWithFrame:self.view.frame] autorelease]];

    /** Create dots Layer */
    [[self overlaySubviews] addObject:[[[PPYDotsOverlaySubview alloc] initWithFrame:self.view.frame] autorelease]];
}

@end
