//
//  ObjectViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"
#import "Kal.h"

@interface ItemViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate> {
    Data *data;
    NSArray *_viewControllers;
    
    KalViewController *startKal;
    KalViewController *dueKal;
}

@property(nonatomic, retain) Data *data;

@end
