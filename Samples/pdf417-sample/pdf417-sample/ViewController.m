//
//  ViewController.m
//  pdf417-sample
//
//  Created by Jura on 16/07/15.
//  Copyright (c) 2015 MicroBlink. All rights reserved.
//

#import "ViewController.h"

#import <MicroBlink/MicroBlink.h>

@interface ViewController () <MBBarcodeOverlayViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) MBBarcodeRecognizer *barcodeRecognizer;
@property (nonatomic, strong) MBPdf417Recognizer *pdf417Recognizer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** First, set license key as soon as possible */
    [[MBMicroblinkSDK sharedInstance] setLicenseResource:@"license-pdf" withExtension:@"txt" inSubdirectory:@"License" forBundle:[NSBundle mainBundle]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTapScan:(id)sender {
    
     /** Create recognizers */
    self.barcodeRecognizer = [[MBBarcodeRecognizer alloc] init];
    self.barcodeRecognizer.scanQR = YES;
    
    self.pdf417Recognizer = [[MBPdf417Recognizer alloc] init];
    
    MBBarcodeOverlaySettings* settings = [[MBBarcodeOverlaySettings alloc] init];
    
    NSMutableArray<MBRecognizer *> *recognizers = [[NSMutableArray alloc] init];

    [recognizers addObject:self.barcodeRecognizer];
    [recognizers addObject:self.pdf417Recognizer];
    
    /** Create recognizer collection */
    settings.uiSettings.recognizerCollection = [[MBRecognizerCollection alloc] initWithRecognizers:recognizers];
    
    MBBarcodeOverlayViewController *overlayVC = [[MBBarcodeOverlayViewController alloc] initWithSettings:settings andDelegate:self];
    UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];
    
    /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
}

#pragma mark - MBBarcodeOverlayViewControllerDelegate

- (void)overlayViewControllerDidFinishScanning:(MBBarcodeOverlayViewController *)barcodeOverlayViewController state:(MBRecognizerResultState)state {
    /** This is done on background thread*/
    [barcodeOverlayViewController.recognizerRunnerViewController pauseScanning];
    
    NSString* message;
    NSString* title;
    
    if (self.barcodeRecognizer.result.resultState == MBRecognizerResultStateValid) {
        title = @"QR code";
        
        // Save the string representation of the code
        message = [self.barcodeRecognizer.result stringUsingGuessedEncoding];
    }
    else if (self.pdf417Recognizer.result.resultState == MBRecognizerResultStateValid) {
        title = @"PDF417";
        
        // Save the string representation of the code
        message = [self.pdf417Recognizer.result stringUsingGuessedEncoding];
    }
    
    /** Needs to be called on main thread beacuse everything prior is on background thread */
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                         }];
        
        [alertController addAction:okAction];
        
        [barcodeOverlayViewController presentViewController:alertController animated:YES completion:nil];
    });
    
}

- (void)overlayViewControllerDidTapClose:(MBBarcodeOverlayViewController *)barcodeOverlayViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
