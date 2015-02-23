//
//  PPModernOverlayViewController.h
//  PhotoPayFramework
//
//  Created by Marko Mihovilić on 01/09/14.
//  Copyright (c) 2014 MicroBlink Ltd. All rights reserved.
//

#import "PPModernBaseOverlayViewController.h"

@interface PPModernOverlayViewController : PPModernBaseOverlayViewController

/**
 Supported orientations mask
 */
@property (nonatomic, assign) UIInterfaceOrientationMask hudMask;

/**
 YES if toast messages should be displayed, NO otherwise
 */
@property (nonatomic, assign) BOOL shouldDisplayToastMessages;

/**
 YES if help button should be displayed
 */
@property (nonatomic, assign) BOOL shouldDisplayHelpButton;

@end
