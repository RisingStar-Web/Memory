//
//  EventsController.m
//  Memory
//
//  Created by denis kotenko on 24.01.12. 
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventsController.h"
#import "EventController.h"
#import "InfoController.h"
#import "UIView.h"
#import "DKObjectManager.h"
#import "MasterCategoriesController.h"


@interface EventsController (PrivateMethods)

- (void) reloadData;

@end


@implementation EventsController

@synthesize category;
@synthesize segmentedControl;
@synthesize tableView;
@synthesize totalPriceLabel;
@synthesize datePeriodLabel;
@synthesize infoButton;
@synthesize container;

// -------------------------------------------------------------------------------

- (void) dealloc {
    [category         release];
    [segmentedControl release];
    [tableView        release];
    [tableData        release];
    [totalPriceLabel  release];
    [datePeriodLabel  release];
    [infoButton       release];
    [container        release];

    [super dealloc];
}

// -------------------------------------------------------------------------------

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// -------------------------------------------------------------------------------

- (void) addNavBarButtons {
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
        target:self action:@selector(addButtonHandler:)];
	self.navigationItem.rightBarButtonItem = addItem;
	[addItem release];
}

// -------------------------------------------------------------------------------

- (void) removeNavBarButtons {
    self.navigationItem.rightBarButtonItem = nil;
}

// -------------------------------------------------------------------------------

#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self addNavBarButtons];
    }
    
    UIColor *color = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? [UIColor colorWithCGColor:kSegmentedControlColor7] : [UIColor colorWithCGColor:kSegmentedControlColor];
    [self.segmentedControl setTintColor:color];
    [self.segmentedControl setTitle:NSLocalizedString(@"Общая", @"Общая") forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"Месяц", @"Месяц") forSegmentAtIndex:1];
    [self.segmentedControl setTitle:NSLocalizedString(@"Неделя", @"Неделя") forSegmentAtIndex:2];
    [self.segmentedControl addTarget:self action:@selector(filterButtonHandler:)
        forControlEvents:UIControlEventValueChanged];
    
    tableData = [[NSMutableArray alloc] init];
}

// -------------------------------------------------------------------------------

- (void) viewDidUnload {
    [self setSegmentedControl:nil];
    [self setTableView:nil];
    [self setTotalPriceLabel:nil];
    [self setDatePeriodLabel:nil];
    [self setInfoButton:nil];
    [self setContainer:nil];
    
    [super viewDidUnload];
}

// -------------------------------------------------------------------------------

- (void) setContainerHidden:(NSNumber *) hidden {
    CGRect frame = CGRectZero;
    CGPoint newCenter = CGPointZero;
    
    if ([hidden boolValue] == NO) {
        frame = CGRectMake(
            self.tableView.frameX, self.container.frameHeight, 
            self.tableView.frameWidth, self.tableView.frameHeight - (self.container.frameHeight)
        );
        [self.tableView frameTo:frame duration:0.5f delegate:nil didStopSelector:nil];
        
        newCenter = CGPointMake(self.container.frameWidth / 2, self.container.frameHeight / 2);
        [self.container moveTo:newCenter duration:0.5f delegate:nil didStopSelector:nil];
    }
    else {
        frame = CGRectMake(
            self.tableView.frameX, 0, 
            self.tableView.frameWidth, self.tableView.frameHeight + (self.container.frameHeight)
        );
        self.tableView.frame = frame;
        
        newCenter = CGPointMake(self.container.frameWidth / 2, -self.container.frameHeight / 2);
        self.container.center = newCenter;
    }
}

// -------------------------------------------------------------------------------

- (void) updateContainerPosition {    
    if ([self.category totalPrice] != 0 && self.container.frameY < 0) {
        [self performSelector:@selector(setContainerHidden:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.3f];
    } 
    else if ([self.category totalPrice] == 0 && self.container.frameY == 0) {
        [self setContainerHidden:[NSNumber numberWithBool:YES]];
    }
}

// -------------------------------------------------------------------------------

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    
    [self updateContainerPosition];
}

// -------------------------------------------------------------------------------

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

// -------------------------------------------------------------------------------

- (void) viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Helper Methods

- (void) setCategory:(EventsCategory *) theCategory {
    if ([category isEqual:theCategory] == NO) {
        [category release];
        category = [theCategory retain];
        
        self.navigationItem.title = category.name;
        
        [self reloadData];
        [self updateContainerPosition];
    }
}

// -------------------------------------------------------------------------------

