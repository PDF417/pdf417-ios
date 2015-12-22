//
//  ViewController.m
//  pdf417-sample
//
//  Created by Jura on 16/07/15.
//  Copyright (c) 2015 MicroBlink. All rights reserved.
//

#import "ViewController.h"

#import <MicroBlink/MicroBlink.h>

#import "PPCameraOverlayViewController.h"

@interface ViewController () <PPScanDelegate, UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Method allocates and initializes the Scanning coordinator object.
 * Coordinator is initialized with settings for scanning
 *
 *  @param error Error object, if scanning isn't supported
 *
 *  @return initialized coordinator
 */
- (PPCoordinator *)coordinatorWithError:(NSError**)error {

    /** 0. Check if scanning is supported */

    if ([PPCoordinator isScanningUnsupported:error]) {
        return nil;
    }


    /** 1. Initialize the Scanning settings */

    // Initialize the scanner settings object. This initialize settings with all default values.
    PPSettings *settings = [[PPSettings alloc] init];


    /** 2. Setup the license key */

    // Visit www.microblink.com to get the license key for your app
    settings.licenseSettings.licenseKey = @"YXH25YNJ-CV7SNCDH-JWBG7IUV-6E5UYDUG-GQYAGQ2Z-EDEPPGKJ-O5KAQRDA-ID2NNNJI";


    /**
     * 3. Set up what is being scanned. See detailed guides for specific use cases.
     * Here's an example for initializing PDF417 scanning
     */

    // To specify we want to perform PDF417 recognition, initialize the PDF417 recognizer settings
    PPPdf417RecognizerSettings *pdf417RecognizerSettings = [[PPPdf417RecognizerSettings alloc] init];

    // Add PDF417 Recognizer setting to a list of used recognizer settings
    [settings.scanSettings addRecognizerSettings:pdf417RecognizerSettings];

    // To specify we want to perform recognition of other barcode formats, initialize the ZXing recognizer settings
    PPZXingRecognizerSettings *zxingRecognizerSettings = [[PPZXingRecognizerSettings alloc] init];
    zxingRecognizerSettings.scanQR = YES; // we use just QR code

    // Add ZXingRecognizer setting to a list of used recognizer settings
    [settings.scanSettings addRecognizerSettings:zxingRecognizerSettings];

    // To specify we want to scan USDLs, initialize USDL rcognizer settings
    PPUsdlRecognizerSettings *usdlRecognizerSettings = [[PPUsdlRecognizerSettings alloc] init];

    // Add USDL Recognizer setting to a list of used recognizer settings
    [settings.scanSettings addRecognizerSettings:usdlRecognizerSettings];

    /** 4. Initialize the Scanning Coordinator object */
    
    PPCoordinator *coordinator = [[PPCoordinator alloc] initWithSettings:settings];

    return coordinator;
}

- (void)showCoordinatorError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                         message:[error localizedDescription]
                                                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];

    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)didTapScan:(id)sender {

    /** Instantiate the scanning coordinator */
    NSError *error;
    PPCoordinator *coordinator = [self coordinatorWithError:&error];

    /** If scanning isn't supported, show an error */
    if (coordinator == nil) {
        [self showCoordinatorError:error];
        return;
    }

    /** Allocate and present the scanning view controller */
    UIViewController<PPScanningViewController>* scanningViewController = [coordinator cameraViewControllerWithDelegate:self];

    scanningViewController.autorotate = YES;
    scanningViewController.supportedOrientations = UIInterfaceOrientationMaskAllButUpsideDown;

    /** You can use other presentation methods as well */
    [self presentViewController:scanningViewController animated:YES completion:nil];
}

- (IBAction)didTapScanCustomUI:(id)sender {
    /** Instantiate the scanning coordinator */

    NSError *error;
    PPCoordinator *coordinator = [self coordinatorWithError:&error];

    /** If scanning isn't supported, show an error */
    if (coordinator == nil) {
        [self showCoordinatorError:error];
        return;
    }

    /** Present the scanning view controller */

    PPCameraOverlayViewController *overlayVC = [[PPCameraOverlayViewController alloc] init];

    UIViewController<PPScanningViewController>* scanningViewController = [coordinator cameraViewControllerWithDelegate:self
                                                                                                 overlayViewController:overlayVC];

    // You can use other presentation methods as well
    [self presentViewController:scanningViewController animated:YES completion:nil];
}

- (void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController> *)scanningViewController {
    // Add any logic which handles UI when app user doesn't allow usage of the phone's camera
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController
                  didFindError:(NSError *)error {
    // Can be ignored. See description of the method
}

- (void)scanningViewControllerDidClose:(UIViewController<PPScanningViewController> *)scanningViewController {

    // As scanning view controller is presented full screen and modally, dismiss it
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController
              didOutputResults:(NSArray *)results {

    // Here you process scanning results. Scanning results are given in the array of PPRecognizerResult objects.

    // If results are empty, continue scanning without any actions
    if (results == nil || [results count] == 0) {
        return;
    }

    // first, pause scanning until we process all the results
    [scanningViewController pauseScanning];

    NSString* message;
    NSString* title;

    // we prefer finding USDL results

    BOOL usdlFound = false;

    // Collect data from the result
    for (PPRecognizerResult* result in results) {

        if ([result isKindOfClass:[PPUsdlRecognizerResult class]]) {
            PPUsdlRecognizerResult *usdlResult = (PPUsdlRecognizerResult *)result;
            title = @"USDL";
            message = [[usdlResult getAllStringElements] description];

            usdlFound = YES;
            break;
        }
    };

    // Collect other results

    if (!usdlFound) {
        for (PPRecognizerResult* result in results) {
            if ([result isKindOfClass:[PPZXingRecognizerResult class]]) {
                PPZXingRecognizerResult *zxingResult = (PPZXingRecognizerResult *)result;

                title = @"QR code";
                message = [zxingResult stringUsingGuessedEncoding];
            }
            if ([result isKindOfClass:[PPPdf417RecognizerResult class]]) {
                PPPdf417RecognizerResult *pdf417Result = (PPPdf417RecognizerResult *)result;

                title = @"PDF417";
                message = [pdf417Result stringUsingGuessedEncoding];
            }
            if ([result isKindOfClass:[PPBarDecoderRecognizerResult class]]) {
                PPBarDecoderRecognizerResult *barDecoderResult = (PPBarDecoderRecognizerResult *)result;

                title = @"BarDecoder";
                message = [barDecoderResult stringUsingGuessedEncoding];
            }
        };
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self dismissViewControllerAnimated:YES completion:nil];
                                                     }];

    [alertController addAction:okAction];

    [scanningViewController presentViewController:alertController animated:YES completion:nil];
}

@end
