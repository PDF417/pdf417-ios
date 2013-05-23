//
//  PPRootViewController.m
//  PhotoPay
//
//  Created by Jurica Cerovec on 5/26/12.
//  Copyright (c) 2012 Racuni.hr. All rights reserved.
//

#import "PPRootViewController.h"
#import <pdf417/PPBarcode.h>

@interface PPRootViewController () <PPBarcodeDelegate>

- (void)presentCameraViewController:(UIViewController*)cameraViewController isModal:(BOOL)isModal;

- (void)dismissCameraViewControllerModal:(BOOL)isModal;

@property (nonatomic, assign) BOOL useModalCameraView;
@property (nonatomic, retain) PPScanningResult* scanResult;

@end

@implementation PPRootViewController

@synthesize startButton;
@synthesize useModalCameraView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        useModalCameraView = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setStartButton:nil];
    [self setScanResult:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self scanResult] != nil) {
        
        NSString *message = [[NSString alloc] initWithData:[[self scanResult] data] encoding:NSUTF8StringEncoding];
        
        if (message == nil) {
            message = [[NSString alloc] initWithData:[[self scanResult] data] encoding:NSASCIIStringEncoding];
        }
        
        NSLog(@"Barcode text:\n%@", message);
        
        NSString* type = @"Result:";
        if ([[self scanResult] type] == PPScanningResultPdf417) {
            type = @"PDF417:";
        } else if ([[self scanResult] type] == PPScanningResultQrCode) {
            type = @"QR Code:";
        }
        
        NSLog(@"Barcode type:\n%@", type);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:type message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        
        [alertView show];
        
        [self setScanResult:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Starting PhotoPay

- (IBAction)startPhotoPay:(id)sender {
    
    // Check if barcode scanning is supported
    NSError *error;
    if ([PPBarcodeCoordinator isScanningUnsupported:&error]) {
        NSString *messageString = [error localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:messageString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // Create object which stores pdf417 framework settings
    NSMutableDictionary* coordinatorSettings = [[NSMutableDictionary alloc] init];
    
    // Set YES/NO for scanning pdf417 barcode standard (default YES)
    [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizePdf417Key];
    // Set YES/NO for scanning qr code barcode standard (default NO)
    [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeQrCodeKey];
    
    // present modal (recommended and default) - make sure you dismiss the view controller when done
    // you also can set this to NO and push camera view controller to navigation view controller 
    [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPPresentModal];
    // You can set orientation mask for allowed orientations, default is UIInterfaceOrientationMaskAll
    [coordinatorSettings setValue:[NSNumber numberWithInt:UIInterfaceOrientationMaskAll] forKey:kPPHudOrientation];
    
    // Define the sound filename played on successful recognition
    NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    [coordinatorSettings setValue:soundPath forKey:kPPSoundFile];
    
    // Allocate the recognition coordinator object
    PPBarcodeCoordinator *coordinator = [[PPBarcodeCoordinator alloc] initWithSettings:coordinatorSettings];
    
    // Create camera view controller
    UIViewController *cameraViewController = [coordinator cameraViewControllerWithDelegate:self];
    
    // present it modally
    cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentCameraViewController:cameraViewController isModal:[self useModalCameraView]];
    
    NSLog(@"Starting");
}

/**
 * Method presents a modal view controller and uses non deprecated method in iOS 6
 */
- (void)presentCameraViewController:(UIViewController*)cameraViewController isModal:(BOOL)isModal {
    if (isModal) {
        cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [self presentViewController:cameraViewController animated:YES completion:nil];
        } else {
            [self presentModalViewController:cameraViewController animated:YES];
        }
    } else {
        [[self navigationController] pushViewController:cameraViewController animated:YES];
    }
}

/**
 * Method dismisses a modal view controller and uses non deprecated method in iOS 6
 */
- (void)dismissCameraViewControllerModal:(BOOL)isModal {
    if (isModal) {
        if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

#pragma mark -
#pragma mark PPBarcode delegate methods

- (void)cameraViewControllerWasClosed:(UIViewController *)cameraViewController {
    [self dismissCameraViewControllerModal:[self useModalCameraView]];
}

- (void)cameraViewController:(UIViewController *)cameraViewController obtainedResult:(PPScanningResult *)result {
    
    NSString *message = [[NSString alloc] initWithData:[result data] encoding:NSUTF8StringEncoding];
    
    if (message == nil) {
        message = [[NSString alloc] initWithData:[result data] encoding:NSASCIIStringEncoding];
    }
    
    NSLog(@"Barcode text:\n%@", message);
    
    NSString* type = @"Result:";
    if ([result type] == PPScanningResultPdf417) {
        type = @"PDF417:";
    } else if ([result type] == PPScanningResultQrCode) {
        type = @"QR Code:";
    }
    
    NSLog(@"Barcode type:\n%@", type);
    
    [self setScanResult:result];
    [self dismissCameraViewControllerModal:[self useModalCameraView]];
}

@end
