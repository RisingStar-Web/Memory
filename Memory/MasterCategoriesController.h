//
//  MasterCategoriesController.h
//  Memory
//
//  Created by denis kotenko on 18.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriesController.h"


@interface MasterCategoriesController : CategoriesController {
    
    NSIndexPath *selectedIndexPath;
    
    
}

@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@end
