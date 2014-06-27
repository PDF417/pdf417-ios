//
//  PPBaseBarcodeOverlayViewController.m
//  BarcodeFramework
//
//  Created by Jura on 09/06/14.
//  Copyright (c) 2014 PhotoPay. All rights reserved.
//

#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag
#endif

#import "PPYBaseBarcodeOverlayViewController.h"
#import "PPYCameraButton.h"

@interface PPYBaseBarcodeOverlayViewController ()

@end

@implementation PPYBaseBarcodeOverlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _buttonsMargin = PP_IS_IPAD ? 30.f : 20.f;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _buttonsMargin = PP_IS_IPAD ? 30.f : 20.f;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGRect bounds = self.view.bounds;

    const float yOffset = [self buttonsMargin];
    const float xOffset = [self buttonsMargin];

    // Initialize torch button if it's available for this device
    if ([[self containerViewController] overlayViewControllerShouldDisplayTorch:self]) {
        PPYCameraButton *newLightButton = [[PPYCameraButton alloc] init];
        if ([[self containerViewController] isTorchOn]) {
            [newLightButton setTitle:_(@"photopay_light_off") forState:UIControlStateNormal];
            [newLightButton setImage:[UIImage imageNamed:@"lighton"] forState:UIControlStateNormal];
        } else {
            [newLightButton setTitle:_(@"photopay_light_on") forState:UIControlStateNormal];
            [newLightButton setImage:[UIImage imageNamed:@"light"] forState:UIControlStateNormal];
        }

        [newLightButton sizeToFit];
        newLightButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [newLightButton addTarget:self action:@selector(toggleTorch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

        // Update position of light button
        CGRect lightFrame = CGRectMake(bounds.size.width - newLightButton.frame.size.width - xOffset, yOffset, newLightButton.frame.size.width, newLightButton.frame.size.height);
        newLightButton.frame = lightFrame;
        [self.view addSubview:newLightButton];

        [newLightButton release];
    } else {
        NSLog(@"Torch is not supported!");
    }

    // Initialize close button if it's necessary to display it
    if ([[self containerViewController] isPresentedModally]) {
        PPYCameraButton *newCloseButton = [[PPYCameraButton alloc] init];
        [newCloseButton setTitle:_(@"photopay_close") forState:UIControlStateNormal];
        [newCloseButton sizeToFit];
        newCloseButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;

        [newCloseButton addTarget:self action:@selector(closePhotoPay) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self.view addSubview:newCloseButton];

        newCloseButton.frame = CGRectMake(xOffset,
                                          yOffset,
                                          newCloseButton.frame.size.width,
                                          newCloseButton.frame.size.height);

        [newCloseButton release];
    }
}

#pragma mark - Button handlers

- (void)toggleTorch:(id)sender {
    if ([[self containerViewController] isTorchOn]) {
        [[self containerViewController] overlayViewController:self willSetTorch:NO];
        [sender setTitle:_(@"photopay_light_on") forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"light"] forState:UIControlStateNormal];
    } else {
        [[self containerViewController] overlayViewController:self willSetTorch:YES];
        [sender setTitle:_(@"photopay_light_off") forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"lighton"] forState:UIControlStateNormal];
    }
}

- (void)closePhotoPay {
    [[self containerViewController] overlayViewControllerWillCloseCamera:self];
}

@end
