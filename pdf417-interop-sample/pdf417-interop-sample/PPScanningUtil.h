//
//  PPScanningUtil.h
//  BarcodeFramework
//
//  Created by Marko Mihovilić on 10/3/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPScanningUtil : NSObject

+ (BOOL)scanBarcodeTypes:(NSArray*)types
            withCallback:(NSString*)callback
                language:(NSString*)language
                    beep:(BOOL)beep
                   debug:(BOOL)debug
             frontCamera:(BOOL)frontCamera;

+ (NSDictionary*)parseUrlParameters:(NSURL*)url;

@end
