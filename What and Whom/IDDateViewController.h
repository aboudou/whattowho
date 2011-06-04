//
//  IDDateViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 09/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface IDDateViewController : UIViewController {
    Data *data;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIButton *todayButton;
}

@property(nonatomic, retain) Data *data;
@property(nonatomic, retain) UIDatePicker *datePicker;
@property(nonatomic, retain) UIButton *todayButton;

-(IBAction) todayButtonPressed:(id)sender;

@end
