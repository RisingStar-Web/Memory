//
//  DKViewController.h
//  Memory
//
//  Created by denis kotenko on 15.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DKController.h"
#import "EventsCategory.h"


@interface CategoriesController : DKController 
    <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    
    NSMutableArray *tableData;
    EventsCategory *editedCategory;
        NSString *selectedIndex;
        BOOL isNew;
        
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *tableData;
@property (retain, nonatomic) NSString *selectedIndex;

- (void) reloadData;
- (void) showAlertIfNeeded;

- (IBAction) addButtonHandler:(id) sender;

@end
