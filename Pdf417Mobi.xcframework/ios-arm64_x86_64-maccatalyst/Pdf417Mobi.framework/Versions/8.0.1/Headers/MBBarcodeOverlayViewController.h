//
//  MBBarcodeOverlayViewController.h
//  BarcodeFramework
//
//  Created by Jura on 22/12/13.
//  Copyright (c) 2015 Microblink Ltd. All rights reserved.
//

#import "MBBaseOverlayViewController.h"
#import "MBBarcodeOverlaySettings.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBBBarcodeOverlayViewControllerDelegate;

@class MBBBarcodeOverlaySettings;
@class MBBRecognizerCollection;

MB_CLASS_AVAILABLE_IOS(8.0) MB_FINAL
@interface MBBBarcodeOverlayViewController : MBBBaseOverlayViewController

/**
 * Common settings
 */
@property (nonatomic, strong, readonly) MBBBarcodeOverlaySettings *settings;

/**
 * Delegate
 */
@property (nonatomic, weak, readonly) id<MBBBarcodeOverlayViewControllerDelegate> delegate;

/**
 * Designated intializer.
 *
 *  @param settings MBBBarcodeOverlaySettings object
 *
 *  @param recognizerCollection MBBRecognizerCollection object
 *
 *  @return initialized overlayViewController
 */
- (instancetype)initWithSettings:(MBBBarcodeOverlaySettings *)settings recognizerCollection:(MBBRecognizerCollection *)recognizerCollection delegate:(nonnull id<MBBBarcodeOverlayViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
