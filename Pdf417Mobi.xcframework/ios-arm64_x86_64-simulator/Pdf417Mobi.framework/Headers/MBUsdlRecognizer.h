//
//  MBUsdlRecognizer.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 03/01/2018.
//

#import "MBMicroblinkDefines.h"
#import "MBRecognizer.h"
#import "MBUsdlRecognizerResult.h"
#import "MBMicroblinkInitialization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognizer that can scan USDL.
 */
MB_CLASS_DEPRECATED_IOS(1.0, 7.0, "MBBUsdlRecognizer is deprecated in PDF417 SDK 7.0.0") MB_FINAL
@interface MBBUsdlRecognizer : MBBRecognizer<NSCopying>

MB_INIT

/**
 * USDL recognizer results
 */
@property (nonatomic, strong, readonly) MBBUsdlRecognizerResult *result;

/**
 * Set this to YES to scan even barcode not compliant with standards
 * For example, malformed USDL barcodes which were incorrectly encoded
 *
 * Use only if necessary because it slows down the recognition process
 *
 * Default: YES
 */
@property (nonatomic, assign) BOOL scanUncertain;

/**
 * Set this to YES to scan barcodes which don't have quiet zone (white area) around it
 *
 * Use only if necessary because it slows down the recognition process
 *
 * Default: YES
 */
@property (nonatomic, assign) BOOL allowNullQuietZone;

/**
 * Set this to YES to enable compact parser.
 *
 * Default: NO
 */
@property (nonatomic, assign) BOOL enableCompactParser;

@end

NS_ASSUME_NONNULL_END
