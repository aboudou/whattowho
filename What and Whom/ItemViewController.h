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

@interface ItemViewController : DetailWrapperViewController <ABPeoplePickerNavigationControllerDelegate> {
    Data *data;
    
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) Data *data;

@property (nonatomic, retain) UIPopoverController *popoverController;

- (void)managePopover:(UIViewController *)controller frame:(CGRect)aFrame width:(float)aWidth height:(float)aHeight;

@end
