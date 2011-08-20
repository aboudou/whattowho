//
//  IDPhotoViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 04/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface IDPhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>{
    Data *data;
}

@property (nonatomic, retain) Data *data;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *photoBg;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

-(IBAction) addButtonPressed:(id)sender;
-(IBAction) removeButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;

@end
