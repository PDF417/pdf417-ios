## Transition to 4.1.1

- No backwards incompatible changes.

## Transition to 4.1.0

- No backwards incompatible changes. See Release notes for new features.

## Transition to 4.0.2

- No backwards incompatible changes.

## Transition to 4.0.1

- No backwards incompatible changes.

## Transition to 4.0.0

- This version uses a new license key format. If you had a license key generated prior to v4.0.0 contact us so we can regenerate the license key for you.

- Framework was renamed to **MicroBlink.embeddedframework**. Remove the existing .embeddedframework package from your project, and drag&drop **MicroBlink.embeddedframework** in the project explored of your Xcode project.

- If necessary, after the update, modify your framework search path so that it points to the **MicroBlink.embeddedframework** folder.

- Main header of the framework was renamed to `<MicroBlink/Microblink.h>`. Change all references to previous header with the new one.

- `PPBarcodeCoordinator` class was renamed to `PPCoordinator`

- Classes representing scanning results were renamed. Renaming was performed to match naming convention of `PPRecognizerSettings` hierarcy: now each `PPRecognizerSettings` class has it's matching `PPRecognizerResult`. Replace all existing references to old class names with the new ones:

    - `PPBaseResult` was renamed to `PPRecognizerResult`. 
    	
    - `PPScanningResult` was restructured and refactored into four classes, one for each recognizer used in the SDK
    
        `PPPdf417RecognizerResult` which holds the results of PDF417 scanning
        
        `PPBarDecoderRecognizerResult` which holds the results of BarDecoder scanning
        
        `PPUsdlRecognizerResult` which holds the results of USDL scanning
        
        `PPZXingRecognizerResult` which holds the results of ZXing scanning
        
    - `PPScanningResult` had getters for `data`, `rawData`, `uncertain` and `type` properties. Each new class has equivalent `data`, `rawData` and `uncertain` properties. New classes (except PDF417 and USDL) have `barcodeType` property with the same function. PDF417 and USDL classes don't have type since they are always obtained by scanning PFDF417 barcode.

    - For easier integration new classes have new getters `stringUsingGuessedEncoding` which guesses the encoding string inside barcode data. Use this if you know data is textual, but you don't know the exact encoding of the string. 
    	
- `PPScanningViewController`'s methods `resumeScanning` and `resumeScanningWithoutStateReset` merged into one `resumeScanningAndResetState:`. 

        - All calls to `resumeScanning` replace with `resumeScanningAndResetState:YES`.
        - All calls to `resumeScanningWithoutStateReset` replace with `resumeScanningAndResetState:NO`

- Remove all references to `updateScanningRegion` method since it's now being called automatically in `setScanningRegion` setter.