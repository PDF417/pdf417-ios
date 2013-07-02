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
 
 // You can set orientation mask for allowed orientations, default is UIInterfaceOrientationMaskAll
 [coordinatorSettings setValue:[NSNumber numberWithInt:UIInterfaceOrientationMaskAll] forKey:kPPHudOrientation];
 
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

/** Scanner setup. What we recognize */

/** When an object under this key is boolean true, pdf417 is scanned */
extern NSString* const kPPRecognizePdf417Key;
/** When an object under this key is boolean true, Qr code is scanned */
extern NSString* const kPPRecognizeQrCodeKey;

/** Keys for camera setup */

/** If YES, 640x480 quality video is used. This is the default */
extern NSString* const kPPUseVideoPreset640x480;
/** If YES, Medium quality video is used. */
extern NSString* const kPPUseVideoPresetMedium;
/** If YES, High quality video is used. */
extern NSString* const kPPUseVideoPresetHigh;

/** Language setup */
extern NSString* const kPPLanguage;

/** Presentation style */

/** If YES, PhotoPay's CameraViewController is presented modally. */
extern NSString* const kPPPresentModal;

/** Work style */
/** Determines the orientation of toast messages. Default is Portrait */
extern NSString* const kPPHudOrientation;
/** Under this key the Color of the viewfinder is stored */
extern NSString* const kPPViewfinderColor;
/** Under this key the is stored information whether viewfinder is moveable */
extern NSString* const kPPViewfinderMoveable;

/** Sound file which will be played on successful recognition */
extern NSString* const kPPSoundFile;


#endif
