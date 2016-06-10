//
//  ViewController.m
//  NoCamera-sample
//
//  Created by Jura on 28/04/15.
//  Copyright (c) 2015 MicroBlink. All rights reserved.
//

#import "ViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <MicroBlink/MicroBlink.h>

@interface ViewController () <PPScanDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) PPCoordinator *coordinator;

@property (nonatomic, strong) NSString* rawOcrParserId;

@property (nonatomic, strong) NSString* priceParserId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.rawOcrParserId = @"Raw ocr";
    self.priceParserId = @"Price";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Method allocates and initializes the Scanning coordinator object.
 * Coordinator is initialized with settings for scanning
 * Modify this method to include only those recognizer settings you need. This will give you optimal performance
 *
 *  @param error Error object, if scanning isn't supported
 *
 *  @return initialized coordinator
 */
- (PPCoordinator *)coordinatorWithError:(NSError**)error {

    /** 0. Check if scanning is supported */

    if ([PPCoordinator isScanningUnsupportedForCameraType:PPCameraTypeBack error:error]) {
        return nil;
    }


    /** 1. Initialize the Scanning settings */

    // Initialize the scanner settings object. This initialize settings with all default values.
    PPSettings *settings = [[PPSettings alloc] init];


    /** 2. Setup the license key */

    // Visit www.microblink.com to get the license key for your app
    settings.licenseSettings.licenseKey = @"DXFHVF63-2EZAAVV2-NAJOFHW3-3EOFI2A2-JZ3464FH-CGIX6UTN-5IIORHED-WDMU3X5T";


    /**
     * 3. Set up what is being scanned. See detailed guides for specific use cases.
     * Remove undesired recognizers (added below) for optimal performance.
     */

    
    {// Remove this code if you don't need to scan Pdf417
        // To specify we want to perform PDF417 recognition, initialize the PDF417 recognizer settings
        PPPdf417RecognizerSettings *pdf417RecognizerSettings = [[PPPdf417RecognizerSettings alloc] init];
        
        /** You can modify the properties of pdf417RecognizerSettings to suit your use-case */
        
        // Add PDF417 Recognizer setting to a list of used recognizer settings
        [settings.scanSettings addRecognizerSettings:pdf417RecognizerSettings];
    }
    
    {// Remove this code if you don't need to scan QR codes
        // To specify we want to perform recognition of other barcode formats, initialize the ZXing recognizer settings
        PPZXingRecognizerSettings *zxingRecognizerSettings = [[PPZXingRecognizerSettings alloc] init];
        
        /** You can modify the properties of zxingRecognizerSettings to suit your use-case (i.e. add other types of barcodes like QR, Aztec or EAN)*/
        zxingRecognizerSettings.scanQR = YES; // we use just QR code
        
        
        // Add ZXingRecognizer setting to a list of used recognizer settings
        [settings.scanSettings addRecognizerSettings:zxingRecognizerSettings];
    }
    
    {// Remove this code if you don't need to scan US drivers licenses
        // To specify we want to scan USDLs, initialize USDL rcognizer settings
        PPUsdlRecognizerSettings *usdlRecognizerSettings = [[PPUsdlRecognizerSettings alloc] init];
        
        /** You can modify the properties of usdlRecognizerSettings to suit your use-case */
        
        // Add USDL Recognizer setting to a list of used recognizer settings
        [settings.scanSettings addRecognizerSettings:usdlRecognizerSettings];
    }

    /** 4. Initialize the Scanning Coordinator object */

    PPCoordinator *coordinator = [[PPCoordinator alloc] initWithSettings:settings];
    
    return coordinator;
}

