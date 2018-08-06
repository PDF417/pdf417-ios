## Transition to 7.1.0

- removed `uiSettings` property from `MBBarcodeOverlaySettings` and it no longer has `recognizerCollection` property
- `MBBarcodeOverlayViewController` has new `init` which has `(MBRecognizerCollection *)recognizerCollection` as parameter and `andDelegate` parameter has been renamed to `delegate`
- `MBOverlayViewControllerInterface` has been removed; when creating custom overlay view controller, `MBCustomOverlayViewController` has to be inherited
    - please check our updated Samples
- `MBBarcodeOverlayViewControllerDelegate` methods has been renamed to `barcodeOverlayViewControllerDidFinishScanning` and `barcodeOverlayViewControllerDidTapClose`

## Transition to 7.0.0

- New API, which is not backward compatible. Please check [README](README.md) and updated demo applications for more information.

## Transition to 5.1.2

- `PPBarDecoderRecognizerResult` and `PPBarDecoderRecognizerSettings` are now deprecated. Use `PPBarcodeRecognizerResult` and `PPBarcodeRecognizerSettings`
- `PPZXingRecognizerResult` and `PPZXingRecognizerSettings` are now deprecated. Use `PPBarcodeRecognizerResult` and `PPBarcodeRecognizerSettings`
- There is no more option in PPUsdlRecognizerSettings to scan 1D barcodes. Previously this setting did nothing - it's OK to just delete the setter call if you use it.

## Transition to 5.1.1
- No backwards incompatible changes. See Release notes for bugfixes.

## Transition to 5.1.0
- Since Microblink.framework is a dynamic framework, you also need to **add it to embedded binaries section in General settings of your target.**

- Library size was reduced by removing all unnecessary components. One of the components removed was internal libz library. You now need to **add libz.tbd into "Linked frameworks and binaries" setting.**

- Microblink.framework is a dynamic framework which contains slices for all architectures - device and simulator. If you intend to extract .ipa file for ad hoc distribution, you'll need to preprocess the framework to remove simulator architectures. 

Ideal solution is to add a build phase after embed frameworks build phase, which strips unused slices from embedded frameworks.

Build step is based on the one provided here: http://ikennd.ac/blog/2015/02/stripping-unwanted-architectures-from-dynamic-libraries-in-xcode/

```shell
APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

# This script loops through the frameworks embedded in the application and
# removes unused architectures.
find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

EXTRACTED_ARCHS=()

for ARCH in $ARCHS
do
echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
done

echo "Merging extracted architectures: ${ARCHS}"
lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
rm "${EXTRACTED_ARCHS[@]}"

echo "Replacing original executable with thinned version"
rm "$FRAMEWORK_EXECUTABLE_PATH"
mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

done
```

- Deprecated `PPHelpDisplayMode`. It still works, but ideally, you should replace it with a custom logic for presenting help inside the application using the SDK.
- `PPAztecRecognizerResult` and `PPAztecRecognizerSettings` are now deprecated. Use `PPBarcodeRecognizerResult` and `PPBarcodeRecognizerSettings`
- `PPBarDecoderRecognizerResult` and `PPBarDecoderRecognizerSettings` are now deprecated. Use `PPBarcodeRecognizerResult` and `PPBarcodeRecognizerSettings`
- `PPZXingRecognizerResult` and `PPZXingRecognizerSettings` are now deprecated. Use `PPBarcodeRecognizerResult` and `PPBarcodeRecognizerSettings`

- Add libz into link binary with libaries. We removed internally used libz library to make the SDK smaller.

- Nullability attributes have been fixed. Basically, properties in the result classes are no longer consider nonnull (this was wrong!). You should always consider an option that the result property is nil, which means it doesn't exist at all on the scanned document.

## Transition to 5.0.5
- No backwards incompatible changes. See Release notes for bugfixes.

## Transition to 5.0.4

- No backwards incompatible changes. See Release notes for new features.

## Transition to 5.0.3

- No backwards incompatible changes. See Release notes for new features.

## Transition to 5.0.2

- No backwards incompatible changes. See Release notes for new features.

## Transition to 5.0.1

- No backwards incompatible changes. See Release notes for new features.

## Transition to 5.0.0

- `PPCameraCoordinator` now assumes the role of `PPCoordinator`. If you do not use your own camera management or Direct API you can rename all instances of `PPCoordinator` to `PPCameraCoordinator`
- `PPCoordinator` method `cameraViewControllerWithDelegate:` has been removed. To create `PPScanningViewControllers` you can now use `[PPViewControllerFactory cameraViewControllerWithDelegate: coordinator: error:]`
- Direct API is now located in `PPCoordinator`. To process image use 'processImage:' method and be sure to set 'PPCoordinatorDelegate' when creating 'PPCoordinator' to recieve scanning results and events. You can se processing image roi and processing orientation on 'PPImage' object.
- Methods of 'PPOverlayContainerViewController' protocol should now be called after camera view has appeared.

## Transition to 4.3.0.

- If you implement custom camera UI and handle `cameraViewController:didFindLocation:withStatus`, this method was changed to `cameraViewController:didFinishDetectionWithResult:`. `PPDetectorResult` object now contains all information previosusly passed to this method. Simply update the code to use the new method signature. Verify the exact type of the passed detectorResult object, cast it to this class, and use provided getters to obtain all information.

- PPOverlayViewController changed the way Overlay Subviews are added to the view hierarchy. Instead of calling `addOverlaySubview:` (which automatically added a view to view hierarachy), you now need to call `registerOverlaySubview:` (which registers subview for scanning events), and manually add subview to view hierarchy using `addSubview:` method. This change gives you more flexibility for adding views and managing autolayout and autoresizing masks. So, replace all calls to (assuming self is a `PPOverlayViewController` instance)

```objective-c
[self addOverlaySubview:subview];
```

with 
```objective-c
[self registerOverlaySubview:subview];
[self.view addSubview:subview];
```
- If you use DetectorRecognizer, designated initializer of `PPDocumentDecodingInfoEntry` objects changed. Instead of `initWithLocation:dewarpedHeight:` use `initWithLocation:dewarpedHeight:uniqueId:`. As Unique ID pass any unique string which you'll use to identify the decoding info object.

- Localization Macros MB_LOCALIZED and MB_LOCALIZED_FORMAT can now be overriden in your app to provide completely custom localization mechanisms.

- Remove the old .embeddedframework package completely from your project

- Add new .framework and .bundle package to your project. Verify that Framework search path really contains a path to the .framework folder.

- replace all occurrences of `PPCoordinator`'s method `isScanningUnsupported:` to `isScanningUnsupportedForCameraType:error:`. If you use Back facing camera, use `PPCameraTypeBack`, otherwise `PPCameraTypeFront`.

- Rename `PPMetadataSettings` properties 
- `successfulScanFrame` rename to `successfulFrame`
- `currentVideoFrame` rename to `currentFrame`

## Transition to 4.2.2

- No backwards incompatible changes.

## Transition to 4.2.1

- Added new callback method to `PPScanDelegate` which is called when license key is invalid: `scanningViewController:invalidLicenseKeyWithError:`

- Previously, this error was returned in `scanningViewController:didFindError` (although not in all situations), so if you handled the error in that callback, switch to the new one.

## Transition to 4.2.0

- If you're using Xcode 7, replace all .dylib libraries with .tbt libraries

- In USDL keys:

    - `kPPAamvaVersionNumber` key was renamed to `kPPStandardVersionNumber`
    - `kPPDocumentType` was added to distinguish between AAMVA, compact and magnetic PDF417 standards.

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