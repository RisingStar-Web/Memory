//
//  UIView.h
//  PickAndRoll
//
//  Created by macuser on 18.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (UIView)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

- (void) moveTo:(CGPoint) center duration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector;
- (void) frameTo:(CGRect) frame duration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector;
- (void) fadeInWithDuration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector;
- (void) fadeOutWithDuration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector;
- (void) zoomInWithDuration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector;
- (void) zoomOutWithDuration:(CGFloat) duration delegate:(id) delegate didStopSelector:(SEL) selector;

- (void) removeAllAnimations;
- (void) removeAllSubviews;
- (void) removeAllSubviewsExcept:(UIView *) view;
- (void) setHiddenForAllSubviews:(BOOL) hidden;
- (void) setBackgroundColorForAllSubviews:(UIColor *) backgroundColor;
- (NSArray *) subviewsInRect:(CGRect) rect;

@end
