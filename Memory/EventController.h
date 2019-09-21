//
//  AddEventController.h
//  Memory
//
//  Created by denis kotenko on 24.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DKController.h"
#import "HPGrowingTextView.h"
#import "EventsCategory.h"
#import "Event.h"


@interface EventController : DKController <UITextFieldDelegate> {
    
    EventsCategory *category;
    Event *event;
    BOOL isDublicate;
}

@property (nonatomic, retain) EventsCategory *category;
@property (nonatomic, retain) Event *event;

@property (retain, nonatomic) IBOutlet UILabel *addEventLabel;
@property (retain, nonatomic) IBOutlet HPGrowingTextView *commentTextView;
@property (retain, nonatomic) IBOutlet UITextField *priceTextField;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction) saveButtonHandler:(id) sender;
- (id)initWithEvent:(Event*)event;

@end
