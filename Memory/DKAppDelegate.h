//
//  DKAppDelegate.h
//  Memory
//
//  Created by denis kotenko on 15.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"


extern NSString *const DKIndividualID;


@class CategoriesController;
@interface DKAppDelegate : UIResponder <UIApplicationDelegate> {
    
    UIWindow *_window;
    MGSplitViewController  *_splitController;
    UINavigationController *_navController;
    CategoriesController   *_viewController;
    
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) MGSplitViewController  *splitController;
@property (retain, nonatomic) UINavigationController *navController;
@property (retain, nonatomic) CategoriesController   *viewController;

- (UIViewController*)topController;

@end
