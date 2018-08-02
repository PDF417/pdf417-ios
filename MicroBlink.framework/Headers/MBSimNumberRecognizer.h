//
//  MBSimNumberRecognizer.h
//  MicroBlinkDev
//
//  Created by Jura Skrlec on 21/11/2017.
//

#import <Foundation/Foundation.h>
#import "MBMicroBlinkDefines.h"
#import "MBRecognizer.h"
#import "MBSimNumberRecognizerResult.h"
#import "MBMicroBlinkInitialization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Recognizer that can perform recognition of barcodes on SIM packaging.
 */
PP_CLASS_DEPRECATED_IOS(1.0, 7.0, "MBSimNumberRecognizer is deprecated in PDF417 SDK 7.0.0") MB_FINAL
@interface MBSimNumberRecognizer : MBRecognizer<NSCopying>

MB_INIT

/**
 * Sim number recognizer results
 */
@property (nonatomic, strong, readonly) MBSimNumberRecognizerResult *result;

@end

NS_ASSUME_NONNULL_END
