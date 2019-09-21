//
//  DKObjectManager.m
//  Memory
//
//  Created by denis kotenko on 22.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKObjectManager.h"
#import "NSManagedObject.h"
#import "EventsCategory.h"
#import "Event.h"


@implementation DKObjectManager

@synthesize objectStore;

// -------------------------------------------------------------------------------

- (id) init {
    self = [super init];
    if (self) {
        objectStore = [[DKManagedObjectStore alloc] initWithStoreFilename:@"Data.sqlite"];
    }
    return self;
}

// -------------------------------------------------------------------------------

- (NSArray *) allCategoriesByOrderAndDate {
    //NSSortDescriptor *mySort = [NSSortDescriptor sortDescriptorWithKey:@"events" ascending:NO];
    NSSortDescriptor *lastEventDateDesc = [NSSortDescriptor sortDescriptorWithKey:@"lastEventDate" ascending:NO];
    NSSortDescriptor *orderDesc = [NSSortDescriptor sortDescriptorWithKey:@"categoryId" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastEventDateDesc, orderDesc, nil];
    
    return [[EventsCategory allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

// -------------------------------------------------------------------------------

- (NSArray *) allCategoriesByDateAndOrder {
    NSSortDescriptor *lastEventDateDesc = [NSSortDescriptor sortDescriptorWithKey:@"lastEventDate" ascending:NO];
    NSSortDescriptor *orderDesc = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:lastEventDateDesc, orderDesc, nil];
    return [[EventsCategory allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

// -------------------------------------------------------------------------------

- (NSArray *) allCategoriesByOrder {
    NSSortDescriptor *orderDesc = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:orderDesc, nil];
    return [[EventsCategory allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

// -------------------------------------------------------------------------------

- (NSArray *) allCategories {
    return [EventsCategory allObjects];
}

// -------------------------------------------------------------------------------

- (EventsCategory *) createCategoryWithName:(NSString *) name {
    EventsCategory *category = [EventsCategory object];
    category.categoryId = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    category.name = name;
    category.order = [NSNumber numberWithInt:0];
    
    [self reorderCategories];
    return category;
}

// -------------------------------------------------------------------------------

- (Event *) createEventWithComment:(NSString *) comment price:(CGFloat) price date:(NSDate *) date {
    Event *event = [Event object];
    event.comment = comment;
    event.price = [NSNumber numberWithFloat:price];
    event.date = date;
    
    return event;
}

// -------------------------------------------------------------------------------

- (Event *) createEventInCategory:(EventsCategory *) category 
    comment:(NSString *) comment price:(CGFloat) price date:(NSDate *) date {
    
    Event *event = [self createEventWithComment:comment price:price date:date];
    [category addEvent:event];
    
    [self reorderCategories];
    return event;
}

// -------------------------------------------------------------------------------

- (void) reorderCategories {
    NSArray *categories = [[DKObjectManager sharedManager] allCategoriesByDateAndOrder];
    for (int i = 0; i < [categories count]; i++) {
        EventsCategory *cat = [categories objectAtIndex:i];
        cat.order = [NSNumber numberWithInt:i + 1];
    }
    
    [objectStore save];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Singleton Pattern

static DKObjectManager *sharedManager_ = nil;

+ (DKObjectManager *) sharedManager {
    if (sharedManager_ == nil) {
        sharedManager_ = [[super allocWithZone:NULL] init];
    }
    
    return sharedManager_;
}

// -------------------------------------------------------------------------------

+ (id) allocWithZone:(NSZone *) zone {
    return [[self sharedManager] retain];
}

// -------------------------------------------------------------------------------

- (id) copyWithZone:(NSZone *) zone {
    return self;
}

// -------------------------------------------------------------------------------

- (id) retain {
    return self;
}

// -------------------------------------------------------------------------------

- (NSUInteger) retainCount {
    return NSUIntegerMax;  // denotes an object that cannot be released
}

// -------------------------------------------------------------------------------

- (oneway void) release {
    // do nothing
}

// -------------------------------------------------------------------------------

- (id) autorelease {
    return self;
}

// -------------------------------------------------------------------------------

- (void) dealloc {
    [sharedManager_ release];
    [objectStore release];
    
    [super dealloc];
}

// -------------------------------------------------------------------------------

@end
