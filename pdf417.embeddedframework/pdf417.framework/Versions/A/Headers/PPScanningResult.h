//
//  PPScanningResult.h
//  BarcodeFramework
//
//  Created by Jurica Cerovec on 5/22/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PPScanningResultType) {
    PPScanningResultPdf417,
    PPScanningResultQrCode,
    PPScanningResultLicenseInfo,
    PPScanningResultNone
};

@interface PPScanningResult : NSObject

@property (nonatomic, assign, readonly) PPScanningResultType type;

@property (nonatomic, retain, readonly) NSData* data;

- (id)initWithData:(NSData*)data type:(PPScanningResultType)type;

@end
