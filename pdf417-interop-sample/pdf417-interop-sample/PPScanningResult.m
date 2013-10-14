//
//  PPScanningResult.m
//  BarcodeFramework
//
//  Created by Jurica Cerovec on 5/22/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import "PPScanningResult.h"

@implementation PPBarcodeElement

@synthesize elementBytes = elementBytes_;
@synthesize elementType = elementType_;

- (id)initWithBytes:(NSData *)bytes type:(PPBarcodeElementType)type {
    self = [super init];
    if(self) {
        elementBytes_ = bytes;
        elementType_ = type;
    }
    return self;
}

@end

@interface PPBarcodeDetailedData () {
    NSData* allData_;
}
@end

@implementation PPBarcodeDetailedData

@synthesize barcodeElements = elements_;

- (id)initWithElements:(NSArray *)barcodeElements {
    self = [super init];
    if (self) {
        elements_ = barcodeElements;
        allData_ = nil;
    }
    return self;
}

- (NSData*)getAllData {
    if (allData_ == nil) {
        NSMutableData* allData = [[NSMutableData alloc] init];
        for (PPBarcodeElement* bel in elements_) {
            NSData* elData = [bel elementBytes];
            [allData appendData:elData];
        }
        allData_ = allData;
    }
    return allData_;
}

@end

@implementation PPScanningResult

@synthesize data;
@synthesize type;
@synthesize rawData = rawData_;

- (id)initWithData:(NSData*)inData type:(PPScanningResultType)inType rawData:(PPBarcodeDetailedData *)rawData {
    self = [super init];
    if (self) {
        type = inType;
        data = inData;
        rawData_ = rawData;
    }
    return self;
}

- (id)initWithString:(NSString*)urlDataString type:(PPScanningResultType)inType {
    self = [super init];
    if (self) {
        type = inType;
        
        NSMutableData* mutableData = [NSMutableData alloc];
   
        for(unsigned int location = 0; location<[urlDataString length]-1; location += 2) {
            NSString *subString = [urlDataString substringWithRange:NSMakeRange(location, 2)];
            NSScanner *scanner = [NSScanner scannerWithString:subString];
            unsigned int buffer;
            [scanner scanHexInt:&buffer];
            unsigned char byte = buffer;
            [mutableData appendBytes:&byte length:sizeof(byte)];
        }
        
        data = mutableData;
    }
    return self;
}

+ (NSString*)toTypeName:(PPScanningResultType)type {
    NSString* title;
    
    switch (type) {
        case PPScanningResultPdf417:
            title = PPScanningResultPdf417Name;
            break;
        case PPScanningResultQrCode:
            title = PPScanningResultQrCodeName;
            break;
        case PPScanningResultLicenseInfo:
            title = PPScanningResultLicenseInfoName;
            break;
        case PPScanningResultCode128:
            title = PPScanningResultCode128Name;
            break;
        case PPScanningResultCode39:
            title = PPScanningResultCode39Name;
            break;
        case PPScanningResultEAN13:
            title = PPScanningResultEAN13Name;
            break;
        case PPScanningResultEAN8:
            title = PPScanningResultEAN8Name;
            break;
        case PPScanningResultITF:
            title = PPScanningResultITFName;
            break;
        case PPScanningResultUPCA:
            title = PPScanningResultUPCAName;
            break;
        case PPScanningResultUPCE:
            title = PPScanningResultUPCEName;
            break;
        default:
            title = PPScanningResultNoneName;
            break;
    }
    
    return title;
}

+ (NSInteger)fromTypeName:(NSString *)typeName {
    if ([typeName isEqualToString:PPScanningResultPdf417Name]) {
        return PPScanningResultPdf417;
    }
    if ([typeName isEqualToString:PPScanningResultQrCodeName]) {
        return PPScanningResultQrCode;
    }
    if ([typeName isEqualToString:PPScanningResultLicenseInfoName]) {
        return PPScanningResultLicenseInfo;
    }
    if ([typeName isEqualToString:PPScanningResultCode128Name]) {
        return PPScanningResultCode128;
    }
    if ([typeName isEqualToString:PPScanningResultCode39Name]) {
        return PPScanningResultCode39;
    }
    if ([typeName isEqualToString:PPScanningResultEAN13Name]) {
        return PPScanningResultEAN13;
    }
    if ([typeName isEqualToString:PPScanningResultEAN8Name]) {
        return PPScanningResultEAN8;
    }
    if ([typeName isEqualToString:PPScanningResultITFName]) {
        return PPScanningResultITF;
    }
    if ([typeName isEqualToString:PPScanningResultUPCAName]) {
        return PPScanningResultUPCA;
    }
    if ([typeName isEqualToString:PPScanningResultUPCEName]) {
        return PPScanningResultUPCE;
    }
    
    return PPScanningResultNone;
}

- (NSString*)toUrlDataString
{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self.data bytes];
    
    if (!dataBuffer) {
        return [NSString string];
    }
    
    NSUInteger dataLength  = [self.data length];
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (NSUInteger i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

@end
