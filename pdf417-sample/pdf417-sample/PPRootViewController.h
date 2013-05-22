//
//  PPRootViewController.h
//  PhotoPay
//
//  Created by Jurica Cerovec on 5/26/12.
//  Copyright (c) 2012 Racuni.hr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPRootViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)startPhotoPay:(id)sender;

@end
