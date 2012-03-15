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

@private  
    // because ivars should be private, and it is really important
    // that all code always goes through the accessor methods to ensure that these
    // are properly initialized.  Without the funny __ then KVC might "help" us too much
    // With iCloud importing data asynchronously, there are more timing and multi-threading issues
    NSFetchedResultsController *fetchedResultsController__ ;
    NSManagedObjectContext *managedObjectContext__;
}

@property (nonatomic, weak) IBOutlet ItemViewController *detailViewController;
@property (nonatomic, weak) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIBarButtonItem *rootPopoverButtonItem;

@property (nonatomic, assign) BOOL afterFetch;

@end
