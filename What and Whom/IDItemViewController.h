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

}

@property (nonatomic, weak) IBOutlet UITextField *itemNameTextField;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) Data *data;
@property (nonatomic, strong) ItemViewController *parentView;

-(IBAction) doneButtonPressed:(id)sender;

@end
