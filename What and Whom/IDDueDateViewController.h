//
//  IDDueDateViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 04/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"


@interface IDDueDateViewController : UIViewController {
    Data *data;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIButton *todayButton;
    IBOutlet UIButton *removeButton;
}

@property(nonatomic, retain) Data *data;
@property(nonatomic, retain) UIDatePicker *datePicker;
@property(nonatomic, retain) UIButton *todayButton;
@property(nonatomic, retain) UIButton *removeButton;

-(IBAction) todayButtonPressed:(id)sender;
-(IBAction) removeButtonPressed:(id)sender;

@end
