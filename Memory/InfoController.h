//
//  InfoController.h
//  Memory
//
//  Created by denis kotenko on 08.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKController.h"
#import "EventsCategory.h"
#import "Event.h"
#import "InfoObject.h"


typedef enum {
    InfoFilterByMonthes = 0,
    InfoFilterByWeeks,
    InfoFilterByDeys,
} InfoFilter;


@interface InfoController : DKController 
    <UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *sortedEvents;
    NSArray *tableData;
    EventsCategory *category;
    InfoFilter filter;
        
}

@property (nonatomic, retain) EventsCategory *category;
@property (retain, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (retain, nonatomic) IBOutlet UIView *container;
@property (retain, nonatomic) IBOutlet UITableView *tableView;


@end
