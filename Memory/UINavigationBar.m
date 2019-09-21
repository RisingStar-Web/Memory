//
//  UINavigationBar.m
//  TapAndCall
//
//  Created by macuser on 21.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import "UINavigationBar.h"
#import "UIView.h"


static void (*_origLayoutSubviews) (id, SEL);
static void OverrideLayoutSubviews(UINavigationBar *self, SEL _cmd) {
    if (IOS_VERSION_GREATER_THAN(@"7.0")) {
        _origLayoutSubviews(self, _cmd);
        return;
    }
    NSMutableArray *sizes = [NSMutableArray array];
    for (UIView *view in [self subviews]) {
        [sizes addObject:NSStringFromCGSize(view.frameSize)];
    }
    
    _origLayoutSubviews(self, _cmd);
    
    for (int i = 0; i < [self.subviews count]; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        CGSize size = CGSizeFromString([sizes objectAtIndex:i]);
        if ([[view class] isSubclassOfClass:[UIButton class]]) {
            if (CGSizeEqualToSize(size, CGSizeZero) == NO) {
                view.frameSize = size;
            }
        }
    }
}


@implementation UINavigationBar (UINavigationBar)

// -------------------------------------------------------------------------------

+ (void) load {   
    // Replace initWithFrame method
    Method origMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
    _origLayoutSubviews = (void *) method_getImplementation(origMethod);
    
    if (!class_addMethod(self, @selector(layoutSubviews), (IMP) OverrideLayoutSubviews, method_getTypeEncoding(origMethod)))
        method_setImplementation(origMethod, (IMP) OverrideLayoutSubviews);
}

// -------------------------------------------------------------------------------

@end
