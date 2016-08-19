//
//  RootViewController.m
//  DirectAPI-Sample
//
//  Created by Jura on 09/08/15.
//  Copyright © 2015 MicroBlink. All rights reserved.
//

#import "RootViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <MicroBlink/MicroBlink.h>

@interface RootViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, PPCoordinatorDelegate>

@property (nonatomic) PPCoordinator *coordinator;

@end

@implementation RootViewController

static NSString* rawOcrParserId = @"RawOcrParser";

- (IBAction)openImagePicker:(id)sender {

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;

    // Displays a control that allows the user to choose only photos
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];

    // Hides the controls for moving & scaling pictures, or for trimming movies.
    imagePicker.allowsEditing = NO;

    // Shows default camera control overlay over camera preview.
    imagePicker.showsCameraControls = YES;

    // set delegate
    imagePicker.delegate = self;

    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    // Handle a still image capture
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage *originalImage = (UIImage *)[info objectForKey: UIImagePickerControllerOriginalImage];
        
        if (self.coordinator == nil) {
            [self createCoordinator];
        }
        PPImage *image = [PPImage imageWithUIImage:originalImage];
        image.cameraFrame = YES;
        image.orientation = PPProcessingOrientationLeft;
        dispatch_queue_t _serialQueue = dispatch_queue_create("com.microblink.DirectAPI-sample", DISPATCH_QUEUE_SERIAL);
        dispatch_async(_serialQueue, ^{
            [self.coordinator processImage:image];
        });
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)createCoordinator {
    
    
    
    /** 1. Initialize the Scanning settings */
    
    // Initialize the scanner settings object. This initialize settings with all default values.
    PPSettings *settings = [[PPSettings alloc] init];
    
    
    /** 2. Setup the license key */
    
    // Visit www.microblink.com to get the license key for your app
    settings.licenseSettings.licenseKey = @"6537LXHK-VXAF2N7N-FPZLQ6SK-75GY7QRL-7KEZVMHU-VXCVGSF3-6HSZ5LUP-YIV2XRKR";
    
    
    /**
     * 3. Set up what is being scanned. See detailed guides for specific use cases.
     * Here's an example for initializing raw OCR scanning.
     */
    
    // To specify we want to perform PDF417 recognition, initialize the PDF417 recognizer settings
    PPPdf417RecognizerSettings *pdf417RecognizerSettings = [[PPPdf417RecognizerSettings alloc] init];
    
    /** You can modify the properties of pdf417RecognizerSettings to suit your use-case */
    
    // Add PDF417 Recognizer setting to a list of used recognizer settings
    [settings.scanSettings addRecognizerSettings:pdf417RecognizerSettings];
    
    /** 4. Initialize the Scanning Coordinator object */
    
    PPCoordinator *coordinator = [[PPCoordinator alloc] initWithSettings:settings delegate:self];
    
    self.coordinator = coordinator;
}

- (void)coordinator:(PPCoordinator *)coordinator didOutputResults:(NSArray<PPRecognizerResult *> *)results {
    // Here you process scanning results. Scanning results are given in the array of PPRecognizerResult objects.
    
    
    // Collect data from the result
    for (PPRecognizerResult* result in results) {
        
        if ([result isKindOfClass:[PPPdf417RecognizerResult class]]) {
            /** Pdf417 code was detected */
            
            PPPdf417RecognizerResult *pdf417Result = (PPPdf417RecognizerResult *)result;
            
            NSString *title = @"PDF417";
            
            // Save the string representation of the code
            NSString *message = [pdf417Result stringUsingGuessedEncoding];
            
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
    };
    
}

@end
