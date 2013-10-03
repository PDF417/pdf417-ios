//
//  PPViewController.m
//  pdf417-interop-sample
//
//  Created by Marko Mihovilić on 10/2/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import "PPViewController.h"

#import "PPScanningResult.h"
#import "PPScanningUtil.h"

@implementation PPViewController

- (void)didRetrieveBarcodeResult:(PPScanningResult*)result
{
    if (!result) {
        self.titleView.text = @"nothing scanned";
        self.labelView.text = nil;
        
        return;
    }
    
    self.titleView.text = [PPScanningResult toTypeName:result.type];
    
    // show the retrieved data as text in the ui
    self.labelView.text = [[NSString alloc] initWithData:result.data encoding:NSUTF8StringEncoding];
}

- (IBAction)didClickSend:(id)sender
{
    NSMutableArray *types = [[NSMutableArray alloc] init];
    
    // add all the barcode types that we want to support in the scan
    [types addObject:PPScanningResultPdf417Name];
    [types addObject:PPScanningResultQrCodeName];
    
    if (![PPScanningUtil scanBarcodeTypes:types withCallback:@"pdf417sample://callback" andLanguage:@"en"]) {
        [[[UIAlertView alloc] initWithTitle:@"Not installed."
                                    message:@"You need to install the pdf417 scanner application for this feature to work."
                                   delegate:nil
                          cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

@end
