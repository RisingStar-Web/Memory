//
//  EventsCategory.h
//  Memory
//
//  Created by denis kotenko on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface EventsCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;

@end

@interface EventsCategory (CoreDataGeneratedAccessors)

- (Event *) lastEvent;
- (NSDate *) lastEventDate;
- (CGFloat) totalPrice;

- (void) addEvent:(Event *) event;
- (void) removeEvent:(Event *) event;

- (NSArray *) events;

@end