- (void) reloadData {
    NSDateFormatter *formatter = nil;
    [tableData removeAllObjects];
    
    switch (filter) {
        case EventsFilterTotal: {
            [tableData addObjectsFromArray:[category events]];
        } break;
            
        case EventsFilterByMonth: {
            formatter = [[[NSDateFormatter alloc] init] autorelease];
            [formatter setDateFormat:@"MM"];
            
            NSInteger currentMonth = [[formatter stringFromDate:[NSDate date]] intValue];
        
            for (Event *event in [category events]) {
                NSInteger month = [[formatter stringFromDate:event.date] intValue];
                if (month == currentMonth) {
                    [tableData addObject:event];
                }
            }
        } break;
            
        case EventsFilterByWeek: {
            NSDate *today = [NSDate date];
            NSCalendar *gregorian = [NSCalendar currentCalendar];
            
            NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
            NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:today];
            
            NSInteger weekday = [weekdayComponents weekday];
            NSInteger day = -(((weekday - [gregorian firstWeekday]) + 7 ) % 7);
            [componentsToSubtract setDay:day];
            NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
            
            NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                fromDate: beginningOfWeek];
            beginningOfWeek = [gregorian dateFromComponents: components];
            
            [componentsToSubtract setDay:7];
            NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:beginningOfWeek options:0];
            [componentsToSubtract release];
            
            for (Event *event in [category events]) {
                NSComparisonResult beginningCompareResult = [event.date compare:beginningOfWeek];
                NSComparisonResult endCompareResult = [event.date compare:endOfWeek];
                
                if (beginningCompareResult == NSOrderedDescending &&
                    (endCompareResult == NSOrderedSame || endCompareResult == NSOrderedAscending)) {
                    
                    [tableData addObject:event];
                }
            }
        } break;
            
        default: {
        } break;
    }
    
    CGFloat totalPrice = 0;
    for (Event *event in tableData) {
        totalPrice += [event.price floatValue];
    }
    
    NSString *totalPriceFormat = NSLocalizedString(@"Сумма: %.2f", @"Сумма: %.2f");
    self.totalPriceLabel.text = [NSString stringWithFormat:totalPriceFormat, totalPrice];
    
    
    formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    if ([tableData count] != 0) {
        NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSArray *sortedData = [tableData sortedArrayUsingDescriptors:[NSArray arrayWithObject:desc]];
        [desc release];
        
        [tableData removeAllObjects];
        [tableData addObjectsFromArray:sortedData];
        
        Event *lastEvent = [tableData lastObject];
        NSString *startDate = [formatter stringFromDate:lastEvent.date]; 
        
        Event *firstEvent = [tableData objectAtIndex:0];
        NSString *endDate = [formatter stringFromDate:firstEvent.date]; 
        
        self.datePeriodLabel.text = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
    }
    
    [self.tableView reloadData];
    //NSLog(@"dfsfsdfs");
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Action Methods

