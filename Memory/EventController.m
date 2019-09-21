//
//  AddEventController.m
//  Memory
//
//  Created by denis kotenko on 24.01.12. 
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventController.h"
#import "DKObjectManager.h"
#import "MasterCategoriesController.h"


@implementation EventController

@synthesize category;
@synthesize event;
@synthesize addEventLabel;
@synthesize commentTextView;
@synthesize priceTextField;
@synthesize datePicker;

// -------------------------------------------------------------------------------

- (void) dealloc { 
    [category release];
    [event release];
    
    [addEventLabel   release];
    [commentTextView release];
    [priceTextField  release];
    [datePicker      release];
    
    [super dealloc];
}

// -------------------------------------------------------------------------------

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (id)initWithEvent:(Event *)_event {
    self = [super init];
    if (self == nil) {
        return self;
    }
    self.event = _event;
    isDublicate = YES;
    return self;
}

// -------------------------------------------------------------------------------

#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    //if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0) {
        self.datePicker.locale = [NSLocale currentLocale];
    //}
    
    
    //NSLog(@"self.datePicker.locale = %@", self.datePicker.locale);
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]
        initWithTitle:NSLocalizedString(@"Сохранить", @"Сохранить") style:UIBarButtonItemStylePlain
        target:self action:@selector(saveButtonHandler:)];
//    saveItem.tintColor = [UIColor darkGrayColor];
	self.navigationItem.rightBarButtonItem = saveItem;
	[saveItem release];
    
    self.commentTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.commentTextView.minNumberOfLines = 5;
    self.commentTextView.maxNumberOfLines = 5;
    self.commentTextView.font = [UIFont boldSystemFontOfSize:14];
    self.commentTextView.backgroundColor = [UIColor clearColor];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        addEventLabel.textColor = [UIColor darkTextColor];
        if (self.event != nil && isDublicate) {
            self.addEventLabel.text = NSLocalizedString(@"Повторить событие", @"Повторить событие");
            self.commentTextView.text = event.comment;
            self.priceTextField.text = [NSString stringWithFormat:@"%.2f", [event.price floatValue]];
            [self.datePicker setDate:[NSDate date]];
            self.event = nil;
        }
    } else {
        addEventLabel.textColor = [UIColor whiteColor];
    }
}

// -------------------------------------------------------------------------------

- (void) viewDidUnload {
    [self setAddEventLabel:nil];
    [self setCommentTextView:nil];
    [self setPriceTextField:nil];
    [self setDatePicker:nil];
    
    [super viewDidUnload];
}

// -------------------------------------------------------------------------------

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    if (isDublicate) {
        return;
    }
    
    if (event == nil) {
        self.addEventLabel.text = NSLocalizedString(@"Новое событие", @"Новое событие");
    }
    else {
        self.addEventLabel.text = NSLocalizedString(@"Изменить событие", @"Изменить событие");
        
        self.priceTextField.text = [NSString stringWithFormat:@"%.2f", [event.price floatValue]];
        self.commentTextView.text = event.comment;
        [self.datePicker setDate:event.date];
    }
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Helper Methods

- (void) setCategory:(EventsCategory *) theCategory {
    if ([category isEqual:theCategory] == NO) {
        [category release];
        category = [theCategory retain];
        
        self.navigationItem.title = category.name;
    }
}

// -------------------------------------------------------------------------------

- (void) setEvent:(Event *) theEvent {
    if ([event isEqual:theEvent] == NO) {
        [event release];
        event = [theEvent retain];
    }
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Action Methods

- (IBAction) saveButtonHandler:(id) sender {
    if (self.event == nil) {
        [[DKObjectManager sharedManager] createEventInCategory:category
            comment:self.commentTextView.text 
            price:[self.priceTextField.text floatValue] 
            date:self.datePicker.date];
    }
    else {
        self.event.price = [NSNumber numberWithFloat:[self.priceTextField.text floatValue]];
        self.event.comment = self.commentTextView.text;
        self.event.date = self.datePicker.date;
        
        [[DKObjectManager sharedManager] reorderCategories];
    }
    
    //
    UINavigationController *detailNav = (UINavigationController *) appDelegate.splitController.masterViewController;
    [detailNav popToRootViewControllerAnimated:YES];
    MasterCategoriesController *viewController = (MasterCategoriesController *) [detailNav.viewControllers objectAtIndex:0];
    [viewController reloadData];
    //
    //NSLog(@"saveButtonHandler");
    [self.navigationController popViewControllerAnimated:YES];
    
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

// -------------------------------------------------------------------------------

@end
