//
//  PCConstants.h
//  PropConnectApi
//
//  Created by macuser on 26.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


extern NSString *const GeneralFontName;
extern NSString *const GeneralBoldFontName;

extern CGFloat const TableViewTextLabelFontSize;
extern CGFloat const TableViewDetailTextLabelFontSize;

extern CGColorRef 
    kGeneralTextColor,
    kGeneralHighlightedTextColor,
    kDetailGeneralTextColor,
    kDetailHighlightedTextColor,
    kNavigationBarColor,
    kSegmentedControlColor,
    kSegmentedControlColor7;

CGColorRef CreateRGB(NSInteger red, NSInteger green, NSInteger blue, NSInteger alpha);
CGColorRef CreateGray(CGFloat gray, CGFloat alpha);