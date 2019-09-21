//
//  Event.m
//  Memory
//
//  Created by denis kotenko on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
#import "EventsCategory.h"
#import "NSManagedObject.h"


@implementation Event

@dynamic comment;
@dynamic date;
@dynamic price;
@dynamic categoryId;

- (EventsCategory *) category {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId = %@", self.categoryId];
    return [EventsCategory firstObjectWithPredicate:predicate];
}


@end
