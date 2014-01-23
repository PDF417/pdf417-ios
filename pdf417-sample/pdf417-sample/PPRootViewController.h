//
//  PPRootViewController.h
//  PhotoPay
//
//  Created by Jurica Cerovec on 5/26/12.
//  Copyright (c) 2012 Racuni.hr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPRootViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIButton *startCustomUIButtom;
    
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)startPhotoPay:(id)sender;


- (IBAction)startCustomUIScan:(id)sender;

@end
