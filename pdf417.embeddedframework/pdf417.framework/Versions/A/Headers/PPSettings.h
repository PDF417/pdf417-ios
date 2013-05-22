//
//  SettingsKeys.h
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 6/5/12.
//  Copyright (c) 2012 Racuni.hr. All rights reserved.
//

#ifndef PhotoPayFramework_SettingsKeys_h
#define PhotoPayFramework_SettingsKeys_h

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

/** If YES, only detection (not recognition) is performed. Default is NO */
extern NSString* const kPPPerformDetectionOnlyKey;
/** If YES, debug info is presented on screen. Default is NO */
extern NSString* const kPPPresentDebugInfoKey;
/** If YES, toast-like status messages are presented on screen. Default is NO */
extern NSString* const kPPPresentToastMessages;
/** Determines the orientation of toast messages. Default is Portrait */
extern NSString* const kPPHudOrientation;
/** Under this key the Color of the viewfinder is stored */
extern NSString* const kPPViewfinderColor;
/** Under this key the is stored information whether viewfinder is moveable */
extern NSString* const kPPViewfinderMoveable;

/** Saving of images */
/** Debug image saving */
extern NSString* const kPPSaveBgrImageKey;
extern NSString* const kPPSaveGrayscaleImageKey;
extern NSString* const kPPSaveDewarpedImageKey;
extern NSString* const kPPSaveDetectionImageKey;

/** Sound file which will be played on successful recognition */
extern NSString* const kPPSoundFile;

#endif
