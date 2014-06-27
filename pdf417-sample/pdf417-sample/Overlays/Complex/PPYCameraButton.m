//
//  PPCameraButton.m
//  PhotoPayFramework
//
//  Created by Jurica Cerovec on 20/11/13.
//  Copyright (c) 2013 Racuni.hr. All rights reserved.
//

#if  __has_feature(objc_arc)
#error This file must be compiled without ARC. Use -fno-objc-arc flag
#endif

#import "PPYCameraButton.h"

// Alpha
#define DEFAULT_ALPHA                   0.8f
#define DEFAULT_DISABLED_ALPHA          0.5f

// Background color
#define DEFAULT_BKG_WHITE               1.0f
#define DEFAULT_BKG_ALPHA               0.6f
#define DEFAULT_BKG_COLOR               ([UIColor colorWithWhite:DEFAULT_BKG_WHITE alpha:DEFAULT_BKG_ALPHA])
#define DEFAULT_BKG_COLOR_HIGHLIGHTED   ([UIColor colorWithWhite:DEFAULT_BKG_WHITE alpha:1.0])

// Padding
#define DEFAULT_HORI_PADDING            12.0f
#define DEFAULT_VERT_PADDING            8.0f

// Border
#define DEFAULT_BORDER_WIDTH            1.0f
#define DEFAULT_BORDER_WHITE            0.0f
#define DEFAULT_BORDER_ALPHA            1.0f
#define DEFAULT_BORDER_COLOR            ([UIColor colorWithWhite:DEFAULT_BORDER_WHITE alpha:DEFAULT_BORDER_ALPHA])

// Font
#define DEFAULT_FONT_IPAD               ([UIFont boldSystemFontOfSize:16.0f])
#define DEFAULT_FONT_IPHONE             ([UIFont boldSystemFontOfSize:14.0f])
#define DEFAULT_FONT                    ((([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)) ? DEFAULT_FONT_IPAD : DEFAULT_FONT_IPHONE)

@interface PPYCameraButton ()

@end

@implementation PPYCameraButton

- (id)init {
    self = [super init];
    if (self) {
        self.layer.borderWidth = DEFAULT_BORDER_WIDTH;
        
        [self addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(highlight:) forControlEvents:UIControlEventTouchDown];
        
        self.layer.borderColor = [DEFAULT_BORDER_COLOR CGColor];
        self.titleLabel.textColor = DEFAULT_BORDER_COLOR;
        self.titleLabel.font = DEFAULT_FONT;
        
        self.backgroundColor = DEFAULT_BKG_COLOR;
        self.alpha = DEFAULT_ALPHA;
        self.opaque = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = DEFAULT_BORDER_WIDTH;
        
        [self addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(highlight:) forControlEvents:UIControlEventTouchDown];
        
        self.layer.borderColor = [DEFAULT_BORDER_COLOR CGColor];
        self.titleLabel.font = DEFAULT_FONT;
        
        self.backgroundColor = DEFAULT_BKG_COLOR;
        self.alpha = DEFAULT_ALPHA;
        self.opaque = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.layer.cornerRadius = self.frame.size.height / 2;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.layer.cornerRadius = self.frame.size.height / 2;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [super setTitleColor:DEFAULT_BORDER_COLOR forState:state];
}

- (void)sizeToFit {
    [super sizeToFit];
    
    CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGSize imageSize = self.imageView.frame.size;
    
    CGFloat newWidth = textSize.width + 2 * DEFAULT_HORI_PADDING;
    if (imageSize.width > 0) {
        // add space between image and text
        newWidth += imageSize.width + DEFAULT_HORI_PADDING;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, DEFAULT_HORI_PADDING, 0.0f, 0.0f)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0.0f, -DEFAULT_HORI_PADDING/2, 0.0f, 0.0f)];
    }
    CGFloat newHeight = MAX(textSize.height, imageSize.height) + 2 * DEFAULT_VERT_PADDING;
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, newHeight)];
}

- (void)setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	self.alpha = enabled ? DEFAULT_ALPHA : DEFAULT_DISABLED_ALPHA;
}

- (void)pressed:(id)sender {
    self.backgroundColor = DEFAULT_BKG_COLOR;
}

- (void)highlight:(id)sender {
    self.backgroundColor = DEFAULT_BKG_COLOR_HIGHLIGHTED;
}

@end
