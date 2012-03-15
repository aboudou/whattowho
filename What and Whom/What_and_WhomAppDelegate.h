//
//  What_and_WhomAppDelegate.h
//  What and Whom
//
//  Created by Arnaud Boudou on 02/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemViewController.h"

@class RootViewController;

@interface What_and_WhomAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {

@private  
    // because ivars should be private, and it is really important
    // that all code always goes through the accessor methods to ensure that these
    // are properly initialized.  Without the funny __ then KVC might "help" us too much
    // With iCloud importing data asynchronously, there are more timing and multi-threading issues

    NSManagedObjectModel *managedObjectModel__;
    NSManagedObjectContext *managedObjectContext__;
    NSPersistentStoreCoordinator *persistentStoreCoordinator__;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, weak) IBOutlet UINavigationController *navigationController;
@property (nonatomic, weak) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, weak) IBOutlet RootViewController *rootViewController;
@property (nonatomic, weak) IBOutlet ItemViewController *detailViewController;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong ,readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSString *)applicationDocumentsDirectory;

- (void)resetStore;
- (void)resetiCloudSyncforCloudUrl:(NSURL*) cloudURL;

@end
