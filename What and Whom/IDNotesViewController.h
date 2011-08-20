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
    Data *data;
}

@property (nonatomic, retain) Data *data;
@property (nonatomic, retain) IBOutlet UITextView *notesTextView;
@property (nonatomic, retain) ItemViewController *parentView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

-(IBAction) doneButtonPressed:(id)sender;

@end
