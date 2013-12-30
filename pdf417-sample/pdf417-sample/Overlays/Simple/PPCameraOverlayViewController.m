//
//  PPCameraOverlayViewController.m
//  pdf417-sample
//
//  Created by Jurica Cerovec on 13/11/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import "PPCameraOverlayViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PPCameraOverlayViewController ()

/* Animation layer for barcode location drawing */
@property (nonatomic, retain) CAShapeLayer* drawingLayer;

@end

@implementation PPCameraOverlayViewController

@synthesize drawingLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [[self drawingLayer] setDelegate:nil];
    [self setDrawingLayer:nil];
    [self setCloseButton:nil];
    [self setTorchButton:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [[self drawingLayer] setDelegate:nil];
    [self setDrawingLayer:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // on devices which don't support torch, torch button should be disabled
    if (![[self delegate] overlayViewControllerShouldDisplayTorch:self]) {
        [[self torchButton] setHidden:YES];
    }
    
    // add drawing layer to view
    [self initDrawingLayerWithBounds:[self view].bounds];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark user interaction methods

- (IBAction)closePressed:(id)sender {
    [[self delegate] overlayViewControllerWillCloseCamera:self];
}

- (IBAction)torchPressed:(id)sender {
    static BOOL torchOn = NO;
    torchOn = [[self delegate] isTorchOn];
    torchOn = !torchOn;
    if ([[self delegate] overlayViewControllerShouldDisplayTorch:self]) {
        [[self delegate] overlayViewController:self
                                  willSetTorch:torchOn];
    }
}

#pragma mark -
#pragma mark autorotation

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
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
    
    CGRect size = [[self view] bounds];
    
    BOOL detectionSuccess = NO;
    
    switch (status) {
        case PPDetectionStatusSuccess: {
            NSLog(@"Detection was success");
            detectionSuccess = YES;
            break;
        } case PPDetectionStatusPdf417Success: {
            NSLog(@"PDF417 Barcode detection was success");
            detectionSuccess = YES;
            break;
        } case PPDetectionStatusQRSuccess: {
            detectionSuccess = YES;
            NSLog(@"QR code detection was success");
            break;
        }
        case PPDetectionStatusFallbackSuccess: {
            detectionSuccess = YES;
            NSLog(@"Detection fallback was success");
            break;
        }
        case PPDetectionStatusFail:
            NSLog(@"Detection failed");
            break;
        case PPDetectionStatusCameraAtAngle:
            NSLog(@"Camera is at an angle");
            break;
        case PPDetectionStatusCameraRotated:
            NSLog(@"Camera is rotated");
            break;
        case PPDetectionStatusCameraTooHigh:
            NSLog(@"Camera is too high");
            break;
        case PPDetectionStatusPartialForm:
            NSLog(@"The form detected is only partially on screen");
            break;
        default:
            break;
    }
            
    if (detectionSuccess) {
        CGMutablePathRef drawingPath = CGPathCreateMutable();
        [PPCameraOverlayViewController createPath:drawingPath
                                         withDots:cornerPoints
                                          forSize:size];
        drawingLayer.path = drawingPath;
        [self startDotAnimation:[[UIColor greenColor] CGColor]];
    }
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

#pragma mark - Location drawing

- (void)initDrawingLayerWithBounds:(CGRect)bounds {
    [[self drawingLayer] removeFromSuperlayer];
    
    CAShapeLayer *newDrawingLayer = [[CAShapeLayer alloc] init];
    UIColor* color = [UIColor greenColor];
    [self setDrawingLayer:newDrawingLayer];
    
    drawingLayer.frame = bounds;
    drawingLayer.contentsGravity = kCAGravityResize;
    drawingLayer.strokeColor = [color CGColor];
    drawingLayer.fillColor = [[UIColor clearColor] CGColor];
    drawingLayer.opacity = 0.9f;
    drawingLayer.delegate = self;
    drawingLayer.lineWidth = 4.0f;
    drawingLayer.masksToBounds = YES;
    
    CGMutablePathRef newPath = CGPathCreateMutable();
    drawingLayer.path = newPath;
    CGPathRelease(newPath);
    
    // we have to do this trick to make it work in all orientations
    // we add drawing layer to view's superview, which isn't rotatable
    CALayer *viewLayer = [[self view] layer];
    [viewLayer setMasksToBounds:YES];
    [viewLayer addSublayer:drawingLayer];
}

- (void)startDotAnimation:(CGColorRef)toColor {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    
    animation.duration = 0.4f;
	animation.repeatCount = 1;
    animation.autoreverses = YES;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAShapeLayer *layer = (CAShapeLayer*)[drawingLayer presentationLayer];
	animation.fromValue = (id)layer.strokeColor;
	animation.toValue = (__bridge id)toColor;
    animation.removedOnCompletion = YES;
    
    drawingLayer.strokeColor = toColor;
    
	[drawingLayer addAnimation:animation forKey:@"strokeColor"];
}

+ (void)createPath:(CGMutablePathRef)path
          withDots:(NSArray*)dots
           forSize:(CGRect)size {
    
    const int radius = 4;
    if (dots != nil) {
        for (int i = 0; i < [dots count]; i++) {
            CGPoint point = [[dots objectAtIndex:i] CGPointValue];
            CGPathMoveToPoint(path, nil, point.x + radius, point.y);
            CGPathAddArc(path, nil, point.x, point.y, radius, 0, 2*M_PI, YES);
        }
        if ([dots count] > 1) {
            CGPoint point = [[dots objectAtIndex:0] CGPointValue];
            CGPathMoveToPoint(path, nil, point.x, point.y);
        }
    }
    
    CGPathCloseSubpath(path);
}

@end
