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
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *photoBg;
    
    UIPopoverController *popoverController;

}

@property(nonatomic, retain) Data *data;
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UIButton *photoBg;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

-(IBAction) addButtonPressed:(id)sender;
-(IBAction) removeButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;

@end
