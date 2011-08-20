//
//  IDItemViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 07/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"
#import "ItemViewController.h"

@interface IDItemViewController : UIViewController {
    Data *data;
}

@property (nonatomic, retain) Data *data;
@property (nonatomic, retain) IBOutlet UITextField *itemNameTextField;
@property (nonatomic, retain) ItemViewController *parentView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

-(IBAction) doneButtonPressed:(id)sender;

@end
