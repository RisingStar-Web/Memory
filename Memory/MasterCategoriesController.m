//
//  MasterCategoriesController.m
//  Memory
//
//  Created by denis kotenko on 18.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterCategoriesController.h"
#import "EventsController.h"

#import "DKObjectManager.h"
#import "EventsCategory.h"


@implementation MasterCategoriesController

@synthesize selectedIndexPath;

// -------------------------------------------------------------------------------

- (void) dealloc {
    [selectedIndexPath release];
    
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
}

// -------------------------------------------------------------------------------

- (void) viewDidUnload {
    [super viewDidUnload];
}

// -------------------------------------------------------------------------------

//- (void) viewWillAppear:(BOOL) animated {
//    [self reloadData];
////    [self showAlertIfNeeded];
//}

// -------------------------------------------------------------------------------

- (void) reloadData {
    [super reloadData];
    self.selectedIndexPath = nil;
    
    UINavigationController *detailNav = (UINavigationController *) appDelegate.splitController.detailViewController;
    EventsController *viewController = (EventsController *) [detailNav.viewControllers objectAtIndex:0];
    
    if ([self.tableData count] != 0) {
        [viewController addNavBarButtons];
    } else {
        [viewController removeNavBarButtons];
    }
    
//    if ([self.tableData count] != 0 && self.selectedIndexPath == nil) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
//    }
    
//    for (int i = 0 ; i<[self.tableData count]; i++) {
//        EventsCategory *category = [self.tableData objectAtIndex:i];
//        if ([category.categoryId isEqualToString:selectedIndex]) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
//        }
//    }
    //NSLog(@"self.tableData = %@", self.tableData);
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void) tableView:(UITableView *) theTableView
   willDisplayCell:(UITableViewCell *) cell
 forRowAtIndexPath:(NSIndexPath *) indexPath {
    [super tableView:theTableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (void) tableView:(UITableView *) theTableView
    didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    
    self.selectedIndexPath = indexPath;
    UINavigationController *detailNav = (UINavigationController *) appDelegate.splitController.detailViewController;
    [detailNav popToRootViewControllerAnimated:YES];
    EventsController *viewController = (EventsController *) [detailNav.viewControllers objectAtIndex:0];
    
    viewController.category = [self.tableData objectAtIndex:indexPath.row];
    
    self.selectedIndex = viewController.category.categoryId;

    //NSLog(@"selectedIndex--> %@", self.selectedIndex);
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
        
        if ([self.tableData count] == 0) {
            self.selectedIndexPath = nil;
            
            UINavigationController *detailNav = (UINavigationController *) appDelegate.splitController.detailViewController;
            EventsController *viewController = (EventsController *) [detailNav.viewControllers objectAtIndex:0];
            
            viewController.category = nil;
        }
    }
}

// -------------------------------------------------------------------------------

@end
