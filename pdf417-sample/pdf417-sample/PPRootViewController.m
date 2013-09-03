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

- (NSString*)barcodeDetailedDataString:(PPBarcodeDetailedData*)barcodeDetailedData;

- (NSString*)simplifiedDetailedDataString:(PPBarcodeDetailedData*)barcodeDetailedData;

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
        
        // get string value from scanning result
        NSString *message = [[NSString alloc] initWithData:[[self scanResult] data] encoding:NSUTF8StringEncoding];
        if (message == nil) {
            message = [[NSString alloc] initWithData:[[self scanResult] data] encoding:NSASCIIStringEncoding];
        }
        
        // get barcode type
        NSString* type = [PPScanningResult getTypeName:[[self scanResult] type]];
        
        // obtain raw data from barcode
        PPBarcodeDetailedData* barcodeDetailedData = self.scanResult.rawData;
        NSString *rawInfo = [self barcodeDetailedDataString:barcodeDetailedData]; // raw data
        NSString *simplifiedRawInfo = [self simplifiedDetailedDataString:barcodeDetailedData]; // simplified method for raw data
        NSString *rawResult = [NSString stringWithFormat:@"%@\n\n%@\n", rawInfo, simplifiedRawInfo];
        
        // prepare and show alert view with result
        NSString* uiMessage = [NSString stringWithFormat:@"%@\n\nRaw data:\n\n%@", message, rawResult];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:type
                                                            message:uiMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [self setScanResult:nil];
    }
}

- (NSString*)barcodeDetailedDataString:(PPBarcodeDetailedData*)barcodeDetailedData {
    // obtain barcode elements array
    NSArray* barcodeElements = [barcodeDetailedData barcodeElements];
    NSMutableString* barcodeDetailedDataString = [NSMutableString stringWithFormat:@"Total elements: %d\n", [barcodeElements count]];
    
    for (int i = 0; i < [barcodeElements count]; ++i) {
        
        // each element in barcodeElements array is of type PPBarcodeElement*
        PPBarcodeElement* barcodeElement = [[barcodeDetailedData barcodeElements] objectAtIndex:i];
        
        // you can determine element type with [barcodeElement elementType]
        [barcodeDetailedDataString appendFormat:@"Element #%d is of type %@\n", (i + 1), [barcodeElement elementType] == PPTextElement ? @"text" : @"byte"];
        
        // obtain raw bytes of the barcode element
        NSData* bytes = [barcodeElement elementBytes];
        [barcodeDetailedDataString appendFormat:@"Length=%d {", [bytes length]];
        
        const unsigned char* nBytes = [bytes bytes];
        for (int j = 0; j < [bytes length]; ++j) {
            // append each byte to raw result
            [barcodeDetailedDataString appendFormat:@"%d", nBytes[j]];
            
            // delimit bytes with comma
            if (j != [bytes length] - 1) {
                [barcodeDetailedDataString appendString:@", "];
            }
        }
        
        [barcodeDetailedDataString appendString:@"}\n"];
    }
    
    return barcodeDetailedDataString;
}

- (NSString*)simplifiedDetailedDataString:(PPBarcodeDetailedData*)barcodeDetailedData {
    
    NSMutableString* simplifiedRawInfo = [NSMutableString stringWithString:@"Raw data merged:\n{"];
    
    // if you don't like bothering with barcode elements
    // you can get all barcode bytes in one byte array with
    // getAllData method
    NSData* allData = [barcodeDetailedData getAllData];
    const unsigned char* allBytes = [allData bytes];
    
    for (int i = 0; i < [allData length]; ++i) {
        // append each byte to raw result
        [simplifiedRawInfo appendFormat:@"%d", allBytes[i]];
        
        // delimit bytes with comma
        if (i != [allData length] - 1) {
            [simplifiedRawInfo appendString:@", "];
        }
    }
    
    [simplifiedRawInfo appendString:@"}\n"];
    
    return simplifiedRawInfo;
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
    // Set YES/NO for scanning all 1D barcode standards (default NO)
    [coordinatorSettings setValue:[NSNumber numberWithBool:NO] forKey:kPPRecognize1DBarcodesKey];
    // Set YES/NO for scanning code 128 barcode standard (default NO)
    [coordinatorSettings setValue:[NSNumber numberWithBool:NO] forKey:kPPRecognizeCode128Key];
    // Set YES/NO for scanning code 39 barcode standard (default NO)
    [coordinatorSettings setValue:[NSNumber numberWithBool:NO] forKey:kPPRecognizeCode39Key];
    // Set YES/NO for scanning EAN 8 barcode standard (default NO)
    [coordinatorSettings setValue:[NSNumber numberWithBool:NO] forKey:kPPRecognizeEAN8Key];
    // Set YES/NO for scanning EAN 13 barcode standard (default NO)
    [coordinatorSettings setValue:[NSNumber numberWithBool:NO] forKey:kPPRecognizeEAN13Key];
    // Set YES/NO for scanning ITF barcode standard (default NO)
    [coordinatorSettings setValue:[NSNumber numberWithBool:NO] forKey:kPPRecognizeITFKey];
    // Set YES/NO for scanning UPCA barcode standard (default NO)
    [coordinatorSettings setValue:[NSNumber numberWithBool:NO] forKey:kPPRecognizeUPCAKey];
    // Set YES/NO for scanning UPCE barcode standard (default NO)
    [coordinatorSettings setValue:[NSNumber numberWithBool:NO] forKey:kPPRecognizeUPCEKey];
    
    // Set only one resolution mode
//    [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPUseVideoPreset640x480];
//    [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPUseVideoPresetMedium];
//    [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPUseVideoPresetHigh];
    [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPUseVideoPresetHighest];
    
    /** Set the license key */
//    [coordinatorSettings setValue:@"Enter_License_Key_Here" forKey:kPPLicenseKey];
    
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
    
    NSString* type = [PPScanningResult getTypeName:[result type]];
    
    NSLog(@"Barcode type:\n%@", type);
    
    [self setScanResult:result];
    [self dismissCameraViewControllerModal:[self useModalCameraView]];
}

@end
