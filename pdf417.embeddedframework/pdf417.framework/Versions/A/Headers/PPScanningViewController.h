//
//  PPScanningViewController.h
//  BarcodeFramework
//
//  Created by Jurica Cerovec on 14/11/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Protocol for View controllers which present camera and provide scanning features
 */
@protocol PPScanningViewController <NSObject>

/**
 Status bar style which is used when UIViewControllerBasedStatusBarAppearance is set to NO. Default is 
 - on iOS 7 UIStatusBarStyleDefault
 - on pre iOS 7 UIStatusBarStyleBlackOpaque.
 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/**
 YES or NO depending whether status bar should be visible. By default it's
 - On iOS 7 when modal presentation style is used: YES
 - otherwise: NO
 */
@property (nonatomic, assign) BOOL statusBarHidden;

/** Pause scanning instantaneously without dismissing the camera view */
- (void)pauseScanning;

/** Resumes scanning instantaneously */
- (void)resumeScanning;

/** Sets the scanning region */
- (void)setScanningRegion:(CGRect)region;

@end
