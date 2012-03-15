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

}

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *photoBg;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) Data *data;

-(IBAction) addButtonPressed:(id)sender;
-(IBAction) removeButtonPressed:(id)sender;
-(IBAction) doneButtonPressed:(id)sender;

@end
