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
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *removeButton;
}

@property(nonatomic, retain) Data *data;
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UIButton *photoBg;
@property(nonatomic, retain) UIButton *addButton;
@property(nonatomic, retain) UIButton *removeButton;

-(IBAction) addButtonPressed:(id)sender;
-(IBAction) removeButtonPressed:(id)sender;

@end
