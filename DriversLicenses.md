# Driver's Licenses

This document is an addition to README document for pdf417 barcode scanning library. Here we explain how to obtain Driver's license information from the scanning results.

## Obtaining the result

By default, `cameraViewController:obtainedBaseResult:` callback returns result as a `PPBaseResult` object. When the `resultType` property of that object is `PPBaseResultTypeUSDL` the object is actually `PPUSDLResult`, which means it has Driver's License data stored. Here's a simple way to check if the data is USDL, and to get the USDLScanningResult object:

```objective-c
if ([result resultType] == PPBaseResultTypeUSDL && [result isKindOfClass:[PPUSDLResult class]]) {
	PPUSDLResult* usdlResult = (PPUSDLResult*)result;
	\\ additional processing
}
```

USDL data in the `PPUSDLResult` object are stored inside a `NSDictionary` called `fields`. From this Dictionary you can obtain specific fields using keys declared on top of the `PPUSDLResult.h` header file.

The value for a given key can be obtained the following way:

```objective-c
NSString* value = [[usdlResult fields] objectForKey:key]
```
	
The [DriversLicenseKeys](DriversLicenseKeys.md) document lists all fields that can be obtained from the `PPUSDLResult` object. If pdf417 USDL library didn't recognize a fields value for given key, you will receive `nil` value.
	
## Code Example

```objective-c
- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController
            didOutputResults:(NSArray *)results {
    
    for (PPBaseResult* result in results) {
        if ([result resultType] == PPBaseResultTypeUSDL && [result isKindOfClass:[PPUSDLResult class]]) {
            PPUSDLResult* usdlResult = (PPUSDLResult*)result;
            [self processUSDLResult:usdlResult cameraViewController:cameraViewController];
        }
    };
}

- (void)processUSDLResult:(PPUSDLResult*)result
     cameraViewController:(id<PPScanningViewController>)cameraViewController {

    [cameraViewController pauseScanning];

    NSString *message = [[result fields] description];
    NSString* title = @"USDL";

    BlockAlertView *alert = [BlockAlertView alertWithTitle:title message:message];

    [alert setCancelButtonWithTitle:@"Cancel" block:^{
        [cameraViewController resumeScanning];
    }];

    [alert addButtonWithTitle:@"Copy text" block:^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = message;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [alert show];
}
```