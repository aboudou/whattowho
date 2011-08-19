//
//  DetailWrapperViewController.h
//  What and Whom
//
//  Created by Boudou Arnaud on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailWrapperViewController : UITableViewController {
    NSMutableArray *_viewControllers;

    UINavigationItem *navItem;
}

@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;

@end
