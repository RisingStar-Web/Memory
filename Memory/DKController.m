//
//  DKController.m
//  Memory
//
//  Created by denis kotenko on 15.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKController.h"
#import "DKObjectManager.h"


@implementation DKController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (nibNameOrNil == nil) {
        NSString *name = NSStringFromClass([self class]);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            name = [NSString stringWithFormat:@"%@~iphone", name];
        }
        nibNameOrNil = name;
    }
    NSString *fileName = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? [NSString stringWithFormat:@"%@7", nibNameOrNil] : nibNameOrNil;
    if([[NSBundle mainBundle] pathForResource:fileName ofType:@"nib"] != nil) {
        return [super initWithNibName:fileName bundle:nibBundleOrNil];
    }
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

// -------------------------------------------------------------------------------

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshAllViews" object:nil];
    [backgroundView release];
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
    
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] 
        initWithTitle:NSLocalizedString(@"Назад", @"Назад") 
        style:UIBarButtonItemStyleBordered target:nil action:nil];
//	backItem.tintColor = [UIColor darkGrayColor];
	self.navigationItem.backBarButtonItem = backItem;
	[backItem release];
    
    [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(reloadData) 
         name:@"RefreshAllViews" 
         object:nil];
    
    appDelegate = (DKAppDelegate *) [UIApplication sharedApplication].delegate;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        CGRect rect = backgroundView.frame;
        rect.size.height += 20;
        backgroundView.frame = rect;
        backgroundView.image = [UIImage imageNamed:@"Background_7.png"];
    }
}

// -------------------------------------------------------------------------------

- (void) viewDidUnload {
    [super viewDidUnload];
}

// -------------------------------------------------------------------------------

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
}

// -------------------------------------------------------------------------------

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || 
        UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark Helper Methods

- (void) reloadData {
    
}

// -------------------------------------------------------------------------------

#pragma mark -
#pragma mark UISplitViewControllerDelegate Methods

- (BOOL) splitViewController:(UISplitViewController *) svc 
    shouldHideViewController:(UIViewController *) vc 
    inOrientation:(UIInterfaceOrientation) orientation {
    
    return YES;
}

// -------------------------------------------------------------------------------

@end
