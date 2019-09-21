//
//  DKViewController.m
//  Memory
//
//  Created by denis kotenko on 15.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriesController.h"
#import "EventsController.h"

#import "DKObjectManager.h"
#import "DKManagedObjectStore.h"
#import "EventsCategory.h"

#import "Constants.h"
#import "SVProgressHUD.h"

@implementation CategoriesController

@synthesize tableView;
@synthesize tableData;
@synthesize selectedIndex;

// -------------------------------------------------------------------------------

- (void) dealloc {
    [tableView release];
    [tableData release];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefetchAllDatabaseData" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshAllViews" object:nil];
    [super dealloc];
}

// -------------------------------------------------------------------------------

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

// -------------------------------------------------------------------------------

#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    isNew = NO;
    
    self.title = NSLocalizedString(@"Дневник", @"Дневник");

//    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]
//        initWithTitle:NSLocalizedString(@"Изменить", @"Изменить") style:UIBarButtonItemStylePlain
//        target:self action:@selector(editButtonHandler:)];
////    editItem.tintColor = [UIColor darkGrayColor];
//    //[editItem set]
//	self.navigationItem.leftBarButtonItem = editItem;
//	[editItem release];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
        target:self action:@selector(addButtonHandler:)];
//    addItem.tintColor = [UIColor darkGrayColor];
	self.navigationItem.rightBarButtonItem = addItem;
	[addItem release];
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(reloadData)
//     name:@"RefetchAllDatabaseData"
//     object:nil];
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(reloadData)
//     name:@"RefreshAllViews"
//     object:nil];
}

// -------------------------------------------------------------------------------

- (void) viewDidUnload {
    [self setTableView:nil];
    
    [super viewDidUnload];
}

// -------------------------------------------------------------------------------

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];

    [self reloadData];
  //  [SVProgressHUD show];
//    [self showAlertIfNeeded];
}

// -------------------------------------------------------------------------------

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
}

// -------------------------------------------------------------------------------

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

// -------------------------------------------------------------------------------

- (void) viewDidDisappear:(BOOL) animated {
	[super viewDidDisappear:animated];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Helper Methods

- (void) showAlertIfNeeded {
    BOOL showAlert = NO;
    if ([self.tableData count] == 0) {
        showAlert = YES;
    } else {
        NSInteger events = 0;
        for (EventsCategory *category in self.tableData) {
            events += [category.events count];
        }
        
        if (events == 0) {
            showAlert = YES;
        }
    }
    
    if (showAlert) {
        UIAlertView *alertView = [[UIAlertView alloc] 
            initWithTitle:NSLocalizedString(@"У вас нет ни одного события", @"У вас нет ни одного события") 
            message:nil 
            delegate:nil
            cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
            otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

// -------------------------------------------------------------------------------

- (void) reloadData {
    self.tableData = [NSMutableArray arrayWithArray:[[DKObjectManager sharedManager] allCategoriesByOrderAndDate]];
    
   // NSLog(@"tableData = %@", self.tableData);
//    for (EventsCategory *tm in self.tableData) {
//        NSLog(@"tm = %@", tm.events);
//    }
    
    for (int i = [self.tableData count]-1; i>=0; i--) {
        EventsCategory *tm = [self.tableData objectAtIndex:[self.tableData count]-1];
        if ([tm.events count]) {
            break;
        }
        //NSLog(@"in = %@", [self.tableData objectAtIndex:[self.tableData count]-1]);
        [self.tableData insertObject:[self.tableData objectAtIndex:[self.tableData count]-1] atIndex:0];
        [self.tableData removeObjectAtIndex:[self.tableData count]-1];
    }
    
//    if ([self.tableData count]) {
//        UIBarButtonItem *editItem = [[UIBarButtonItem alloc]
//                                     initWithTitle:NSLocalizedString(@"Изменить", @"Изменить") style:UIBarButtonItemStylePlain
//                                     target:self action:@selector(editButtonHandler:)];
//        //    editItem.tintColor = [UIColor darkGrayColor];
//        //[editItem set]
//        self.navigationItem.leftBarButtonItem = editItem;
//        [editItem release];
//    }else{
//        self.navigationItem.leftBarButtonItem = nil;
//        [self.tableView setEditing:NO animated:YES];
//    }
    [self.tableView reloadData];
    
    if (isNew) {
        if ([self.tableData count]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
    }else{
        for (int i = 0 ; i<[self.tableData count]; i++) {
            EventsCategory *category = [self.tableData objectAtIndex:i];
            if ([category.categoryId isEqualToString:selectedIndex]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            }
        }
    }
   
    
    
    
    isNew = NO;
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Action Methods

- (IBAction) addButtonHandler:(id) sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Название раздела", @"Название раздела")
                              message:@" "
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Отмена", @"Отмена")
                              otherButtonTitles:NSLocalizedString(@"ОК", @"ОК"), nil];
    alertView.tag = 100;
    UITextField *textField = nil;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        textField = [alertView textFieldAtIndex:0];
    } else {
        textField = [[[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 30)] autorelease];
        textField.tag = 200;
        [alertView addSubview:textField];
    }
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    [alertView show];
    [alertView release];
    
    [textField becomeFirstResponder];
}

// -------------------------------------------------------------------------------

- (IBAction) editButtonHandler:(id) sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing == NO) {
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.3f];
    }
    
    NSString *title = self.tableView.editing ? 
        NSLocalizedString(@"Готово", @"Готово") :
        NSLocalizedString(@"Изменить", @"Изменить");
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
        initWithTitle:title style:UIBarButtonItemStylePlain
        target:self action:@selector(editButtonHandler:)];
