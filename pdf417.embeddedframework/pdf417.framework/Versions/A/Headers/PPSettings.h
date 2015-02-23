//
//  SettingsKeys.h
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 6/5/12.
//  Copyright (c) 2012 Racuni.hr. All rights reserved.
//

#ifndef PhotoPayFramework_SettingsKeys_h
#define PhotoPayFramework_SettingsKeys_h

/**
 KEYS for customizing pdf417.mobi behaviour
 
 Customization is done in the following way (sample code provided:)
 
 // Create object which stores photopay settings
 NSMutableDictionary* coordinatorSettings = [[NSMutableDictionary alloc] init];
 
 // present modal (recommended and default) - make sure you dismiss the view controller when done
 // you also can set this to NO and push camera view controller to navigation view controller
 [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPPresentModal];
 
 // Define the sound filename played on successful recognition
 NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
 [coordinatorSettings setValue:soundPath forKey:kPPSoundFile];
 
 [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizePdf417Key];
 [coordinatorSettings setValue:[NSNumber numberWithBool:YES] forKey:kPPRecognizeQrCodeKey];
 
 // Set the language. You can use "en", "de", "hr", if not specified, phone default will be used.
 // Use this according to your app localization strategy
 [coordinatorSettings setValue:@"en" forKey:kPPLanguage];
 
 // set the license key
 [coordinatorSettings setValue:@"abcd" forKey:kPPLicenseKey];
 
 // Allocate the recognition coordinator object
 PPBarcodeCoordinator *coordinator = [[PPBarcodeCoordinator alloc] initWithSettings:coordinatorSettings];
 
 As you can see, keys are used to provide values in the dictionary object used to construct
 PPBarcodeCoordinator object
 */

/** You should put a License key here to remove "noncommercial" message on camera view */
extern NSString* const kPPLicenseKey;
/** If you have got license key that supports multiple bundle IDs, then besides license key, you need to provide license key owner to which license key is bound */
extern NSString* const kPPLicenseOwner;

/** Scanner setup. What we recognize */

/** When an object under this key is boolean true, pdf417 is scanned */
extern NSString* const kPPRecognizePdf417Key;
/** When an object under this key is boolean true, Qr code is scanned */
extern NSString* const kPPRecognizeQrCodeKey;
/** When an object under this key is boolean true, All 1D barcodes are enabled */
extern NSString* const kPPRecognize1DBarcodesKey;
/** When an object under this key is boolean true, Code128 barcode is scanned */
extern NSString* const kPPRecognizeCode128Key;
/** When an object under this key is boolean true, Code39 barcode is scanned */
extern NSString* const kPPRecognizeCode39Key;
/** When an object under this key is boolean true, EAN13 barcode is scanned */
extern NSString* const kPPRecognizeEAN13Key;
/** When an object under this key is boolean true, EAN8 barcode is scanned */
extern NSString* const kPPRecognizeEAN8Key;
/** When an object under this key is boolean true, ITF barcode is scanned */
extern NSString* const kPPRecognizeITFKey;
/** When an object under this key is boolean true, UPCA barcode is scanned */
extern NSString* const kPPRecognizeUPCAKey;
/** When an object under this key is boolean true, UPCE barcode is scanned */
extern NSString* const kPPRecognizeUPCEKey;
/** When an object under this key is boolean true, AZTEC barcodes are scanned */
extern NSString* const kPPRecognizeAztecKey;
/** When an object under this key is boolean true, DataMatrix barcodes are scanned */
extern NSString* const kPPRecognizeDataMatrixKey;
/** When an object under this key is boolean true, US driver licenses are scanned */
extern NSString* const kPPRecognizeUSDLKey;

/** 
 Scanning control
 Use these features only if you have to because they slow down the scanning process 
 */

/** Allow scanning uncertain barcodes - i.e. incomplete ones or not according to standard */
extern NSString* const kPPScanUncertainBarcodes;
/** Allow scanning barcodes which don't have quiet zone surrounding it */
extern NSString* const kPPAllowNullQuietZone;
/** Allow scanning of barcodes with inverse intensity values
 *      (e.g. white barcode on black background) */
extern NSString* const kPPAllowInverseBarcodes;
/** 
 Allow scanning of multiple barcode types on the same image
 Use this feature if you expect different barcode types on the same image and
 you want to obtain scanning results for all of them
 */
extern NSString* const kPPOutputMultipleResults;
/** 
 Use automatic scale detection feature.
 This normally should not be used.
 The only situation where this helps in getting better scanning results is when using kPPUseVideoPresetPhoto on iPad devices.
 Video preview resoution of 2045x1536 in that case is very large and autoscale helps.
 */
extern NSString* const kPPUseAutoscaleDetection;

/** Keys for camera setup */

/** If YES, 640x480 quality video is used. This is the default */
extern NSString* const kPPUseVideoPreset640x480;
/** If YES, Medium quality video is used. */
extern NSString* const kPPUseVideoPresetMedium;
/** If YES, High quality video is used. */
extern NSString* const kPPUseVideoPresetHigh;
/** If YES, Highest video resolution is used. */
extern NSString* const kPPUseVideoPresetHighest;
/** If YES, Photo Quality video is used: Note: use this only if you don't have other choice.
 That's because camera resolution in Photo preset is equal to screen resolution. */
extern NSString* const kPPUseVideoPresetPhoto;

/** Under this key you can specify rect used for scanning */
extern NSString* const kPPScanningRoi;

/** Language setup */
extern NSString* const kPPLanguage;

/** Presentation style */

/** If YES, PhotoPay's CameraViewController is presented modally. */
extern NSString* const kPPPresentModal;

/** If YES, Front facing camera of the device will be used */
extern NSString* const kPPUseFrontFacingCamera;

/** Disable only near autofocus hint on iOS7+ */
extern NSString* const kPPAutofocusFull;

/** Work style */
/** Determines if overlay view should autorotate */
extern NSString* const kPPOverlayShouldAutorotate;
/** Under this key the Color of the viewfinder is stored */
extern NSString* const kPPViewfinderColor;
/** Under this key the is stored information whether viewfinder is moveable */
extern NSString* const kPPViewfinderMoveable;

/** Sound file which will be played on successful recognition */
extern NSString* const kPPSoundFile;

/** Original image (currently processed) will be passed via API */
extern NSString* const kPPSaveBgrImageKey;

/** Image which resulted with successful scan will be passed via API */
extern NSString* const kPPSaveSuccessImageKey;


#endif
