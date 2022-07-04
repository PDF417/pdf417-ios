//
//  MBLogger.h
//  PhotoMathFramework
//
//  Created by Marko Mihovilić on 23/03/16.
//  Copyright © 2016 Microblink Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBMicroblinkDefines.h"

typedef NS_ENUM(NSInteger, MBBLogLevel) {
    MBBLogLevelError,
    MBBLogLevelWarning,
    MBBLogLevelInfo,
    MBBLogLevelDebug,
    MBBLogLevelVerbose
};

@protocol MBBLoggerDelegate <NSObject>

@optional

- (void)log:(MBBLogLevel)level message:(const char *)message;
- (void)log:(MBBLogLevel)level format:(const char *)format arguments:(const char *)arguments;

@end

MB_CLASS_AVAILABLE_IOS(8.0) @interface MBBLogger : NSObject

@property (nonatomic) id<MBBLoggerDelegate> delegate;

+ (instancetype)sharedInstance NS_SWIFT_NAME(shared());

- (void)disableMicroblinkLogging;

@end