//    item.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
}

// -------------------------------------------------------------------------------

- (void) cellDoubleTapHandler:(UITapGestureRecognizer *) sender {     
    if (sender.state == UIGestureRecognizerStateEnded) {    
        UIAlertView *alertView = [[UIAlertView alloc] 
            initWithTitle:NSLocalizedString(@"Изменить название раздела", @"Изменить название раздела") 
            message:@" " 
            delegate:self 
            cancelButtonTitle:NSLocalizedString(@"Отмена", @"Отмена") 
            otherButtonTitles:NSLocalizedString(@"ОК", @"ОК"), nil];
        alertView.tag = 101;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *) sender.view];
        editedCategory = [self.tableData objectAtIndex:indexPath.row];
        
        UITextField *textField = nil;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            textField = [alertView textFieldAtIndex:0];
        } else {
            textField = [[[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 30)] autorelease];
            textField.tag = 200;
            [alertView addSubview:textField];
        }
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField.text = editedCategory.name;
        
        [alertView show];
        [alertView release];
        
        [textField becomeFirstResponder];
    } 
}

// -------------------------------------------------------------------------------

- (void) cellLongPressHandler:(UILongPressGestureRecognizer *) sender {
    if (editedCategory != nil) {
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] 
        initWithTitle:NSLocalizedString(@"Изменить название раздела", @"Изменить название раздела") 
        message:@" " 
        delegate:self 
        cancelButtonTitle:NSLocalizedString(@"Отмена", @"Отмена") 
        otherButtonTitles:NSLocalizedString(@"ОК", @"ОК"), nil];
    alertView.tag = 101;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *) sender.view];
    editedCategory = [self.tableData objectAtIndex:indexPath.row];
    
    UITextField *textField = nil;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        textField = [alertView textFieldAtIndex:0];
    } else {
        textField = [[[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 30)] autorelease];
        textField.tag = 200;
        [alertView addSubview:textField];
    }
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    textField.text = editedCategory.name;
    [alertView show];
    [alertView release];
    
    [textField becomeFirstResponder]; 
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
    switch (buttonIndex) {
        case 0: {
            editedCategory = nil;
        } break;
            
        case 1: {
            UITextField *field = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? [alertView textFieldAtIndex:0] :
                        (UITextField *) [alertView viewWithTag:200];
            NSString *categoryName = [field.text
                stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if ([categoryName length] != 0 && alertView.tag == 100) {
                [[DKObjectManager sharedManager] createCategoryWithName:categoryName];
                isNew = YES;
                [self reloadData];
            } 
            else if ([categoryName length] != 0 && alertView.tag == 101) {
                editedCategory.name = categoryName;
                [[DKObjectManager sharedManager].objectStore save];
                [self reloadData];
                editedCategory = nil;
            }
        } break;
            
        default:
            break;
    }
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
        
        cell.textLabel.textColor = [UIColor colorWithCGColor:kGeneralTextColor];
        UIColor *color =  [UIColor colorWithCGColor:kGeneralHighlightedTextColor];
        if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            color = [UIColor darkTextColor];
        }

        cell.textLabel.highlightedTextColor = color;
        cell.textLabel.font = [UIFont fontWithName:GeneralBoldFontName size:TableViewTextLabelFontSize];
        
        cell.detailTextLabel.textColor = [UIColor colorWithCGColor:kDetailGeneralTextColor];
        color =  [UIColor colorWithCGColor:kDetailHighlightedTextColor];
        if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            color = [UIColor darkTextColor];
            cell.detailTextLabel.tintColor = [UIColor lightGrayColor];
        }
       cell.detailTextLabel.highlightedTextColor = color;
        cell.detailTextLabel.font = [UIFont fontWithName:GeneralFontName size:TableViewDetailTextLabelFontSize];
        
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] 
            initWithTarget:self action:@selector(cellLongPressHandler:)];
        longPressGesture.numberOfTouchesRequired = 1;
        longPressGesture.minimumPressDuration = 0.5f;
        [cell addGestureRecognizer:longPressGesture];
        [longPressGesture release];
        
