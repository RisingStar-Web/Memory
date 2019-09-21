//
//  InfoObject.h
//  Memory
//
//  Created by denis kotenko on 08.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InfoObject : NSObject {
    
    NSDate *startDate;
    NSDate *endDate;
    CGFloat price;
    
}

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, assign) CGFloat price;

- (NSString *) title;
- (NSString *) titleForMonth;

@end
