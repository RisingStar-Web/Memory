//
//  PCConstants.m
//  PropConnectApi
//
//  Created by macuser on 26.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"


NSString *const GeneralFontName = @"Helvetica";
NSString *const GeneralBoldFontName = @"Helvetica-Bold";

CGFloat const TableViewTextLabelFontSize       = 16.0f;
CGFloat const TableViewDetailTextLabelFontSize = 13.0f;

CGColorRef 
    kGeneralTextColor,
    kGeneralHighlightedTextColor,
    kDetailGeneralTextColor,
    kDetailHighlightedTextColor,
    kNavigationBarColor,
    kSegmentedControlColor,
    kSegmentedControlColor7;

// -------------------------------------------------------------------------------

__attribute__((constructor))  // Makes this function run when the app loads
static void InitColors() {
	kGeneralTextColor            = CreateGray(0.0f, 1.0f);
	kGeneralHighlightedTextColor = CreateGray(1.0f, 1.0f);
    kDetailGeneralTextColor      = CreateGray(0.45f, 1.0f);
    kDetailHighlightedTextColor  = kGeneralHighlightedTextColor;
    
//    kNavigationBarColor          = CreateRGB(160, 93, 136, 100);
    kNavigationBarColor          = CreateRGB(145, 69, 117, 100);
    kSegmentedControlColor       = CreateRGB(54, 15, 40, 100);
    kSegmentedControlColor7      = CreateRGB(138, 138, 138, 100);
}

// -------------------------------------------------------------------------------

CGColorRef CreateRGB(NSInteger red, NSInteger green, NSInteger blue, NSInteger alpha) {
    CGFloat theRed   = abs(red)   <= 255 ? (CGFloat) abs(red)   / 255 : 1.0;
    CGFloat theGreen = abs(green) <= 255 ? (CGFloat) abs(green) / 255 : 1.0;
    CGFloat theBlue  = abs(blue)  <= 255 ? (CGFloat) abs(blue)  / 255 : 1.0;
    CGFloat theAlpha = abs(alpha) <= 100 ? (CGFloat) abs(alpha) / 100 : 1.0;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[4] = { theRed, theGreen, theBlue, theAlpha };
    CGColorRef color = CGColorCreate(colorspace, components);
    CGColorSpaceRelease(colorspace);
	
    return color;
}

// -------------------------------------------------------------------------------

CGColorRef CreateGray(CGFloat gray, CGFloat alpha) {
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
    CGFloat components[2] = {gray, alpha};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGColorSpaceRelease(colorspace);
    return color;
}

// -------------------------------------------------------------------------------
