//
//  PPBaseOverlayViewController.m
//  BarcodeFramework
//
//  Created by Jura on 06/06/14.
//  Copyright (c) 2014 PhotoPay. All rights reserved.
//

#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag
#endif

#import "PPYBaseOverlayViewController.h"
#import "PPYCameraButton.h"
#import "PPYOverlaySubview.h"

@implementation PPYBaseOverlayViewController

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _overlaySubviews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _overlaySubviews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(overlayWillRemoveAllAnimations)]) {
            [obj overlayWillRemoveAllAnimations];
        }
    }];
    [_overlaySubviews release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj addToSuperview:self.view];
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setFrame:self.view.bounds];
    }];
}

#pragma mark - autorotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (deviceOrientation != UIDeviceOrientationUnknown &&
        deviceOrientation != UIDeviceOrientationFaceUp &&
        deviceOrientation != UIDeviceOrientationFaceDown) {
        UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)deviceOrientation;
        if (((1 << interfaceOrientation) & [self supportedInterfaceOrientations]) > 0) {
            return interfaceOrientation;
        }
    }

    if (((1 << [[UIApplication sharedApplication] statusBarOrientation]) & [self supportedInterfaceOrientations]) > 0) {
        return [[UIApplication sharedApplication] statusBarOrientation];
    }

    if (((1 << UIInterfaceOrientationPortrait) & [self supportedInterfaceOrientations]) > 0) {
        return UIInterfaceOrientationPortrait;
    }

    if (((1 << UIInterfaceOrientationLandscapeRight) & [self supportedInterfaceOrientations]) > 0) {
        return UIInterfaceOrientationLandscapeRight;
    }

    if (((1 << UIInterfaceOrientationLandscapeLeft) & [self supportedInterfaceOrientations]) > 0) {
        return UIInterfaceOrientationLandscapeLeft;
    }

    if (((1 << UIInterfaceOrientationPortraitUpsideDown) & [self supportedInterfaceOrientations]) > 0) {
        return UIInterfaceOrientationPortraitUpsideDown;
    }

    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ((1 << interfaceOrientation) & [self supportedInterfaceOrientations]) > 0;
}

#pragma mark - CameraViewController

- (void)cameraViewControllerDidResumeScanning:(id<PPScanningViewController>)cameraViewController {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(overlayDidResumeScanning)]) {
            [obj overlayDidResumeScanning];
        }
    }];
}

- (void)cameraViewControllerDidStopScanning:(id<PPScanningViewController>)cameraViewController {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(overlayDidStopScanning)]) {
            [obj overlayDidStopScanning];
        }
    }];
}

- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
          didPublishProgress:(float)progress {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(overlayDidPublishProgress:)]) {
            [obj overlayDidPublishProgress:progress];
        }
    }];
}

- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
             didFindLocation:(NSArray*)cornerPoints
                  withStatus:(PPDetectionStatus)status {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(overlayDidFindLocation:withStatus:)]) {
            [obj overlayDidFindLocation:cornerPoints withStatus:status];
        }
    }];
}

- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
          didObtainOcrResult:(PPOcrResult*)ocrResult
              withResultName:(NSString*)resultName {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(overlayDidObtainOcrResult:withResultName:)]) {
            [obj overlayDidObtainOcrResult:ocrResult withResultName:resultName];
        }
    }];
}

- (void)cameraViewControllerDidStartRecognition:(id<PPScanningViewController>)cameraViewController {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(overlayDidStartRecognition)]) {
            [obj overlayDidStartRecognition];
        }
    }];
}

- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
didFinishRecognitionWithResult:(id)result {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(overlayDidFinishRecognitionWithResult:)]) {
            [obj overlayDidFinishRecognitionWithResult:result];
        }
    }];
}

- (void)cameraViewController:(id<PPScanningViewController>)cameraViewController
            didOutputResults:(NSArray*)results {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(overlayDidOutputResults:)]) {
            [obj overlayDidOutputResults:results];
        }
    }];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(willRotateToInterfaceOrientation:duration:)]) {
            [obj willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
        }
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(didRotateFromInterfaceOrientation:)]) {
            [obj didRotateFromInterfaceOrientation:fromInterfaceOrientation];
        }
    }];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [[self overlaySubviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(willAnimateRotationToInterfaceOrientation:duration:)]) {
            [obj willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
        }
    }];
}

@end
