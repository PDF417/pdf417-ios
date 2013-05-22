//
//  DetectionStatus.h
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 5/12/13.
//  Copyright (c) 2013 Racuni.hr. All rights reserved.
//

#ifndef PhotoPayFramework_DetectionStatus_h
#define PhotoPayFramework_DetectionStatus_h

/**
 * Detection status enum.
 * Used in UI.
 */
typedef enum _PPDetectionStatus {
    PPDetectionStatusSuccess 			= 1<<0, // Payment form detected
    PPDetectionStatusFail 				= 1<<1, // Detection failed, form not detected
    PPDetectionStatusCameraTooHigh      = 1<<2, // Form detected, but the camera is too far above the payment form
    PPDetectionStatusCameraAtAngle      = 1<<3, // Form detected, but the perspective angle of camera is too high
    PPDetectionStatusCameraRotated      = 1<<4, // Form detected, but the payment form is rotated and not aligned to the camera edges
    PPDetectionStatusQRSuccess          = 1<<6, // QR code detected
    PPDetectionStatusPdf417Success      = 1<<7, // PDF417 code detected
    PPDetectionStatusFallbackSuccess    = 1<<8, // Detection from fallback
    PPDetectionStatusPartialForm        = 1<<9  // Form detected, but only partially visible on screen
} PPDetectionStatus;

#endif
