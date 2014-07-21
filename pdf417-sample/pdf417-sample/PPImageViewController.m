//
//  PPImageViewController.m
//  pdf417-sample
//
//  Created by Jura on 21/07/14.
//  Copyright (c) 2014 PhotoPay. All rights reserved.
//

#import "PPImageViewController.h"

@interface PPImageViewController ()

@end

@implementation PPImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Image";

    self.imageView.image = self.image;
}

@end
