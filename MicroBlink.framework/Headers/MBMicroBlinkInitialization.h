//
//  MBMicroBlinkInitialization.h
//  Pdf417Mobi
//
//  Created by Jura Skrlec on 30/01/2018.
//

#ifndef MBMicroBlinkInitialization_h
#define MBMicroBlinkInitialization_h

#define MB_INIT \
- (instancetype)init NS_UNAVAILABLE; \
- (instancetype)initWithError:(NSError **)error __attribute__((swift_error(nonnull_error))) NS_SWIFT_NAME(init()) NS_DESIGNATED_INITIALIZER; \


#endif /* MBMicroBlinkInitialization_h */
