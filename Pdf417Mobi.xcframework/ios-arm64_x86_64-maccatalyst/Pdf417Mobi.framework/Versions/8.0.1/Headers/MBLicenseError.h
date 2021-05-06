//
//  MBLicenseError.h
//  MicroblinkDev
//
//  Created by Mijo Gracanin on 23/09/2020.
//

#ifndef MBLicenseError_h
#define MBLicenseError_h

#import <Foundation/Foundation.h>

extern NSString * const MBBLicenseErrorNotification;

typedef NS_ENUM(NSInteger, MBBLicenseError) {
    MBBLicenseErrorNetworkRequired,
    MBBLicenseErrorUnableToDoRemoteLicenceCheck,
    MBBLicenseErrorLicenseIsLocked,
    MBBLicenseErrorLicenseCheckFailed,
    MBBLicenseErrorInvalidLicense
};

typedef void(^MBBLicenseErrorBlock)(MBBLicenseError licenseError);

#endif /* MBLicenseError_h */
