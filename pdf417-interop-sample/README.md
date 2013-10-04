## About

This is a sample IOS application that demonstrates how to interact with the **pdf417** scanner application from your own application to request scanning and retrieve barcode data.

By using this approach you do not need to integrate the **pdf417 SDK** into your application, you request scanning by invoking a scan URL recognized by the **pdf417** application and all the scanning and processing is handled for you. The results are passed back to your application via a similar URL schema that you have to implement to receive the data.

## Integration

To integrate your application you need to use the custom URL scheme recognized by the **pdf417** scanner.

> Most of the details explained here already get hadled by the utility code provided with the sample aplication. You are free to use this code in your own applications. How to use this code is explained in the section **Wrapper**.

### URL format

    pdf417://<action>?<parameters>

### Example

    pdf417://scan?type=PDF417,&beep=true&callback=myscheme://myaction

The above example request reading of only PDF417 barcodes, when the scanner scans a barcode the following URL will be invoked to return the result

    myscheme://myaction?data=<data>&type=PDF417

The above schema needs to be registered by your application to receive the result data.

## Reference

Here are all of the supported actions and parameters recognized by the library. All parameter values need to be properly URL encoded to be parsed correctly.

### Actons

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
+ **callback** - an url which will be called by **pdf417** to return controll back to your application
+ **beep** - optionally turns on or off the "beep" sound played when successfully scanning a barcode, can be set to `true` or `false` (default is `true`)

If the user cancels a scan, your callback URL will be invoked but without the `data` and `type` parameters.

### Callback

The format of the callback:

    <callback>?data=<data>&type=<type>

+ **callback** - the url you gave **pdf417** via the `callback` parameter above (for example `myschema://myaction`)
+ **data** - hex encoded byte data retrieved from the scanned barcode
+ **type** - the barcode type that was scanned, if you specified multiple supported barcodes it will tell you which one of theme was actually scanned

## Wrapper

The sample application is provided along with wrapper code which builds the scan request URL for you, you just need to provide the desired scan parameters without worrying about things like URL encoding.

The wrapper also parses the result data passed back to your application so you get the final barcode bytes without having to decode the hex encoded bytes.

Barcode datastructure is contained in the class defined in `PPScanningResult.h`. Wrapper functions are defined in `PPScanningUtil.h`.

### Initiate scanning

To initiate scanning call the `scanBarcodeTypes` wrapper function with your parameters:

    ```objective-c
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

To receive the resulting URL request you need to setup a URL scheme in your application settings (in our case `pdf417sample`) and implement the `handleOpenURL` method in your app delegate:

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
        PPScanningResult *result = [[PPScanningResult alloc] initWithString:parameters[@"data"] type:[PPScanningResult fromTypeName:parameters[@"type"]]];
    
        [self.viewController didRetrieveBarcodeResult:result];
    
        return YES;
    }
    ```