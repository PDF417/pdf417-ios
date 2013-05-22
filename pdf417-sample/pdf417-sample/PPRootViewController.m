//
//  PPRootViewController.m
//  PhotoPay
//
//  Created by Jurica Cerovec on 5/26/12.
//  Copyright (c) 2012 Racuni.hr. All rights reserved.
//

#import "PPRootViewController.h"

static const BOOL useModalCameraView = YES;

@interface PPRootViewController ()

- (void)presentCameraViewController:(UIViewController*)cameraViewController isModal:(BOOL)isModal;

- (void)dismissCameraViewControllerModal:(BOOL)isModal;

@end

@implementation PPRootViewController

@synthesize startButton;

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
    
//    // Check if photopay is supported
//    NSError *error;
//    if ([PPCoordinator isPhotoPayUnsupported:&error]) {
//        NSString *messageString = [error localizedDescription];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        return;
//    }
//    
//    // Define the OCR patterns filename
//    static NSString* patternsFileName       = @"European";
//    static NSString* patternsFileExtension  = @"rom";
//    NSString* patternsPath = [[NSBundle mainBundle] pathForResource:patternsFileName ofType:patternsFileExtension];
//    assert(patternsPath != nil);
//    
//    // define license filename
//    static NSString* licenseFilename        = @"iOS";
//    static NSString* licenseFileExtension   = @"License";
//    NSString* licensePath = [[NSBundle mainBundle] pathForResource:licenseFilename ofType:licenseFileExtension];
//    assert(licensePath != nil);
//    
//    // Create object which stores photopay settings
//    NSMutableDictionary* coordinatorSettings = [[NSMutableDictionary alloc] init];
//    
//    // Set the patterns file (required)
//    [coordinatorSettings setValue:patternsPath forKey:kPPOcrPatternsFile];
//    // Set the license file (required)
//    [coordinatorSettings setValue:licensePath forKey:kPPOcrLicenseFile];
//    // present modal (recommended and default) - make sure you dismiss the view controller when done
//    // you also can set this to NO and push camera view controller to navigation view controller
//    [coordinatorSettings setValue:[NSNumber numberWithBool:useModalCameraView] forKey:kPPPresentModal];
//    // Use High camera video preset (recommended)
//    [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPUseVideoPresetHigh];
//    // It's good idea to show instruction on first run, this is default
//    [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPPresentHelpOnFirstRun];
//    // You can display status messages about recognition
//    [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPPresentToastMessages];
//    // This integer value defines after how many seconds photopay times out
//    // Default is 6
//    [coordinatorSettings setValue:[NSNumber numberWithInt:12] forKey:kPPPartialRecognitionTimeoutInterval];
//    // You can set orientation mask for allowed orientations, default is UIInterfaceOrientationMaskAll
//    [coordinatorSettings setValue:[NSNumber numberWithInt:UIInterfaceOrientationMaskLandscape] forKey:kPPHudOrientation];
//    // Set the language. You can use "en", "de", "hr", if not specified, phone default will be used.
//    // Use this according to your app localization strategy
//    [coordinatorSettings setValue:@"de" forKey:kPPLanguage];
//
//    // The appearance and behaviour of viewfinder (the red/green border on the camera screen) can be customized.
//    // You can force the viewfinder move along with the detected payslip if you set YES to this property
//    // NO means viewfinder will be fixed. Not setting this propery will leave default behaviour.
////    [coordinatorSettings setValue:[NSNumber numberWithBool:NO] forKey:kPPViewfinderMoveable];
//    // You can change the color of the viewfinder which denotes detected payslip
//    // Red color cannot be changed since it denotes no payslip is detected.
////    [coordinatorSettings setValue:[UIColor yellowColor] forKey:kPPViewfinderColor];
//    
//    // Define the sound filename played on successful recognition
//    NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
//    [coordinatorSettings setValue:soundPath forKey:kPPSoundFile];
//    
//    // Allocate the recognition coordinator object
//    PPCoordinator *coordinator = [[PPCoordinator alloc] initWithSettings:coordinatorSettings];
//    [coordinatorSettings release];
//    
//    // Create camera view controller
//    UIViewController *cameraViewController = [coordinator cameraViewControllerWithDelegate:self];
//    
//    // present it modally
//    cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentCameraViewController:cameraViewController isModal:useModalCameraView];
//    
//    [coordinator release];
    
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
#pragma mark PhotoPay delegate methods
//
//- (void)cameraViewController:(UIViewController*)cameraViewController
//          didFinishWithError:(NSError*)error {
//    [self dismissCameraViewControllerModal:useModalCameraView];
//}
//
//- (void)cameraViewController:(UIViewController*)cameraViewController
//         didFinishWithResult:(PPRecognitionResult*)result {
//    
//    // Display it
//    if (result != nil) {
//    
//        // Process the result. Here we populate the table with recognition 
//        // results and show it in the next screen
//        PPPaymentDataTableSource* dataSource = [[PPPaymentDataTableSource alloc] initWithPaymentData:result];
//        
//        // Allocate PaymentViewController - responsible for presenting results
//        PPPaymentDataViewController *paymentView = [[PPPaymentDataViewController alloc] initWithDataSource:dataSource];
//        [dataSource release];
//        
//        // We animate payment view only if camera view was not displayed modally
//        BOOL useAnimatedPaymentView = !useModalCameraView;
//        
//        [self.navigationController pushViewController:paymentView animated:useAnimatedPaymentView];
//        
//        [paymentView release];
//    }
//    
//    [self dismissCameraViewControllerModal:useModalCameraView];
//}


@end
