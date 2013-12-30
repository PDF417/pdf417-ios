//
//  PPBarcodeOverlayViewController.m
//  BarcodeFramework
//
//  Created by Jurica Cerovec on 22/12/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import "PPYBarcodeOverlayViewController.h"
#import "PPYOverlayAnimationViewLayer.h"
#import "PPYOverlayAnimationViewUtils.h"
#import "PPYCameraButton.h"
#import <pdf417/PPBarcode.h>
#import <QuartzCore/QuartzCore.h>

@interface PPYBarcodeOverlayViewController ()

@property (nonatomic, retain) PPYOverlayAnimationViewLayer* animationViewLayer;

@property (nonatomic, assign) CGFloat buttonsMargin;

@property (nonatomic, assign) CGFloat viewfinderMargin;

@end

@implementation PPYBarcodeOverlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewfinderMargin = PP_IS_IPAD ? 18.f : 12.f;
    _buttonsMargin = PP_IS_IPAD ? 12.f : 8.f;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    CGRect bounds = self.view.bounds;
    
    const float yOffset = [self viewfinderMargin] + [self buttonsMargin];
    const float xOffset = [self viewfinderMargin] + [self buttonsMargin];
    
    // Initialize torch button if it's available for this device
    if ([[self delegate] overlayViewControllerShouldDisplayTorch:self]) {
        PPYCameraButton *newLightButton = [[PPYCameraButton alloc] init];
        if ([[self delegate] isTorchOn]) {
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
    if ([[self delegate] overlayViewControllerShouldDisplayCancel:self]) {
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
    
    /** Create animation Layer */
    PPYOverlayAnimationViewLayer* newAnimationViewLayer = [[PPYOverlayAnimationViewLayer alloc] initWithFrame:self.view.frame
                                                                                               initialColor:[UIColor redColor]
                                                                                               successColor:[UIColor greenColor]];
    [self setAnimationViewLayer:newAnimationViewLayer];
    
    CALayer* viewLayer = self.view.layer;
    [viewLayer insertSublayer:[newAnimationViewLayer trackingLayer] below:[[viewLayer sublayers] objectAtIndex:0]];
    [viewLayer insertSublayer:[newAnimationViewLayer dotsLayer] above:[newAnimationViewLayer trackingLayer]];
    
    [newAnimationViewLayer release];
}

- (void)viewWillLayoutSubviews {
    [[self animationViewLayer] setFrame:self.view.bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_animationViewLayer release];
    [super dealloc];
}

#pragma mark - Button handlers

- (void)toggleTorch:(id)sender {
    if ([[self delegate] isTorchOn]) {
        [[self delegate] overlayViewController:self willSetTorch:NO];
        [sender setTitle:_(@"photopay_light_on") forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"light"] forState:UIControlStateNormal];
    } else {
        [[self delegate] overlayViewController:self willSetTorch:YES];
        [sender setTitle:_(@"photopay_light_off") forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"lighton"] forState:UIControlStateNormal];
    }
}

- (void)closePhotoPay {
    [[self delegate] overlayViewControllerWillCloseCamera:self];
}

#pragma mark - autorotation

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if (PP_IS_IPAD) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark Controlling camera view

- (void)cameraViewControllerDidResumeScanning:(id)cameraViewController {
    NSLog(@"Barcode scanning process initialized");
}

- (void)cameraViewControllerDidStopScanning:(id)cameraViewController {
    NSLog(@"Barcode scanning process terminated");
}

- (void)cameraViewController:(id)cameraViewController
          didPublishProgress:(float)progress {
    NSLog(@"Barcode scanning don't have progress reporting implemented yet");
}

- (void)cameraViewControllerDidStartRecognition:(id)cameraViewController {
}

- (void)cameraViewController:(id)cameraViewController
didFinishRecognitionWithResult:(id)result {
    NSLog(@"Barcode scanning process finished with result %@", result);
}

- (void)cameraViewController:(id)cameraViewController
        didTimeoutWithResult:(id)result {
    NSLog(@"Barcode scanning process timed out with result %@", result);
}

- (void)cameraViewController:(id)cameraViewController
             didFindLocation:(NSArray*)cornerPoints
                  withStatus:(PPDetectionStatus)status {
    [[self animationViewLayer] animateToLocation:cornerPoints withStatus:status];
}

- (void)cameraViewController:(id)cameraViewController
     willRotateToOrientation:(UIDeviceOrientation)orientation {
    
}

/** Camera view did rotate */
- (void)cameraViewController:(id)cameraViewController
      didRotateToOrientation:(UIDeviceOrientation)orientation {
    NSString* orientationString = @"Portrait";
    if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        orientationString = @"Upside Down";
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        orientationString = @"Landscape Left";
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        orientationString = @"Landscape Right";
    }
    NSLog(@"Orientation was changed to %@", orientationString);
}


@end
