## About

This is a sample IOS application that demonstrates how to interact with the **pdf417** scanner application from your own application to request scanning and retrieve barcode data.

> You can use SDK and build your own scanner app, or use PDF417.mobi PRO app found in App Store https://itunes.apple.com/us/app/pdf417-pro-barcode-scanner/id901413059?mt=8.

By using this approach you do not need to integrate the **pdf417 SDK** into your application, you request scanning by invoking a scan URL recognized by the **pdf417** application and all the scanning and processing is handled for you. The results are passed back to your application via a similar URL schema that you have to implement to receive the data.

## Integration

To integrate your application you need to use the custom URL scheme recognized by the **pdf417** scanner.

> Most of the details explained here already get hadled by the utility code provided with the sample aplication. You are free to use this code in your own applications. How to use this code is explained in the section **Wrapper**.

### URL format

    pdf417://<action>?<parameters>

### Example

    pdf417://scan?type=PDF417,UPCA&beep=true&callback=myscheme://myaction

The above example request reading of PDF417 and UPCA barcodes, when the scanner scans a barcode the following URL will be invoked to return the result

    myscheme://myaction?data=<data>&type=<type>

The above schema needs to be registered by your application to receive the result data. The `<data>` parameter will contain the barcode data while the `<type>` parameter will contain either `PDF417` or `UPCA` depending on which of the two barcodes was scanned.

## Reference

Here are all of the supported actions and parameters recognized by the library. All parameter values need to be properly URL encoded to be parsed correctly.

### Actions

Supported actions by the url scheme:

+ **scan** - the only supported action is to initiate a single barcode scan which opens the **pdf417** application in camera mode, ready to recognise a barcode

### Parameters

Supported parameters by the url scheme:

+ **type** - comma seperated list of barcode types you want the scanner to scan for, the supported are:
    + PDF417
    + QR Code
    + Code 128
    + Code 39
    + EAN 13
    + EAN 8
    + ITF
    + UPCA
    + UPCE
+ **callback** - an url which will be called by **pdf417** to return controll back to your application, must be specified
+ **beep** - optionally turns on or off the "beep" sound played when successfully scanning a barcode, can be set to `true` or `false` (default is `true`)
+ **frontCamera** - optionally uses front facing camera of the device for scanning (default is `false`)
+ **debug** - optionally raises the AlertView with debug data in pdf417-pro app, instead of invoking a callback. This is useful for debugging callbacks (default is `false`)
+ **text** - boolean value (default is `false`) that optionally allows requesting that the barcode data be interpreted as a UTF8 string and returned as a URL-Encoded UTF8 string instead of Hex-Encoded. To be used when the calling application cannot handle other types of data (like for example when integrating from **Filemaker Pro**)
+ **fmp** - boolean value (default is `false`) optionally telling the application to return result data in a parameter called `param` instead of the usual `data` parameter (to be used when integrating from **Filemaker Pro** which specifically expects the `param` parameter)

If the user cancels a scan, your callback URL will be invoked but without the `data` and `type` parameters.

### Callback

The format of the callback:

    <callback>?data=<data>&type=<type>

+ **callback** - the url you gave **pdf417** via the `callback` parameter above (for example `myschema://myaction`)
+ **type** - the barcode type that was scanned, if you specified multiple supported barcodes it will tell you which one of theme was actually scanned
+ **data** - Hex-Encoded byte data retrieved from the scanned barcode (or a URL-Encoded UTF8 string if the `text` parameter is set to `true`)

> The result data is by default Hex-Encoded which means every two characters of the result string represent one byte of data. This is because the barcode data in its raw form does not have any universal notion of data format and it is up to the client aplication to interpret this data in the way it sees fit depending on its use-case. For your convenience, we provide an option to tell the **pdf417** scanner application to interpret the data as a UTF8 string for you, and return the interpreted string as a result. In this case you just need to make sure that the barcodes you'll be scanning contain actuall UTF8 encoded string data, otherwise you might run into problems with the (incorrect) decoded data. Keep this in mind.

## Wrapper

The sample application is provided along with wrapper code which builds the scan request URL for you, you just need to provide the desired scan parameters without worrying about things like URL encoding.

The wrapper also parses the result data passed back to your application so you get the final barcode bytes without having to decode the hex encoded bytes.

The barcode datastructure is contained in the class defined in `PPScanningResult.h`. Wrapper functions are defined in `PPScanningUtil.h`.

### Initiate scanning

To initiate scanning call the `scanBarcodeTypes` wrapper function with your parameters:

``` objective-c
NSMutableArray *types = [[NSMutableArray alloc] init];

// add all the barcode types that we want to support in the scan
[types addObject:PPScanningResultPdf417Name];
[types addObject:PPScanningResultQrCodeName];

if (![PPScanningUtil scanBarcodeTypes:types
	withCallback:@"pdf417sample://callback" andLanguage:@"en" andBeep:YES]) {
	// Here you can show an alert view telling the user that he needs to install
	// the pdf417 scanner application to enable barcode scanning
}
```

### Getting the result

To receive the resulting URL request you need to [setup a URL scheme in your application](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/AdvancedAppTricks/AdvancedAppTricks.html#//apple_ref/doc/uid/TP40007072-CH7-SW50) (in our case `pdf417sample`) and implement the `handleOpenURL` method in your app delegate:

```objective-c
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // parse the url into parameters
    NSDictionary* parameters = [PPScanningUtil parseUrlParameters:url];

    if (!parameters[@"data"]) {
        // no data was received, show empty screen
        [self.viewController didRetrieveBarcodeResult:nil];
        return YES;
    }

    // parse the result into a PPScanningResult structure
    PPScanningResult *result = [[PPScanningResult alloc] initWithString:parameters[@"data"] 
                                                                   type:[PPScanningResult 
                                                           fromTypeName:parameters[@"type"]]];

    [self.viewController didRetrieveBarcodeResult:result];

    return YES;
}
```
