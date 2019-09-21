//
//  EventsCategory.m
//  Memory
//
//  Created by denis kotenko on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKObjectManager.h"
#import "EventsCategory.h"
#import "Event.h"


@implementation EventsCategory

@dynamic categoryId;
@dynamic name;
@dynamic order;

// -------------------------------------------------------------------------------

- (void) addEvent:(Event *) event {
    event.categoryId = self.categoryId;
}

// -------------------------------------------------------------------------------

- (void) removeEvent:(Event *) event {
    
}

// -------------------------------------------------------------------------------

- (NSArray *) events {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId = %@", self.categoryId];
    return [Event objectsWithPredicate:predicate];
}

// -------------------------------------------------------------------------------

- (Event *) lastEvent {
    NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortedData = [[self events] sortedArrayUsingDescriptors:[NSArray arrayWithObject:desc]];
    [desc release];
    
    return [sortedData lastObject];
}

// -------------------------------------------------------------------------------

- (NSDate *) lastEventDate {
    return [self lastEvent].date;
}

// -------------------------------------------------------------------------------

- (CGFloat) totalPrice {
    CGFloat result = 0.0f;
    for (Event *event in [self events]) {
        result += [event.price floatValue];
    }
    
    return result;
}

// -------------------------------------------------------------------------------

@end
