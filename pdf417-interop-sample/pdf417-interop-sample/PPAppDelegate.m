//
//  PPAppDelegate.m
//  pdf417-interop-sample
//
//  Created by Marko Mihovilić on 10/2/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import "PPAppDelegate.h"

#import "PPScanningUtil.h"
#import "PPScanningResult.h"

@implementation PPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.viewController = [[PPViewController alloc] initWithNibName:@"PPView" bundle:nil];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSDictionary* parameters = [PPScanningUtil parseUrlParameters:url];
    
    PPScanningResult *result = [[PPScanningResult alloc] initWithString:parameters[@"data"] type:[PPScanningResult fromTypeName:parameters[@"type"]]];
    
    [self.viewController didRetrieveBarcodeResult:result];
    
    return YES;
}

@end
