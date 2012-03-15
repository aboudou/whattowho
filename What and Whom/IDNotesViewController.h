//
//  IDNotesViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 09/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"
#import "ItemViewController.h"

@interface IDNotesViewController : UIViewController {

}

@property (nonatomic, weak) IBOutlet UITextView *notesTextView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) Data *data;
@property (nonatomic, strong) ItemViewController *parentView;

-(IBAction) doneButtonPressed:(id)sender;

@end
