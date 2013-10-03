//
//  PPAppDelegate.h
//  pdf417-interop-sample
//
//  Created by Marko Mihovilić on 10/2/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPViewController.h"

@interface PPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PPViewController *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
