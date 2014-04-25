//
//  PPScanningResult.h
//  BarcodeFramework
//
//  Created by Jurica Cerovec on 5/22/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPBaseResult.h"

#define PPScanningResultPdf417Name @"PDF417"
#define PPScanningResultQrCodeName @"QR Code"
#define PPScanningResultLicenseInfoName @"License"
#define PPScanningResultCode128Name @"Code 128"
#define PPScanningResultCode39Name @"Code 39"
#define PPScanningResultEAN13Name @"EAN 13"
#define PPScanningResultEAN8Name @"EAN 8"
#define PPScanningResultITFName @"ITF"
#define PPScanningResultUPCAName @"UPCA"
#define PPScanningResultUPCEName @"UPCE"
#define PPScanningResultAztecName @"Aztec"
#define PPScanningResultDataMatrixName @"Data Matrix"
#define PPScanningResultUSDLName @"USDL"
#define PPScanningResultNoneName @"Barcode"

/**
 Enumeration of all scanning result types
 */
typedef NS_ENUM(NSInteger, PPScanningResultType) {
    PPScanningResultPdf417,
    PPScanningResultQrCode,
    PPScanningResultLicenseInfo,
    PPScanningResultCode128,
    PPScanningResultCode39,
    PPScanningResultEAN13,
    PPScanningResultEAN8,
    PPScanningResultITF,
    PPScanningResultUPCA,
    PPScanningResultUPCE,
    PPScanningResultAztec,
    PPScanningResultDataMatrix,
    PPScanningResultNone
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

/**
 Designated initializer shich sets byte array for specific barcode element type
 */
- (id)initWithBytes:(NSData*)bytes
               type:(PPBarcodeElementType)type;

@end

/**
 * represents the collection of barcode raw elements
 */
@interface PPBarcodeDetailedData : NSObject

/** array of barcode elements (PPBarcodeElement*) contained in barcode */
@property (nonatomic, retain, readonly) NSArray* barcodeElements;

/**
 Designated initializer which sets all barcode elements
 */
- (id)initWithElements:(NSArray*)barcodeElements;

/**
 * Use this method to get all barcode data in one byte array.
 * This is useful if you know how to interpret barcode data
 * and don't want to bother with all barcode elements.
 */
- (NSData*)getAllData;

@end

/**
 Result of the scan
 */
@interface PPScanningResult : PPBaseResult

/**
 Type of the result
 */
@property (nonatomic, assign, readonly) PPScanningResultType type;

/**
 Byte array with result of the scan
 */
@property (nonatomic, retain, readonly) NSData* data;

/**
 Raw barcode detailed result
 */
@property (nonatomic, retain, readonly) PPBarcodeDetailedData* rawData;

/**
 Flag indicating uncertain scanning data
 E.g obtained from damaged barcode.
 */
@property (nonatomic, assign, readonly, getter = isUncertain) BOOL uncertain;

/**
 Designated initializer
 */
- (id)initWithData:(NSData*)data
              type:(PPScanningResultType)type
           rawData:(PPBarcodeDetailedData*)rawData
       isUncertain:(BOOL)isUncertain;

/**
 Initializer which deserializes the scanning result from url data string
 */
- (id)initWithString:(NSString*)urlDataString
                type:(PPScanningResultType)type;

/**
 Serializes the scanning result to url data string
 
 Returns hexadecimal string of NSData. Empty string if data is empty.
 */
- (NSString*)toUrlDataString;

/**
 Returns the string specifying the type name for a given enum type value
 */
+ (NSString*)toTypeName:(PPScanningResultType)type;

/**
 Returns the enum type value for a given type string
 */
+ (NSInteger)fromTypeName:(NSString*)typeName;

@end