- (IBAction)takePhoto:(id)sender {
    NSLog(@"Take photo!");

    /** Instantiate the scanning coordinator */
    NSError *error;
    self.coordinator = [self coordinatorWithError:&error];

    /** If scanning isn't supported, present an error */
    if (self.coordinator == nil) {
        NSString *messageString = [error localizedDescription];
        [[[UIAlertView alloc] initWithTitle:@"Warning"
                                    message:messageString
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];

        return;
    }

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];

    // Use rear camera
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;

    // Displays a control that allows the user to choose only photos
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];

    // Hides the controls for moving & scaling pictures, or for trimming movies.
    cameraUI.allowsEditing = NO;

    // Shows default camera control overlay over camera preview.
    cameraUI.showsCameraControls = YES;

    // set delegate
    cameraUI.delegate = self;

    // Show view
    [self presentViewController:cameraUI animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];

    // Handle a still image capture
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage *originalImage = (UIImage *)[info objectForKey: UIImagePickerControllerOriginalImage];

        // Process the selected image
        [self.coordinator processImage:originalImage
                        scanningRegion:CGRectMake(0.0, 0.0, 1.0, 1.0)
                              delegate:self];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PPScanDelegate

- (void)scanningViewControllerUnauthorizedCamera:(UIViewController<PPScanningViewController>*)scanningViewController {
    // When using direct processing, this can never happen as no camera session is started inside the SDK
}

- (void)scanningViewController:(UIViewController<PPScanningViewController>*)scanningViewController
                  didFindError:(NSError*)error {
    // can be ignored
}

- (void)scanningViewControllerDidClose:(UIViewController<PPScanningViewController>*)scanningViewController {
    // When using direct processing, this can never happen as no scanning view controller is presented
}

- (void)scanningViewController:(UIViewController<PPScanningViewController> *)scanningViewController
              didOutputResults:(NSArray *)results {
    
    /**
     * Here you process scanning results. Scanning results are given in the array of PPRecognizerResult objects.
     * Each member of results array will represent one result for a single processed image
     * Usually there will be only one result. Multiple results are possible when there are 2 or more detected objects on a single image (i.e. pdf417 and QR code side by side)
     */
    
    // If results are empty, continue scanning without any actions
    if (results == nil || [results count] == 0) {
        return;
    }
    
    // first, pause scanning until we process all the results
    [scanningViewController pauseScanning];
    
    NSString* message;
    NSString* title;
    
    // In this sample we prefer finding USDL results
    
    BOOL usdlFound = false;
    
    // Collect data from the result
    for (PPRecognizerResult* result in results) {
        
        if ([result isKindOfClass:[PPUsdlRecognizerResult class]]) {
            /** US drivers license was detected */
            
            PPUsdlRecognizerResult *usdlResult = (PPUsdlRecognizerResult *)result;
            
            title = @"USDL";
            
            // Get all USDL data as NSDictionary and save it in NSString form
            message = [[usdlResult getAllStringElements] description];
            
            usdlFound = YES;
            break;
        }
    };
    
    // Collect other results
    if (!usdlFound) {
        for (PPRecognizerResult* result in results) {
            if ([result isKindOfClass:[PPZXingRecognizerResult class]]) {
                /** One of ZXing codes was detected */
                
                PPZXingRecognizerResult *zxingResult = (PPZXingRecognizerResult *)result;
                
                title = @"QR code";
                
                // Save the string representation of the code
                message = [zxingResult stringUsingGuessedEncoding];
            }
            if ([result isKindOfClass:[PPPdf417RecognizerResult class]]) {
                /** Pdf417 code was detected */
                
                PPPdf417RecognizerResult *pdf417Result = (PPPdf417RecognizerResult *)result;
                
                title = @"PDF417";
                
                // Save the string representation of the code
                message = [pdf417Result stringUsingGuessedEncoding];
            }
            if ([result isKindOfClass:[PPBarDecoderRecognizerResult class]]) {
                /** One of BarDecoder codes was detected */
                
                PPBarDecoderRecognizerResult *barDecoderResult = (PPBarDecoderRecognizerResult *)result;
                
                title = @"BarDecoder";
                
                // Save the string representation of the code
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
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
