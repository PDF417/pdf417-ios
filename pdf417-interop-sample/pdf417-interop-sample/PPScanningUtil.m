//
//  PPScanningUtil.m
//  BarcodeFramework
//
//  Created by Marko Mihovilić on 10/3/13.
//  Copyright (c) 2013 PhotoPay. All rights reserved.
//

#import "PPScanningUtil.h"

@implementation PPScanningUtil

+ (BOOL)scanBarcodeTypes:(NSArray *)types
            withCallback:(NSString *)callback
                language:(NSString *)language
                    beep:(BOOL)beep
                   debug:(BOOL)debug
             frontCamera:(BOOL)frontCamera
{
    NSString* url = [NSString stringWithFormat:@"pdf417://scan?type=%@&language=%@&callback=%@&beep=%@&debug=%@&frontCamera=%@",
                     [[types componentsJoinedByString:@","] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     [language stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     [callback stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     beep ? @"true" : @"false",
                     debug ? @"true" : @"false",
                     frontCamera ? @"true" : @"false"];
    
    NSLog(@"invoking url '%@'", url);
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (NSDictionary*)parseUrlParameters:(NSURL*)url
{
    NSArray *components = [[url query] componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    for (NSString *component in components) {
        NSArray *subcomponents = [component componentsSeparatedByString:@"="];
        [parameters setObject:[[subcomponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                       forKey:[[subcomponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return parameters;
}

@end