//        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] 
//            initWithTarget:self action:@selector(cellDoubleTapHandler:)];
//        recognizer.numberOfTouchesRequired = 1;
//        recognizer.numberOfTapsRequired = 2;
//        recognizer.delaysTouchesBegan = NO;
//        recognizer.delaysTouchesEnded = YES;
//        [cell addGestureRecognizer:recognizer];
//        [recognizer release];
	}
	
    return cell;
}

// -------------------------------------------------------------------------------

- (NSInteger) tableView:(UITableView *) theTableView 
    numberOfRowsInSection:(NSInteger) section {
    
	return [self.tableData count];
}

// -------------------------------------------------------------------------------

- (BOOL) tableView:(UITableView *) theTableView 
    canMoveRowAtIndexPath:(NSIndexPath *) indexPath {
	
	return YES;
}

// -------------------------------------------------------------------------------

- (void) tableView:(UITableView *) theTableView 
    moveRowAtIndexPath:(NSIndexPath *) sourceIndexPath 
    toIndexPath:(NSIndexPath *) destinationIndexPath {
	
    EventsCategory *destinationCategory = [self.tableData objectAtIndex:destinationIndexPath.row];
    EventsCategory *sourceCategory = [self.tableData objectAtIndex:sourceIndexPath.row];
    sourceCategory.order = destinationCategory.order;
    
    if (sourceIndexPath.row < destinationIndexPath.row) {
        for (int i = sourceIndexPath.row + 1; i <= destinationIndexPath.row; i++) {
            EventsCategory *category = [self.tableData objectAtIndex:i];
            category.order = [NSNumber numberWithInt:[category.order intValue] - 1];
        }
    } 
    else {
        for (int i = sourceIndexPath.row - 1; i >= destinationIndexPath.row; i--) {
            EventsCategory *category = [self.tableData objectAtIndex:i];
            category.order = [NSNumber numberWithInt:[category.order intValue] + 1];  
        }
    }
    
    [[DKObjectManager sharedManager].objectStore save];
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void) tableView:(UITableView *) theTableView 
    willDisplayCell:(UITableViewCell *) cell 
    forRowAtIndexPath:(NSIndexPath *) indexPath {
    
    EventsCategory *category = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = category.name;
    cell.detailTextLabel.text = nil;

//    if ([cell.selectedBackgroundView isKindOfClass:[UIImageView class]] == NO) {
    NSString *selectedImageName = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? @"fon1pressed_7" : @"fon1pressed";
    NSString *imageName = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? @"fon1_7" : @"fon1";
    
    if ((indexPath.row + 1) % 2 == 0) {
        selectedImageName = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? @"fon2pressed_7" :  @"fon2pressed";
        imageName = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? @"fon2_7" : @"fon2";
    }
    
        UIImage *selectedBackgroundImage = [UIImage imageNamed:selectedImageName];
    if (UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() || IOS_VERSION_LESS_THAN(@"7")) {
        
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:selectedBackgroundImage] autorelease];
    }
    
        UIImage *backgroundImage = [UIImage imageNamed:imageName];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
//    }
    
    
    if ([category.events count] != 0) {
        Event *lastEvent = [category lastEvent];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy"];
        
        NSString *stringFromDate = [formatter stringFromDate:lastEvent.date];    
        [formatter release]; 
        
        CGFloat totalPrice = [category totalPrice];
        if (totalPrice != 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %.2f", stringFromDate, totalPrice];
        }
        else {
            cell.detailTextLabel.text = stringFromDate;
        }
    } 
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

// -------------------------------------------------------------------------------

- (void) tableView:(UITableView *) theTableView 
    didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EventsController *viewController = [[EventsController alloc] init];
    viewController.category = [self.tableData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

// -------------------------------------------------------------------------------

- (void) tableView:(UITableView *) theTableView
    commitEditingStyle:(UITableViewCellEditingStyle) theEditingStyle
    forRowAtIndexPath:(NSIndexPath *) theIndexPath {
    
    if (theEditingStyle == UITableViewCellEditingStyleDelete) {  
        EventsCategory *category = [tableData objectAtIndex:theIndexPath.row];
        [category deleteEntity];
        
        [[DKObjectManager sharedManager].objectStore save];
        
        [self.tableData removeObjectAtIndex:theIndexPath.row];
        //[theTableView reloadData];
        [self reloadData];
    }
}

// -------------------------------------------------------------------------------

- (NSString *) tableView:(UITableView *) tableView 
    titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    return NSLocalizedString(@"Удалить", @"Удалить");
}

// -------------------------------------------------------------------------------

@end
