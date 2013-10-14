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
#define PPScanningResultPdf417Name @"PDF417"
        PPScanningResultQrCode,
#define PPScanningResultQrCodeName @"QR Code"
        PPScanningResultLicenseInfo,
#define PPScanningResultLicenseInfoName @"License"
        PPScanningResultCode128,
#define PPScanningResultCode128Name @"Code 128"
        PPScanningResultCode39,
#define PPScanningResultCode39Name @"Code 39"
        PPScanningResultEAN13,
#define PPScanningResultEAN13Name @"EAN 13"
        PPScanningResultEAN8,
#define PPScanningResultEAN8Name @"EAN 8"
        PPScanningResultITF,
#define PPScanningResultITFName @"ITF"
        PPScanningResultUPCA,
#define PPScanningResultUPCAName @"UPCA"
        PPScanningResultUPCE,
#define PPScanningResultUPCEName @"UPCE"
        PPScanningResultNone
#define PPScanningResultNoneName @"Barcode"
};

typedef NS_ENUM(NSInteger, PPBarcodeElementType) {
    /** barcode element is of type text and can be interpreted as string*/
    PPTextElement,
    /** barcode element is arbitrary byte array */
    PPByteElement
};

/**
 * represents one raw element in barcode
 */
@interface PPBarcodeElement : NSObject

/** byte array contained in this barcode element */
@property (nonatomic, retain, readonly) NSData* elementBytes;
/** type of this element */
@property (nonatomic, assign, readonly) PPBarcodeElementType elementType;

- (id)initWithBytes:(NSData*)bytes type:(PPBarcodeElementType)type;

@end

/**
 * represents the collection of barcode raw elements
 */
@interface PPBarcodeDetailedData : NSObject

/** array of barcode elements (PPBarcodeElement*) contained in barcode */
@property (nonatomic, retain, readonly) NSArray* barcodeElements;

- (id)initWithElements:(NSArray*)barcodeElements;

/**
 * Use this method to get all barcode data in one byte array.
 * This is useful if you know how to interpret barcode data
 * and don't want to bother with all barcode elements.
 */
- (NSData*)getAllData;

@end

@interface PPScanningResult : NSObject

@property (nonatomic, assign, readonly) PPScanningResultType type;

@property (nonatomic, retain, readonly) NSData* data;

@property (nonatomic, retain, readonly) PPBarcodeDetailedData* rawData;

- (id)initWithData:(NSData*)data type:(PPScanningResultType)type rawData:(PPBarcodeDetailedData*)rawData;

- (id)initWithString:(NSString*)urlDataString type:(PPScanningResultType)type;

- (NSString*)toUrlDataString;

+ (NSString*)toTypeName:(PPScanningResultType)type;
+ (NSInteger)fromTypeName:(NSString*)typeName;

@end
