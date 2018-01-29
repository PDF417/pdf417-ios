//
//  MBPdf417RecognizerResult.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 27/11/2017.
//

#import <Foundation/Foundation.h>

#import "PPMicroBlinkDefines.h"
#import "MBRecognizerResult.h"
#import "MBBarcodeResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognizer that can scan PDF417 2D barcodes.
 */
PP_CLASS_AVAILABLE_IOS(6.0)
@interface MBPdf417RecognizerResult : MBRecognizerResult<NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Byte array with result of the scan
 */
- (NSData *_Nullable)data;

/**
 * Retrieves string content of the scanned data using guessed encoding.
 *
 * If you're 100% sure you know the exact encoding in the barcode, use stringUsingEncoding: method.
 * Otherwise stringUsingDefaultEncoding.
 *
 * This method uses NSString stringEncodingForData:encodingOptions:convertedString:usedLossyConversion: method for
 * guessing the encoding.
 *
 *  @return created string, or nil if encoding couldn't be found.
 */
- (NSString *_Nullable)stringUsingGuessedEncoding;

/**
 * Retrieves string content of the scanned data using given encoding.
 *
 *  @param encoding The encoding for the returned string.
 *
 *  @return String created from data property, using given encoding
 */
- (NSString *_Nullable)stringUsingEncoding:(NSStringEncoding)encoding;

/**
 * Flag indicating uncertain scanning data
 * E.g obtained from damaged barcode.
 */
- (BOOL)isUncertain;

/**
 * Type of the barcode scanned
 *
 *  @return Type of the barcode
 */
@property(nonatomic, assign, readonly) MBBarcodeType barcodeType;

@end

NS_ASSUME_NONNULL_END

