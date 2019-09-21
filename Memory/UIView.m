//
//  UIView.m
//  PickAndRoll
//
//  Created by macuser on 18.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView.h"


@implementation UIView (UIView)

// -------------------------------------------------------------------------------

- (CGPoint)frameOrigin {
    return self.frame.origin;
}

// -------------------------------------------------------------------------------

- (void)setFrameOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

// -------------------------------------------------------------------------------

- (CGSize)frameSize {
    return self.frame.size;
}

// -------------------------------------------------------------------------------

- (void)setFrameSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newSize.width, newSize.height);
}

// -------------------------------------------------------------------------------

- (CGFloat)frameX {
    return self.frame.origin.x;
}

// -------------------------------------------------------------------------------

- (void)setFrameX:(CGFloat)newX {
    self.frame = CGRectMake(newX, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

// -------------------------------------------------------------------------------

- (CGFloat)frameY {
    return self.frame.origin.y;
}

// -------------------------------------------------------------------------------

- (void)setFrameY:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x, newY,
                            self.frame.size.width, self.frame.size.height);
}

// -------------------------------------------------------------------------------

- (CGFloat)frameRight {
    return self.frame.origin.x + self.frame.size.width;
}

// -------------------------------------------------------------------------------

- (void)setFrameRight:(CGFloat)newRight {
    self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

// -------------------------------------------------------------------------------

- (CGFloat)frameBottom {
    return self.frame.origin.y + self.frame.size.height;
}

// -------------------------------------------------------------------------------

- (void)setFrameBottom:(CGFloat)newBottom {
    self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
                            self.frame.size.width, self.frame.size.height);
}

// -------------------------------------------------------------------------------

- (CGFloat)frameWidth {
    return self.frame.size.width;
}

// -------------------------------------------------------------------------------

- (void)setFrameWidth:(CGFloat)newWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newWidth, self.frame.size.height);
}

// -------------------------------------------------------------------------------

- (CGFloat)frameHeight {
    return self.frame.size.height;
}

// -------------------------------------------------------------------------------

- (void)setFrameHeight:(CGFloat)newHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, newHeight);
}

// -------------------------------------------------------------------------------

- (void) moveTo:(CGPoint) center duration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector {
    [UIView beginAnimations:@"moveTo" context:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:delegate];
    [UIView setAnimationDidStopSelector:selector];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.center = center;
    [UIView commitAnimations];
}

// -------------------------------------------------------------------------------

- (void) frameTo:(CGRect) frame duration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector {
    [UIView beginAnimations:@"frameTo" context:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:delegate];
    [UIView setAnimationDidStopSelector:selector];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.frame = frame;
    [UIView commitAnimations];
}

// -------------------------------------------------------------------------------

- (void) fadeInWithDuration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector {
    [UIView beginAnimations:@"fadeIn" context:self];
    [UIView setAnimationDelegate:delegate];
    [UIView setAnimationDidStopSelector:selector];
    [UIView setAnimationDuration:duration];
        self.alpha = 1.0f;
    [UIView commitAnimations];
}

// -------------------------------------------------------------------------------

- (void) fadeOutWithDuration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector {
    [UIView beginAnimations:@"fadeOut" context:self];
    [UIView setAnimationDelegate:delegate];
    [UIView setAnimationDidStopSelector:selector];
    [UIView setAnimationDuration:duration];
        self.alpha = 0.0f;
    [UIView commitAnimations];
}

// -------------------------------------------------------------------------------

- (void) zoomInWithDuration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector {
    [UIView beginAnimations:@"zoomIn" context:self];
    [UIView setAnimationDelegate:delegate];
    [UIView setAnimationDidStopSelector:selector];
    [UIView setAnimationDuration:duration];
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView commitAnimations];
}

// -------------------------------------------------------------------------------

- (void) zoomOutWithDuration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector {
    [UIView beginAnimations:@"zoomOut" context:self];
    [UIView setAnimationDelegate:delegate];
    [UIView setAnimationDidStopSelector:selector];
    [UIView setAnimationDuration:duration];
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView commitAnimations];
}

// -------------------------------------------------------------------------------

- (void) removeAllAnimations {
    [self.layer removeAllAnimations];
}

// -------------------------------------------------------------------------------

- (void) removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

// -------------------------------------------------------------------------------

- (void) removeAllSubviewsExcept:(UIView *) theView {
    for (UIView *view in self.subviews) {
        if ([view isEqual:theView] == NO) {
            [view removeFromSuperview];
        }
    }
}

// -------------------------------------------------------------------------------

- (void) setHiddenForAllSubviews:(BOOL) hidden {
    for (UIView *view in self.subviews) {
        view.hidden = hidden;
    }
}

// -------------------------------------------------------------------------------

- (void) setBackgroundColorForAllSubviews:(UIColor *) backgroundColor {
    self.backgroundColor = backgroundColor;
    for (UIView *subview in self.subviews) {
        [subview setBackgroundColorForAllSubviews:backgroundColor];
    }
}

// -------------------------------------------------------------------------------

- (UIView *) viewWithFrame:(CGRect) frame {
    for (int i = 0; i < [self.subviews count]; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        if (CGRectEqualToRect(view.frame, frame)) {
            return view;
        }
    }
    
    return nil;
}

// -------------------------------------------------------------------------------

- (NSArray *) subviewsInRect:(CGRect) rect {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.subviews count]; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        if (CGRectIsNull(CGRectIntersection(rect, view.frame)) == NO) {
            [result addObject:view];
        }
    }
    
    return [result autorelease];
}

// -------------------------------------------------------------------------------

@end
