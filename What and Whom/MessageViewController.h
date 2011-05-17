//
//  MessageViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 17/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"
#import <MessageUI/MessageUI.h>

@interface MessageViewController : UITableViewController <MFMessageComposeViewControllerDelegate> {
    Data *data;
    NSMutableArray *_viewControllers;
}

@property(nonatomic, retain) Data *data;

@end
