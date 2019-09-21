//
//  InfoController.m
//  Memory
//
//  Created by denis kotenko on 08.02.12. 
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoController.h"


@interface InfoController (PrivateMethods)

- (void) reloadData;

@end


@implementation InfoController

@synthesize category;
@synthesize totalPriceLabel;
@synthesize segmentedControl;
@synthesize container;
@synthesize tableView;

// -------------------------------------------------------------------------------

- (void) dealloc {
    [category         release];
    [totalPriceLabel  release];
    [segmentedControl release];
    [container        release];
    [tableView        release];
    [sortedEvents     release];

    [super dealloc];
}

// -------------------------------------------------------------------------------

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// -------------------------------------------------------------------------------

#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? [UIColor colorWithCGColor:kSegmentedControlColor7] : [UIColor colorWithCGColor:kSegmentedControlColor];
    [self.segmentedControl setTintColor:color];
    [self.segmentedControl setTitle:NSLocalizedString(@"По месяцам", @"По месяцам") forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLocalizedString(@"По неделям", @"По неделям") forSegmentAtIndex:1];
    [self.segmentedControl setTitle:NSLocalizedString(@"По дням", @"По дням") forSegmentAtIndex:2];
    [self.segmentedControl addTarget:self action:@selector(filterButtonHandler:)
        forControlEvents:UIControlEventValueChanged];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        totalPriceLabel.textColor = [UIColor darkTextColor];
    } else {
        totalPriceLabel.textColor = [UIColor whiteColor];
    }
}

// -------------------------------------------------------------------------------

- (void) viewDidUnload {
    [self setTotalPriceLabel:nil];
    [self setSegmentedControl:nil];
    [self setContainer:nil];
    [self setTableView:nil];
    
    [super viewDidUnload];
}

// -------------------------------------------------------------------------------

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Action Methods

- (IBAction) filterButtonHandler:(id) sender {
    filter = self.segmentedControl.selectedSegmentIndex;
    [self reloadData];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Helper Methods

- (void) setCategory:(EventsCategory *) theCategory {
    if ([category isEqual:theCategory] == NO) {
        [category release];
        category = [theCategory retain];
        
        self.navigationItem.title = category.name;
        
        NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        sortedEvents = [[[category events] sortedArrayUsingDescriptors:[NSArray arrayWithObject:desc]] retain];
        [desc release];
    }
}

// -------------------------------------------------------------------------------

- (NSDate *) addDays:(NSInteger) days toDate:(NSDate *) date {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:days];
    
    NSDate *resultDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    return resultDate;
}

// -------------------------------------------------------------------------------

- (NSDate *) firstMonthDateFromDate:(NSDate *) date {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:date];
    NSInteger day = dayComponents.day - 1;
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:-day];
    
    NSDate *firstMonthDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
        fromDate:firstMonthDate];
    firstMonthDate = [gregorian dateFromComponents:components];
    
    [componentsToSubtract release];
    return firstMonthDate;
}

// -------------------------------------------------------------------------------

- (NSDate *) lastMonthDateFromFirstMonthDate:(NSDate *) firstMonthDate {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setMonth:1];
    
    NSDate *lastMonthDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:firstMonthDate options:0];
    
    [componentsToSubtract release];
    return lastMonthDate;
}

// -------------------------------------------------------------------------------

- (NSDate *) firstWeekDateFromDate:(NSDate *) date {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger weekday = [weekdayComponents weekday];
    NSInteger day = (((weekday - [gregorian firstWeekday]) + 7 ) % 7);
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:-day];
    
    NSDate *firstWeekDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
        fromDate:firstWeekDate];
    firstWeekDate = [gregorian dateFromComponents:components];
    
    [componentsToSubtract release];
    return firstWeekDate;
}

// -------------------------------------------------------------------------------

- (NSDate *) lastWeekDateFromFirstWeekDate:(NSDate *) date {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:7];
    
    NSDate *lastWeekDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    [componentsToSubtract release];
    return lastWeekDate;
}

// -------------------------------------------------------------------------------

- (NSDate *) startDayDateFromDate:(NSDate *) date {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
        fromDate:date];
    NSDate *startDayDate = [gregorian dateFromComponents:components];
    
    return startDayDate;
}

// -------------------------------------------------------------------------------

