//
//  IDNotesViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 09/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface IDNotesViewController : UIViewController {
    Data *data;
    IBOutlet UITextView *notesTextView;
}

@property(nonatomic, retain) Data *data;
@property(nonatomic, retain) UITextView *notesTextView;

@end
