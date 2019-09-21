//
//  DKAppDelegate.m
//  Memory
//
//  Created by denis kotenko on 15.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKAppDelegate.h"
#import "CategoriesController.h"
#import "MasterCategoriesController.h"
#import "EventsController.h"
#import "DKObjectManager.h"


NSString *const DKIndividualID = @"WWJQK996S9";


@implementation DKAppDelegate

@synthesize window = _window;
@synthesize splitController = _splitController;
@synthesize navController   = _navController;
@synthesize viewController  = _viewController;

// -------------------------------------------------------------------------------

- (void) dealloc {
    [_window release];
    [_splitController release];
    [_navController   release];
    [_viewController  release];
    
    [super dealloc];
}

// -------------------------------------------------------------------------------

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    UIColor *color = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? [UIColor blueColor] : [UIColor colorWithCGColor:kNavigationBarColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[CategoriesController alloc] init] autorelease];
        self.navController  = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
        self.navController.navigationBar.tintColor = color;
        [self.navController.navigationBar setTranslucent:NO];
        self.window.rootViewController = self.navController;
    } 
    else {
        self.splitController = [[MGSplitViewController alloc] init];
        self.splitController.showsMasterInPortrait = YES;
        self.splitController.showsMasterInLandscape = YES;
        
        MasterCategoriesController *master = [[[MasterCategoriesController alloc] init] autorelease];
        UINavigationController *masterNav = [[[UINavigationController alloc] initWithRootViewController:master] autorelease];
        masterNav.navigationBar.tintColor = color;//[UIColor colorWithCGColor:kNavigationBarColor];
        [masterNav.navigationBar setTranslucent:NO];
        
        EventsController *detail = [[[EventsController alloc] init] autorelease];
        UINavigationController *detailNav = [[[UINavigationController alloc] initWithRootViewController:detail] autorelease];
        detailNav.navigationBar.tintColor = color;//[UIColor colorWithCGColor:kNavigationBarColor];
        [detailNav.navigationBar setTranslucent:NO];
        
        self.splitController.viewControllers = [NSArray arrayWithObjects:masterNav, detailNav, nil];
        self.window.rootViewController = self.splitController;
    }

    [[UIApplication sharedApplication] 
        setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    [DKObjectManager sharedManager];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UIViewController*)topController {
    return self.window.rootViewController;
}
// -------------------------------------------------------------------------------

- (void) applicationWillResignActive:(UIApplication *) application {
//    [[[DKObjectManager sharedManager] objectStore] save];
}

// -------------------------------------------------------------------------------

- (void) applicationDidEnterBackground:(UIApplication *) application {
//    [[[DKObjectManager sharedManager] objectStore] save];
}

// -------------------------------------------------------------------------------

- (void) applicationWillEnterForeground:(UIApplication *) application {
//    [[[DKObjectManager sharedManager] objectStore] save];
}

// -------------------------------------------------------------------------------

- (void) applicationDidBecomeActive:(UIApplication *) application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

// -------------------------------------------------------------------------------

- (void) applicationWillTerminate:(UIApplication *) application {
//    [[[DKObjectManager sharedManager] objectStore] save];
}

// -------------------------------------------------------------------------------

@end
