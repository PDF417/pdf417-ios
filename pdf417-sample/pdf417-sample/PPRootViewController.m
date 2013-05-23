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
    
//    [self setTitle:_(@"Demo")];
}

- (void)viewDidUnload
{
    [self setStartButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    
    // Check if photopay is supported
    NSError *error;
    if ([PPBarcodeCoordinator isScanningUnsupported:&error]) {
        NSString *messageString = [error localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // Define the OCR patterns filename
    static NSString* patternsFileName       = @"European";
    static NSString* patternsFileExtension  = @"rom";
    NSString* patternsPath = [[NSBundle mainBundle] pathForResource:patternsFileName ofType:patternsFileExtension];
    assert(patternsPath != nil);
    
    // define license filename
    static NSString* licenseFilename        = @"iOS";
    static NSString* licenseFileExtension   = @"License";
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:licenseFilename ofType:licenseFileExtension];
    assert(licensePath != nil);
    
    // Create object which stores photopay settings
    NSMutableDictionary* coordinatorSettings = [[NSMutableDictionary alloc] init];
    
    // present modal (recommended and default) - make sure you dismiss the view controller when done
    // you also can set this to NO and push camera view controller to navigation view controller
    [coordinatorSettings setValue:[NSNumber numberWithBool:useModalCameraView] forKey:kPPPresentModal];
    // Use High camera video preset (recommended)
    [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPUseVideoPresetHigh];
    
    // You can set orientation mask for allowed orientations, default is UIInterfaceOrientationMaskAll
    [coordinatorSettings setValue:[NSNumber numberWithInt:UIInterfaceOrientationMaskLandscape] forKey:kPPHudOrientation];
    // Set the language. You can use "en", "de", "hr", if not specified, phone default will be used.
    // Use this according to your app localization strategy
    [coordinatorSettings setValue:@"en" forKey:kPPLanguage];

    // The appearance and behaviour of viewfinder (the red/green border on the camera screen) can be customized.
    // You can force the viewfinder move along with the detected payslip if you set YES to this property
    // NO means viewfinder will be fixed. Not setting this propery will leave default behaviour.
//    [coordinatorSettings setValue:[NSNumber numberWithBool:NO] forKey:kPPViewfinderMoveable];
    // You can change the color of the viewfinder which denotes detected payslip
    // Red color cannot be changed since it denotes no payslip is detected.
//    [coordinatorSettings setValue:[UIColor yellowColor] forKey:kPPViewfinderColor];
    
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
    CameraViewController* cameraView = (CameraViewController*)cameraViewController;
    [cameraView pauseScanning];
    
    NSString *message = [[NSString alloc] initWithData:[result data] encoding:NSUTF8StringEncoding];
    if (message == nil) {
        message = [[NSString alloc] initWithData:[result data] encoding:NSASCIIStringEncoding];
    }
    NSLog(@"Result is:\n%@", message);
    
    NSString* title = @"Result:";
    if ([result type] == PPScanningResultPdf417) {
        title = @"PDF417:";
    } else if ([result type] == PPScanningResultQrCode) {
        title = @"QR Code:";
    }
//    
//    BlockAlertView *alert = [BlockAlertView alertWithTitle:title message:message];
//    
//    [alert setCancelButtonWithTitle:@"Cancel" block:^{
//        [cameraView resumeScanning];
//        //        [self dismissCameraViewControllerModal:YES];
//    }];
//    
//    [alert addButtonWithTitle:@"Copy text" block:^{
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        pasteboard.string = message;
//        [self dismissCameraViewControllerModal:YES];
//    }];
//    
//    NSError *error = NULL;
//    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeLink error:&error];
//    
//    int numberOfMatches = 0;
//    NSArray *matches = [detector matchesInString:message
//                                         options:0
//                                           range:NSMakeRange(0, [message length])];
//    NSURL *linkUrl;
//    for (NSTextCheckingResult *match in matches) {
//        NSURL *url = [match URL];
//        NSLog(@"URL %@", [url description]);
//        if ([[url scheme] isEqual:@"tel"]) {
//            NSLog(@"found telephone url: %@", url);
//        } else {
//            linkUrl = url;
//            numberOfMatches++;
//        }
//    }
//    if (numberOfMatches == 1 && linkUrl != nil) {
//        [alert addButtonWithTitle:@"Open URL in Safari" block:^{
//            if (![[UIApplication sharedApplication] openURL:linkUrl]) {
//                NSLog(@"%@%@",@"Failed to open url:",[linkUrl description]);
//            }
//            [self dismissCameraViewControllerModal:YES];
//        }];
//    }
//    
//    //
//    //    NSURL *url = [NSURL URLWithString:@"anasdad"];
//    //
//    //    [alert addButtonWithTitle:@"Open URL in Safari" block:^{
//    //        if (![[UIApplication sharedApplication] openURL:url]) {
//    //            NSLog(@"%@%@",@"Failed to open url:",[url description]);
//    //        }
//    //        [self dismissCameraViewControllerModal:YES];
//    //    }];
//    
//    //    detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypePhoneNumber error:&error];
//    //
//    //    numberOfMatches = [detector numberOfMatchesInString:message
//    //                                                options:0
//    //                                                  range:NSMakeRange(0, [message length])];
//    //
//    //    if (numberOfMatches == 1) {
//    //        NSTextCheckingResult * match = [detector firstMatchInString:message options:0 range:NSMakeRange(0, [message length])];
//    //        NSLog(@"Phone: %@", [match phoneNumber]);
//    //        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [match phoneNumber]]];
//    //        [alert addButtonWithTitle:@"Call phone" block:^{
//    //            if (![[UIApplication sharedApplication] openURL:url]) {
//    //                NSLog(@"%@%@",@"Failed to open url:",[url description]);
//    //            }
//    //            [self dismissCameraViewControllerModal:YES];
//    //        }];
//    //    }
//    
//    [alert show];
}

@end
