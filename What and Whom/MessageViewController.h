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
}

@property (nonatomic, strong) Data *data;
@property (nonatomic, strong) ItemViewController *parentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;


@end
