//
//  InfoObject.m
//  Memory
//
//  Created by denis kotenko on 08.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoObject.h"


@implementation InfoObject

@synthesize startDate;
@synthesize endDate;
@synthesize price;

// -------------------------------------------------------------------------------

- (void) dealloc {
    [startDate release];
    [endDate release];
    
    [super dealloc];
}

// -------------------------------------------------------------------------------

- (void) setEndDate:(NSDate *) theEndDate {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *startDayComponents = [gregorian components:NSDayCalendarUnit fromDate:startDate];
    NSInteger startDay = [startDayComponents day];
    
    NSDateComponents *endDayComponents = [gregorian components:NSDayCalendarUnit fromDate:theEndDate];
    NSInteger endDay = [endDayComponents day];
    
    if (startDay == endDay) {
        return;
    }
    
    if ([endDate isEqualToDate:theEndDate] == NO) {
        [endDate release];
        endDate = [theEndDate retain];
    }
}

// -------------------------------------------------------------------------------

- (NSString *) title {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    NSString *startDateString = [formatter stringFromDate:startDate];
    NSString *endDateString = [formatter stringFromDate:endDate];
    
    NSString *result = nil;
    
    if ([endDateString length] != 0) {
        result = [NSString stringWithFormat:@"%@ - %@", startDateString, endDateString];
    } else {
        result = [NSString stringWithFormat:@"%@", startDateString];
    }
    
    return result;
}

// -------------------------------------------------------------------------------

- (NSString *) titleForMonth {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MM.yyyy"];
    
    return [formatter stringFromDate:endDate];
}

// -------------------------------------------------------------------------------

@end
