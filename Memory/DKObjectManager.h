//
//  DKObjectManager.h
//  Memory
//
//  Created by denis kotenko on 22.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKManagedObjectStore.h"


@class EventsCategory;
@class Event;

@interface DKObjectManager : NSObject {

    DKManagedObjectStore *objectStore;
    
}

@property (nonatomic, readonly) DKManagedObjectStore *objectStore;

+ (DKObjectManager *) sharedManager;

- (NSArray *) allCategoriesByDateAndOrder;
- (NSArray *) allCategoriesByOrderAndDate;
- (NSArray *) allCategoriesByOrder;
- (NSArray *) allCategories;
- (EventsCategory *) createCategoryWithName:(NSString *) name;
- (Event *) createEventInCategory:(EventsCategory *) category comment:(NSString *) comment price:(CGFloat) price date:(NSDate *) date; 
- (void) reorderCategories;

@end
