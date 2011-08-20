//
//  MessageViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 17/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Data.h"
#import "ItemViewController.h"

@interface MessageViewController : UITableViewController <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate> {
    Data *data;
    NSMutableArray *_viewControllers;
}

@property(nonatomic, retain) Data *data;
@property (nonatomic, retain) ItemViewController *parentView;

@end
