//
//  MBException.h
//  Pdf417MobiDev
//
//  Created by Jura Skrlec on 07/02/2018.
//

#ifndef MBException_h
#define MBException_h

typedef NSString * MBBExceptionName NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXPORT MBBExceptionName const MBBIllegalModificationException;
FOUNDATION_EXPORT MBBExceptionName const MBBInvalidLicenseKeyException;
FOUNDATION_EXPORT MBBExceptionName const MBBInvalidLicenseeKeyException;
FOUNDATION_EXPORT MBBExceptionName const MBBInvalidLicenseResourceException;
FOUNDATION_EXPORT MBBExceptionName const MBBInvalidBundleException;
FOUNDATION_EXPORT MBBExceptionName const MBBMissingSettingsException;
FOUNDATION_EXPORT MBBExceptionName const MBBInvalidArgumentException;

#endif /* MBException_h */
