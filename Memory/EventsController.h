//
//  EventsController.h
//  Memory
//
//  Created by denis kotenko on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKController.h"
#import "EventsCategory.h"
#import "Event.h"


typedef enum {
    EventsFilterTotal = 0,
    EventsFilterByMonth,
    EventsFilterByWeek,
} EventsFilter;


@interface EventsController : DKController
    <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *tableData;
    EventsCategory *category;
    EventsFilter filter;
    
    UIPopoverController *popover;
        
}

@property (nonatomic, retain) EventsCategory *category;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *datePeriodLabel;
@property (retain, nonatomic) IBOutlet UIButton *infoButton;
@property (retain, nonatomic) IBOutlet UIView *container;

- (void) addNavBarButtons;
- (void) removeNavBarButtons;

- (IBAction) addButtonHandler:(id) sender;
- (IBAction) infoButtonHandler:(id) sender;

@end
