//
//  ObjectViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"
#import "DetailWrapperViewController.h"

@interface ItemViewController : DetailWrapperViewController <ABPeoplePickerNavigationControllerDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate> {

}

@property (nonatomic, strong) Data *data;
@property (nonatomic, strong) UIPopoverController *popoverController;

@property (nonatomic, assign) CGRect contactButtonFrame;

- (void)managePopover:(UIViewController *)controller frame:(CGRect)aFrame width:(float)aWidth height:(float)aHeight;

@end
