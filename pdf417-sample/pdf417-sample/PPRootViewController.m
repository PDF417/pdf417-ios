//
//  PPRootViewController.m
//  PhotoPay
//
//  Created by Jurica Cerovec on 5/26/12.
//  Copyright (c) 2012 Racuni.hr. All rights reserved.
//

#import "PPRootViewController.h"
#import "PPCameraOverlayViewController.h"
#import "PPYBarcodeOverlayViewController.h"
#import <pdf417/PPBarcode.h>

@interface PPRootViewController () <PPBarcodeDelegate, UIAlertViewDelegate>

- (void)presentCameraViewController:(UIViewController*)cameraViewController isModal:(BOOL)isModal;

- (void)dismissCameraViewControllerModal:(BOOL)isModal;

- (NSString*)barcodeDetailedDataString:(PPBarcodeDetailedData*)barcodeDetailedData;

- (NSString*)simplifiedDetailedDataString:(PPBarcodeDetailedData*)barcodeDetailedData;

@property (nonatomic, assign) BOOL useModalCameraView;

@property (nonatomic, assign) UIViewController<PPScanningViewController>* currentCameraViewController;

@end

@implementation PPRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUseModalCameraView:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IS_IOS7_DEVICE) {
        [[self startButton] setBackgroundColor:[UIColor whiteColor]];
        [[self startCustomUIButtom] setBackgroundColor:[UIColor whiteColor]];
    }
    
    self.title = @"Scanning demo";
    self.versionLabel.text = [NSString stringWithFormat:@"library version: %@",[PPBarcodeCoordinator getBuildVersionString]];
}

- (void)viewDidUnload
{
    [self setStartButton:nil];
    [self setStartCustomUIButtom:nil];
    [super viewDidUnload];
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

- (PPBarcodeCoordinator*)createBarcodeCoordinator {
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
        return nil;
    }
    
    // Create object which stores pdf417 framework settings
    NSMutableDictionary* coordinatorSettings = [[NSMutableDictionary alloc] init];
    
    // Set YES/NO for scanning pdf417 barcode standard (default YES)
    [coordinatorSettings setValue:@(YES) forKey:kPPRecognizePdf417Key];
    // Set YES/NO for scanning qr code barcode standard (default NO)
    [coordinatorSettings setValue:@(YES) forKey:kPPRecognizeQrCodeKey];
    // Set YES/NO for scanning all 1D barcode standards (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognize1DBarcodesKey];
    // Set YES/NO for scanning code 128 barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeCode128Key];
    // Set YES/NO for scanning code 39 barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeCode39Key];
    // Set YES/NO for scanning EAN 8 barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeEAN8Key];
    // Set YES/NO for scanning EAN 13 barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeEAN13Key];
    // Set YES/NO for scanning ITF barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeITFKey];
    // Set YES/NO for scanning UPCA barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeUPCAKey];
    // Set YES/NO for scanning UPCE barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeUPCEKey];
    // Set YES/NO for scanning UPCA barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeUPCAKey];
    // Set YES/NO for scanning UPCE barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeUPCEKey];
    // Set YES/NO for scanning Aztec barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeAztecKey];
    // Set YES/NO for scanning DataMatrix barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeDataMatrixKey];
    
    // There are 4 resolution modes:
    //      kPPUseVideoPreset640x480
    //      kPPUseVideoPresetMedium
    //      kPPUseVideoPresetHigh
    //      kPPUseVideoPresetHighest
    // Set only one.
    [coordinatorSettings setValue:@(YES) forKey:kPPUseVideoPresetHigh];
    
    // Set this to true to scan even barcode not compliant with standards
    // For example, malformed PDF417 barcodes which were incorrectly encoded
    // Use only if necessary because it slows down the recognition process
    [coordinatorSettings setValue:@(YES) forKey:kPPScanUncertainBarcodes];
    
    // Set this to true to scan barcodes which don't have quiet zone (white area) around it
    // Use only if necessary because it slows down the recognition process
    [coordinatorSettings setValue:@(YES) forKey:kPPAllowNullQuietZone];
    
    // Set this to true to allow scanning barcodes with inverted intensities (i.e. white barcodes on black background)
    // NOTE: this options doubles the frame processing time
    // [coordinatorSettings setValue:@(YES) forKey:kPPAllowInverseBarcodes];
    
    // Set this if you want to use front facing camera
    // [coordinatorSettings setValue:@(YES) forKey:kPPUseFrontFacingCamera];
    
    // Set the scanning region, if necessary
    // If you use custom overlay view controller, it's reccommended that you set scanning roi there
    [coordinatorSettings setValue:[NSValue valueWithCGRect:CGRectMake(0.05, 0.05, 0.9, 0.9)] forKey:kPPScanningRoi];
    
    /**
     Set your license key here.
     This license key allows setting overlay views for this application ID: net.photopay.barcode.pdf417-sample
     To test your custom overlays, please use this demo app directly or visit our website www.pdf417.mobi for commercial license
     */
    [coordinatorSettings setValue:@"YWYH-RR5Z-TVMU-TIZM-LKAT-WHIM-XMPN-FIXD"
                           forKey:kPPLicenseKey];

    /**
     If you use enterprise license, set the owner name of the licese.
     If you use regular per app license, leave this line commented.
     */
    // [coordinatorSettings setValue:@"Owner name" forKey:kPPLicenseOwner];

    // present modal (recommended and default) - make sure you dismiss the view controller when done
    // you also can set this to NO and push camera view controller to navigation view controller
    [coordinatorSettings setValue:@([self useModalCameraView]) forKey:kPPPresentModal];
    
    // If you use default camera overlay, you can set orientation mask for allowed orientations
    // default is UIInterfaceOrientationMaskAll
    UIInterfaceOrientationMask mask;
    if ([self useModalCameraView]) {
        // when using FullScreen presentation style, Overlay is responsible for orientation changes
        mask = UIInterfaceOrientationMaskAll;
    } else {
        // when not presenting modally, navigation view controller takes care of the orientation changes.
        // but this depends on your implementation, so use this wisely.
        mask = UIInterfaceOrientationMaskPortrait;
    }
    [coordinatorSettings setValue:@(mask) forKey:kPPHudOrientation];
    
    // Define the sound filename played on successful recognition
    NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    [coordinatorSettings setValue:soundPath forKey:kPPSoundFile];
    
    // Allocate and the recognition coordinator object
    PPBarcodeCoordinator *coordinator = [[PPBarcodeCoordinator alloc] initWithSettings:coordinatorSettings];
    return coordinator;
}