- (IBAction) addButtonHandler:(id) sender {
    EventController *viewController = [[EventController alloc] init];
    viewController.category = self.category;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

// -------------------------------------------------------------------------------

- (IBAction) infoButtonHandler:(id) sender {
    InfoController *viewController = [[InfoController alloc] init];
    viewController.category = self.category;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

// -------------------------------------------------------------------------------

- (IBAction) filterButtonHandler:(id) sender {
    filter = self.segmentedControl.selectedSegmentIndex;
    [self reloadData];
}

// -------------------------------------------------------------------------------

- (void) accessoryButtonHandler:(UIControl *) button withEvent:(UIEvent *) event {
	CGPoint point = [[[event touchesForView:button] anyObject] locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
	
	if (indexPath == nil) return;
	
	[self.tableView.delegate tableView:self.tableView 
        accessoryButtonTappedForRowWithIndexPath:indexPath];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (UITableViewCell *) tableView:(UITableView *) theTableView
    cellForRowAtIndexPath:(NSIndexPath *) theIndexPath {
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] 
            initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:@"cell"] autorelease];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 24, 26);   
        button.backgroundColor = [UIColor clearColor];
        
        [button setBackgroundImage:[UIImage imageNamed:@"refresh_nl"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"refresh_hl"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(accessoryButtonHandler:withEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = button;
        
        cell.textLabel.textColor = [UIColor colorWithCGColor:kGeneralTextColor];
        cell.textLabel.highlightedTextColor = [UIColor colorWithCGColor:kGeneralHighlightedTextColor];
        cell.textLabel.font = [UIFont fontWithName:GeneralBoldFontName size:TableViewTextLabelFontSize];
        cell.textLabel.numberOfLines = 4;
        
        cell.detailTextLabel.textColor = [UIColor colorWithCGColor:kDetailGeneralTextColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor colorWithCGColor:kDetailHighlightedTextColor];
        cell.detailTextLabel.font = [UIFont fontWithName:GeneralFontName size:TableViewDetailTextLabelFontSize];
	}
    
    return cell;
}

// -------------------------------------------------------------------------------

- (NSInteger) tableView:(UITableView *) theTableView 
    numberOfRowsInSection:(NSInteger) section {
    
	return [tableData count];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (CGFloat) tableView:(UITableView *) theTableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    Event *event = [tableData objectAtIndex:indexPath.row];
    CGSize textSize = [event.comment sizeWithFont:[UIFont boldSystemFontOfSize:15.0] 
        constrainedToSize:CGSizeMake(theTableView.frameWidth - 100, 100)
        lineBreakMode:UILineBreakModeTailTruncation];
    
    if (textSize.height >= 38) {
        return textSize.height + 24;
    }
    return 46;
}

// -------------------------------------------------------------------------------

- (void) tableView:(UITableView *) tableView 
    willDisplayCell:(UITableViewCell *) cell 
    forRowAtIndexPath:(NSIndexPath *) indexPath {
    
    if ([cell.selectedBackgroundView isKindOfClass:[UIImageView class]] == NO) {
        NSString *selectedImageName = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? @"fon1pressed_7" : @"fon1pressed";
        NSString *imageName = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? @"fon1_7" : @"fon1";
        
        if ((indexPath.row + 1) % 2 == 0) {
            selectedImageName = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? @"fon2pressed_7" :  @"fon2pressed";
            imageName = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? @"fon2_7" : @"fon2";
        }
        
        UIImage *selectedBackgroundImage = [UIImage imageNamed:selectedImageName];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:selectedBackgroundImage] autorelease];
        
        UIImage *backgroundImage = [UIImage imageNamed:imageName];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
    }
    
    Event *event = [tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = event.comment;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:event.date];    
    [formatter release]; 
    
    if ([event.price floatValue] != 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %.2f", stringFromDate, [event.price floatValue]];
    }
    else {
        cell.detailTextLabel.text = stringFromDate;
    }
}

// -------------------------------------------------------------------------------

- (void) tableView:(UITableView *) theTableView 
    didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EventController *viewController = [[EventController alloc] init];
    viewController.category = self.category;
    viewController.event = [tableData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

// -------------------------------------------------------------------------------

- (void) tableView:(UITableView *) theTableView 
    accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *) theIndexPath {
	
    Event *event = [tableData objectAtIndex:theIndexPath.row];
    
    EventController *viewController = nil;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        viewController = [[EventController alloc] initWithEvent:event];
    } else {
        viewController = [[EventController alloc] init];
    }
    viewController.category = self.category;
    [self.navigationController pushViewController:viewController animated:YES];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        [viewController release];
        return;
    }
    viewController.addEventLabel.text = NSLocalizedString(@"Повторить событие", @"Повторить событие");
    viewController.commentTextView.text = event.comment;
    viewController.priceTextField.text = [NSString stringWithFormat:@"%.2f", [event.price floatValue]];
    [viewController.datePicker setDate:[NSDate date]];
    [viewController release];
}

// -------------------------------------------------------------------------------

- (void) tableView:(UITableView *) theTableView
    commitEditingStyle:(UITableViewCellEditingStyle) theEditingStyle
    forRowAtIndexPath:(NSIndexPath *) theIndexPath {
    
    if (theEditingStyle == UITableViewCellEditingStyleDelete) {  
        Event *event = [tableData objectAtIndex:theIndexPath.row];
        [event deleteEntity];
        
        NSArray *categories = [[DKObjectManager sharedManager] allCategoriesByDateAndOrder];
        for (int i = 0; i < [categories count]; i++) {
            EventsCategory *cat = [categories objectAtIndex:i];
            cat.order = [NSNumber numberWithInt:i + 1];
        }
        
        [[DKObjectManager sharedManager].objectStore save];
        
        [tableData removeObjectAtIndex:theIndexPath.row];
        [theTableView reloadData];
        
        //
        UINavigationController *detailNav = (UINavigationController *) appDelegate.splitController.masterViewController;
        [detailNav popToRootViewControllerAnimated:NO];
        MasterCategoriesController *viewController = (MasterCategoriesController *) [detailNav.viewControllers objectAtIndex:0];
        [viewController reloadData];
        //
    }
}

// -------------------------------------------------------------------------------

- (NSString *) tableView:(UITableView *) tableView 
    titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    return NSLocalizedString(@"Удалить", @"Удалить");
}

// -------------------------------------------------------------------------------

@end
