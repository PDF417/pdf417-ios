//
//  MBBarcodeResult.h
//  MicroblinkDev
//
//  Created by Jura Skrlec on 28/11/2017.
//

/**
 * Enumeration of possible barcode formats
 */
typedef NS_ENUM(NSInteger, MBBBarcodeType) {
    MBBBarcodeNone = 0,
    /** QR code */
    MBBBarcodeTypeQR,
    /** Data Matrix */
    MBBBarcodeTypeDataMatrix,
    /** UPCE */
    MBBBarcodeTypeUPCE,
    /** UPCA */
    MBBBarcodeTypeUPCA,
    /** EAN 8 */
    MBBBarcodeTypeEAN8,
    /** EAN 13 */
    MBBBarcodeTypeEAN13,
    /** Code 128 */
    MBBBarcodeTypeCode128,
    /** Code 39 */
    MBBBarcodeTypeCode39,
    /** ITF */
    MBBBarcodeTypeITF,
    /** Code 39 */
    MBBBarcodeTypeAztec,
    /** PDF 417 */
    MBBBarcodeTypePdf417
};