- (IBAction)startPhotoPay:(id)sender {
    PPBarcodeCoordinator *coordinator = [self createBarcodeCoordinator];
    if (coordinator == nil) {
        return;
    }
    
    // Create camera view controller
    UIViewController<PPScanningViewController>* cameraViewController =
        [coordinator cameraViewControllerWithDelegate:self];
    [self setCurrentCameraViewController:cameraViewController];
    
    // present it modally
    cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentCameraViewController:cameraViewController isModal:[self useModalCameraView]];
}

- (IBAction)startCustomUIScan:(id)sender {
    PPBarcodeCoordinator *coordinator = [self createBarcodeCoordinator];
    if (coordinator == nil) {
        return;
    }
    
    // Simple example
    PPCameraOverlayViewController *simpleOverlay =
        [[PPCameraOverlayViewController alloc] initWithNibName:@"PPCameraOverlayViewController"
                                                        bundle:nil];
    
    // Complex overlay, initialize cameraViewController with this object to see how it works
    PPYBarcodeOverlayViewController *complexOverlay = [[PPYBarcodeOverlayViewController alloc] init];
    
    // Create camera view controller
    UIViewController<PPScanningViewController>* cameraViewController =
        [coordinator cameraViewControllerWithDelegate:self overlayViewController:simpleOverlay];
    
    [self setCurrentCameraViewController:cameraViewController];
    
    // present it modally
    cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    cameraViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [self presentCameraViewController:cameraViewController
                              isModal:[self useModalCameraView]];
}

/**
 * Method presents a modal view controller and uses non deprecated method in iOS 6
 */
