//
//  RootViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 02/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "ItemViewController.h"

@interface RootViewController : UITableViewController <UISplitViewControllerDelegate, NSFetchedResultsControllerDelegate> {
    UISplitViewController *splitViewController;
    UIBarButtonItem *rootPopoverButtonItem;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet ItemViewController *detailViewController;


@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;

@end
