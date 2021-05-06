//
//  MBDetectionStatus.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 08/12/2017.
//

/**
 * Status of the object detection in Microblink SDK
 */
typedef NS_OPTIONS(NSInteger, MBBDetectionStatus) {
    
    /** Object was successfuly detected. */
    MBBDetectionStatusSuccess = 1 << 0,
    
    /** Object was not detected */
    MBBDetectionStatusFail = 1 << 1,
    
    /** Object was successfully detected, but the camera was too far above the object for processing */
    MBBDetectionStatusCameraTooHigh = 1 << 2,
    
    /** Object was successfully detected, but the perspective angle of camera is too high */
    MBBDetectionStatusCameraAtAngle = 1 << 3,
    
    /** Object was successfully detected, but the object is rotated and not aligned to the camera edges */
    MBBDetectionStatusCameraRotated = 1 << 4,
    
    /** QR code was successfully detected */
    MBBDetectionStatusQRSuccess = 1 << 6,
    
    /** PDF417 barcode was successfully detected */
    MBBDetectionStatusPdf417Success = 1 << 7,
    
    /** Object was successfully detected using a fallback algorithm */
    MBBDetectionStatusFallbackSuccess = 1 << 8,
    
    /** Object was detected, but is only partially visible on screen */
    MBBDetectionStatusPartialForm = 1 << 9,
    
    /** Object was successfully detected, but the camera is too near to the object for processing */
    MBBDetectionStatusCameraTooNear = 1 << 10,
    
    /** Document detected, but document is too close to the edge of the frame */
    MBBDetectionStatusDocumentTooCloseToEdge = 1 << 11,
};
