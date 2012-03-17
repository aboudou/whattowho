//
//  What_and_WhomAppDelegate.m
//  What and Whom
//
//  Created by Arnaud Boudou on 02/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "What_and_WhomAppDelegate.h"
#import "RootViewController.h"
#import "Macros.h"
#import "MBProgressHUD.h"

@implementation What_and_WhomAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;

@synthesize splitViewController = _splitViewController;
@synthesize rootViewController = _rootViewController;
@synthesize detailViewController = _detailViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.window.rootViewController = self.splitViewController;
        self.rootViewController.managedObjectContext = self.managedObjectContext;
    } else {
        self.window.rootViewController = self.navigationController;
        RootViewController *rootViewController = (RootViewController *)[self.navigationController topViewController];
        rootViewController.managedObjectContext = self.managedObjectContext;
    }
    [self.window makeKeyAndVisible];
    
    return YES;    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */

    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [self saveContext];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext__ != nil) {
        return managedObjectContext__;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

    if (coordinator != nil) {
        NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//        [moc setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        
        [moc performBlockAndWait:^{
            [moc setPersistentStoreCoordinator: coordinator];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mergeChangesFrom_iCloud:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:coordinator];
        }];
        managedObjectContext__ = moc;
        
    }

//    [__managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    return managedObjectContext__;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel__ != nil)
    {
        return managedObjectModel__;
    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"What_and_Whom" withExtension:@"momd"];
//    managedObjectModel__ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    managedObjectModel__ = [NSManagedObjectModel mergedModelFromBundles:nil];    

    return managedObjectModel__;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator__ != nil)
    {
        return persistentStoreCoordinator__;
    }
    
    persistentStoreCoordinator__ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    

    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"What_and_Whom.sqlite"];
    
    NSPersistentStoreCoordinator* psc = persistentStoreCoordinator__;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MBProgressHUD  showHUDAddedTo:self.window  animated:YES];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];

        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        
        // Migrate datamodel
        NSDictionary *options = nil;
        NSError *error = nil;

        // this needs to match the entitlements and provisioning profile
        NSURL *cloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];

#warning Modifier pour activer iCloud
//        NSString* coreDataCloudContent = [[cloudURL path] stringByAppendingPathComponent:@"data"];
        NSString* coreDataCloudContent = @"";
        
        if ([coreDataCloudContent length] != 0) {
            NSLog(@"iCloud enabled");
            cloudURL = [NSURL fileURLWithPath:coreDataCloudContent];

            options = [NSDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                       [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                       @"whatAndWhom.store", NSPersistentStoreUbiquitousContentNameKey,
                       cloudURL, NSPersistentStoreUbiquitousContentURLKey,
                       nil];
        } else {
            NSLog(@"iCloud disabled");
            options = [NSDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                       [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                       nil];
        }
        
        [psc lock];
        NSLog(@"Avant ajout du store");
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            [MBProgressHUD hideHUDForView:self.window animated:YES];
            [self resetiCloudSyncforCloudUrl:cloudURL];
        } else {
            NSLog(@"Après ajout du store");
            [psc unlock];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"asynchronously added persistent store!");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefetchAllDatabaseData" object:self userInfo:nil];
                [MBProgressHUD hideHUDForView:self.window animated:YES];
            });
        }

    });
    
    return persistentStoreCoordinator__;
}

#pragma mark - Application's Documents directory

/**
 Returns the path to the application's documents directory
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark - Gestion notifications iCloud
- (void)mergeiCloudChanges:(NSNotification*)note forContext:(NSManagedObjectContext*)moc {
    [moc mergeChangesFromContextDidSaveNotification:note]; 
    
//    NSNotification* refreshNotification = [NSNotification notificationWithName:@"RefreshAllViews" object:self  userInfo:[note userInfo]];
//    [[NSNotificationCenter defaultCenter] postNotification:refreshNotification];

    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefetchAllDatabaseData" object:self userInfo:nil];
    NSNotification* refreshNotification = [NSNotification notificationWithName:@"RefetchAllDatabaseData" object:self  userInfo:[note userInfo]];
    [[NSNotificationCenter defaultCenter] postNotification:refreshNotification];
    
}

// NSNotifications are posted synchronously on the caller's thread
// make sure to vector this back to the thread we want, in this case
// the main thread for our views & controller
- (void)mergeChangesFrom_iCloud:(NSNotification *)notification {
	NSManagedObjectContext* moc = [self managedObjectContext];
    
    // this only works if you used NSMainQueueConcurrencyType
    // otherwise use a dispatch_async back to the main thread yourself
    [moc performBlock:^{
        [self mergeiCloudChanges:notification forContext:moc];
    }];
}


- (void)resetStore {
    [self saveContext];
    persistentStoreCoordinator__ = nil;
    managedObjectContext__ = nil;
}

- (void)resetiCloudSyncforCloudUrl:(NSURL*) cloudURL {
    NSString *coreDataCloudContent = [[cloudURL path] stringByAppendingPathComponent:@"data"];
    cloudURL = [NSURL fileURLWithPath:coreDataCloudContent];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:cloudURL error:&error];
    
    [self resetStore];
    
    [[[UIAlertView alloc] initWithTitle:@"Sync has been reset" message:@"What to Who will be closed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //[self managedObjectContext];
    abort();
}

@end
