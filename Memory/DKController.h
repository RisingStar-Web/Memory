//
//  DKController.h
//  Memory
//
//  Created by denis kotenko on 15.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKAppDelegate.h"


@interface DKController : UIViewController <UISplitViewControllerDelegate> {
    
    DKAppDelegate *appDelegate;
    IBOutlet UIImageView *backgroundView;
    
}

@end
