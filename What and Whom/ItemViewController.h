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
    
}

@property(nonatomic, retain) Data *data;

@end