- (void)presentCameraViewController:(UIViewController*)cameraViewController isModal:(BOOL)isModal {
    if (isModal) {
        cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        cameraViewController.modalPresentationStyle = UIModalPresentationFullScreen;

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

- (void)cameraViewControllerWasClosed:(id<PPScanningViewController>)cameraViewController {
    [self setCurrentCameraViewController:nil];
    
    // this stops the scanning and dismisses the camera screen
    [self dismissCameraViewControllerModal:[self useModalCameraView]];
}

- (void)processScanningResult:(PPScanningResult*)result
         cameraViewController:(id<PPScanningViewController>)cameraViewController {
    
    // continue scanning if nothing was returned
    if (result == nil) {
        return;
    }
    
    // this pauses scanning without dismissing camera screen
    [cameraViewController pauseScanning];
    
    // obtain UTF8 string from barcode data
    NSString *message = [[NSString alloc] initWithData:[result data] encoding:NSUTF8StringEncoding];
    if (message == nil) {
        // if UTF8 wasn't correct encoding, try ASCII
        message = [[NSString alloc] initWithData:[result data] encoding:NSASCIIStringEncoding];
    }
    NSLog(@"Barcode text:\n%@", message);
    
    NSString* type = [PPScanningResult toTypeName:[result type]];
    NSLog(@"Barcode type:\n%@", type);
    
    // Check if barcode is uncertain
    // This is guaranteed not to happen if you didn't set kPPScanUncertainBarcodes key value
    BOOL isUncertain = [result isUncertain];
    if (isUncertain) {
        NSLog(@"Uncertain scanning data!");
        type = [type stringByAppendingString:@" - uncertain"];
        
        // Perform some kind of integrity validation to see if the returned value is really complete
        BOOL valid = YES;
        if (!valid) {
            // this resumes scanning, and tries agian to find valid barcode
            [cameraViewController resumeScanning];
            return;
        }
    }
    
    // obtain raw data from barcode
    PPBarcodeDetailedData* barcodeDetailedData = result.rawData;
    NSString *rawInfo = [self barcodeDetailedDataString:barcodeDetailedData]; // raw data
    NSString *simplifiedRawInfo = [self simplifiedDetailedDataString:barcodeDetailedData]; // simplified method for raw data
    NSString *rawResult = [NSString stringWithFormat:@"%@\n\n%@\n", rawInfo, simplifiedRawInfo];
    
    // prepare and show alert view with result
    NSString* uiMessage = [NSString stringWithFormat:@"%@\n\nRaw data:\n\n%@", message, rawResult];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:type
                                                        message:uiMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Again"
                                              otherButtonTitles:@"Done", nil];
    
    // We must not forget to call either
    //  [cameraViewController resumeScanning];
    // or
    //  [self dismissCameraViewControllerModal:[self useModalCameraView]];
    // in Alert View's callback
    [alertView show];
}

- (void)processUSDLResult:(PPScanningResult*)result
         cameraViewController:(id<PPScanningViewController>)cameraViewController {

}

- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController obtainedBaseResult:(PPBaseResult *)result {
    if ([result resultType] == PPBaseResultTypeBarcode && [result isKindOfClass:[PPScanningResult class]]) {
        PPScanningResult* scanningResult = (PPScanningResult*)result;
        [self processScanningResult:scanningResult cameraViewController:cameraViewController];
    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[self currentCameraViewController] resumeScanning];
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Done"]) {
        [self setCurrentCameraViewController:nil];
        [self dismissCameraViewControllerModal:[self useModalCameraView]];
    }
}

#pragma mark - Helper methods for barcode decoding

- (NSString*)barcodeDetailedDataString:(PPBarcodeDetailedData*)barcodeDetailedData {
    // obtain barcode elements array
    NSArray* barcodeElements = [barcodeDetailedData barcodeElements];
    NSMutableString* barcodeDetailedDataString = [NSMutableString stringWithFormat:@"Total elements: %lu\n", (unsigned long)[barcodeElements count]];
    
    for (int i = 0; i < [barcodeElements count]; ++i) {
        
        // each element in barcodeElements array is of type PPBarcodeElement*
        PPBarcodeElement* barcodeElement = [[barcodeDetailedData barcodeElements] objectAtIndex:i];
        
        // you can determine element type with [barcodeElement elementType]
        [barcodeDetailedDataString appendFormat:@"Element #%d is of type %@\n", (i + 1), [barcodeElement elementType] == PPTextElement ? @"text" : @"byte"];
        
        // obtain raw bytes of the barcode element
        NSData* bytes = [barcodeElement elementBytes];
        [barcodeDetailedDataString appendFormat:@"Length=%lu {", (unsigned long)[bytes length]];
        
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

@end
