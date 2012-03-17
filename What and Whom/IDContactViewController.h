//
//  IDContactViewController.h
//  What and Whom
//
//  Created by Boudou Arnaud on 17/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"
#import "ItemViewController.h"

@interface IDContactViewController : UIViewController {
    
}


@property (nonatomic, weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) Data *data;
@property (nonatomic, strong) ItemViewController *parentView;

-(IBAction) doneButtonPressed:(id)sender;

@end
