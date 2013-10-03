//
//  PPViewController.h
//  pdf417-interop-sample
//
//  Created by Marko Mihovilić on 10/2/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPScanningResult.h"

@interface PPViewController : UIViewController

- (IBAction)didClickSend:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

// gets called by app delegate when we receive data from the scanner via our callback url scheme
- (void)didRetrieveBarcodeResult:(PPScanningResult*)result;

@end