- (NSDate *) endDayDateFromStartDayDate:(NSDate *) startDayDate {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setHour:24];
    
    NSDate *endDayDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:startDayDate options:0];
    
    [componentsToSubtract release];
    return endDayDate;
}

// -------------------------------------------------------------------------------

- (NSMutableArray *) infoObjectsWithStartSelector:(SEL) startSelector endSelector:(SEL) endSelector {
    Event *firstEvent = [sortedEvents objectAtIndex:0];
    NSMutableArray *info = [[NSMutableArray alloc] init];
    
    NSDate *startDate = [self performSelector:startSelector withObject:firstEvent.date];
    NSDate *endDate = [self performSelector:endSelector withObject:startDate];
                       
    
    InfoObject *infoObject = [[[InfoObject alloc] init] autorelease];
    infoObject.startDate = startDate;
    infoObject.endDate = [self addDays:-1 toDate:endDate];
    
    for (Event *event in sortedEvents) {
        NSComparisonResult startCompareResult = [event.date compare:startDate];
        NSComparisonResult endCompareResult = [event.date compare:endDate];
        
        if (startCompareResult == NSOrderedDescending &&
            (endCompareResult == NSOrderedSame || endCompareResult == NSOrderedAscending)) {
            
            infoObject.price += [event.price floatValue];
        } else {
            [info addObject:infoObject];
            
            startDate = [self performSelector:startSelector withObject:event.date];
            endDate = [self performSelector:endSelector withObject:startDate];
            
            infoObject = [[[InfoObject alloc] init] autorelease];
            infoObject.startDate = startDate;
            infoObject.endDate = [self addDays:-1 toDate:endDate];
            
            infoObject.price += [event.price floatValue];
        }
    }
    
    [info addObject:infoObject];
    return [info autorelease];
}

// -------------------------------------------------------------------------------

- (void) reloadData {
    if ([sortedEvents count] == 0) {
        return;
    }
    
    NSMutableArray *info = nil;
    
    SEL startSelector = nil;
    SEL endSelector = nil;
    
    switch (filter) {
        case InfoFilterByMonthes: {
            startSelector = @selector(firstMonthDateFromDate:);
            endSelector = @selector(lastMonthDateFromFirstMonthDate:);
        } break;
            
        case InfoFilterByWeeks: {
            startSelector = @selector(firstWeekDateFromDate:);
            endSelector = @selector(lastWeekDateFromFirstWeekDate:);
        } break;
            
        case InfoFilterByDeys: {
            startSelector = @selector(startDayDateFromDate:);
            endSelector = @selector(endDayDateFromStartDayDate:);
        } break;
            
        default: {
        } break;
    }
    
    info = [self infoObjectsWithStartSelector:startSelector endSelector:endSelector];
    
    [tableData release];
    tableData = [[NSArray arrayWithArray:info] retain];
    
    [self.tableView reloadData];

    
    CGFloat totalPrice = 0;
    for (Event *event in sortedEvents) {
        totalPrice += [event.price floatValue];
    }
    
    NSString *totalPriceFormat = NSLocalizedString(@"Сумма: %.2f", @"Сумма: %.2f");
    self.totalPriceLabel.text = [NSString stringWithFormat:totalPriceFormat, totalPrice];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (UITableViewCell *) tableView:(UITableView *) theTableView
    cellForRowAtIndexPath:(NSIndexPath *) theIndexPath {
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] 
            initWithStyle:UITableViewCellStyleValue1 
            reuseIdentifier:@"cell"] autorelease];
        
        cell.textLabel.textColor = [UIColor colorWithCGColor:kGeneralTextColor];
        cell.textLabel.highlightedTextColor = [UIColor colorWithCGColor:kGeneralHighlightedTextColor];
        cell.textLabel.font = [UIFont fontWithName:GeneralBoldFontName size:TableViewTextLabelFontSize];
        
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
    
    InfoObject *info = [tableData objectAtIndex:indexPath.row];
    
    if (filter == InfoFilterByMonthes) {
        cell.textLabel.text = [info titleForMonth];
    } else {
        cell.textLabel.text = [info title];
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", info.price];
}

// -------------------------------------------------------------------------------

- (void) tableView:(UITableView *) theTableView 
    didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
}

// -------------------------------------------------------------------------------

@end
