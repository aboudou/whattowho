//
//  RootViewController.m
//  What and Whom
//
//  Created by Arnaud Boudou on 02/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "Macros.h"

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RootViewController

@synthesize fetchedResultsController=fetchedResultsController__;
@synthesize managedObjectContext=managedObjectContext__;
@synthesize detailViewController;
@synthesize splitViewController, rootPopoverButtonItem, popoverController;
@synthesize selectedIndexPath;
@synthesize afterFetch;

// because the app delegate now loads the NSPersistentStore into the NSPersistentStoreCoordinator asynchronously
// we will see the NSManagedObjectContext set up before any persistent stores are registered
// we will need to fetch again after the persistent store is loaded
- (void)reloadFetchedResults:(NSNotification*)note {
    afterFetch = YES;
    NSError *error = nil;

    // Migrate data to new datamodel
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Data" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (int i = 0; i < [result count]; i++) {
        Data *data = [result objectAtIndex:i];
        [data migrateContactWithId:data.idAddressBook];
    }

    // La sauvegarde à ce moment fait planter l'application. À voir pourquoi ?
//    if ([self.managedObjectContext hasChanges]) {
//        [self.managedObjectContext save:&error];
//    }
    
    if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    if (note) {
        [self.tableView reloadData];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;

    // Do not unselect items on viewWillAppear for iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
    } else {
        self.clearsSelectionOnViewWillAppear = YES;
    }
    
    // observe the app delegate telling us when it's finished asynchronously setting up the persistent store
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFetchedResults:) name:@"RefetchAllDatabaseData" object:[[UIApplication sharedApplication] delegate]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if ([[[context persistentStoreCoordinator] persistentStores] count] > 0) {
            if (![context save:&error])
            {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        ItemViewController *itemViewController = [[ItemViewController alloc] initWithNibName:@"DetailWrapperViewController" bundle:nil];
        
        itemViewController.data = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:[self.splitViewController.viewControllers objectAtIndex:0], itemViewController, nil];
        self.splitViewController.viewControllers = viewControllers;
        
        if (popoverController != nil) {
            [popoverController dismissPopoverAnimated:YES];
        }
        
        // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
        if (rootPopoverButtonItem != nil) {
            [itemViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
        }


    } else {
        ItemViewController *itemViewController = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
        
        itemViewController.data = [self.fetchedResultsController objectAtIndexPath:indexPath];

        [self.navigationController pushViewController:itemViewController animated:YES];
    }
    selectedIndexPath = indexPath;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell.textLabel setText:(NSString *)[[managedObject valueForKey:@"itemName"] description]];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSNumber *emprunt = (NSNumber *)[[managedObject valueForKey:@"borrow"] description];
    if ([emprunt intValue] == 1) {
        UIImage *cellImage = [UIImage imageNamed:@"borrow.png"];
        cell.imageView.image = cellImage;
    } else {
        UIImage *cellImage = [UIImage imageNamed:@"lend.png"];
        cell.imageView.image = cellImage;
    }
}

- (void)insertNewObject
{
    
    // Create a new instance of the entity managed by the fetched results controller.
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Data *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:NSLocalizedString(@"What ?", @"Default object name") forKey:@"itemName"];
    [newManagedObject setValue:[NSDate date] forKey:@"startDate"];
    [newManagedObject setValue:[NSNumber numberWithInt:0] forKey:@"borrow"];
    [newManagedObject setValue:[NSNumber numberWithInt:0] forKey:@"borrow"];
    [newManagedObject setValue:NSLocalizedString(@"Unknown", @"Unknown contact") forKey:@"whoName"];
    [newManagedObject setValue:NSLocalizedString(@"Unknown", @"Unknown contact") forKey:@"displayName"];

    // Save the context.
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        ItemViewController *itemViewController = [[ItemViewController alloc] initWithNibName:@"DetailWrapperViewController" bundle:nil];
        
        itemViewController.data = newManagedObject;
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:[self.splitViewController.viewControllers objectAtIndex:0], itemViewController, nil];
        self.splitViewController.viewControllers = viewControllers;
        
        // Select in tableview new created item
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        // Hide popover if needed
        if (popoverController != nil) {
            [popoverController dismissPopoverAnimated:YES];
        }
        
        // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
        if (rootPopoverButtonItem != nil) {
            [itemViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
        }

    } else {
        ItemViewController *itemViewController = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
    
        itemViewController.data = newManagedObject;
    
        [self.navigationController pushViewController:itemViewController animated:YES];
    }

}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController__ != nil)
    {
        return fetchedResultsController__;
    }
    
    /*
     Set up the fetched results controller.
    */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Data" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"whoName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorName, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"displayName" cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    
    self.fetchedResultsController = aFetchedResultsController;

    return fetchedResultsController__;
}    

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            selectedIndexPath = newIndexPath;
            break;
            
        case NSFetchedResultsChangeDelete:
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                if([selectedIndexPath isEqual:indexPath]) {
                    DetailWrapperViewController *detailWrapperViewController = [[DetailWrapperViewController alloc] initWithNibName:@"DetailWrapperViewController" bundle:nil];
                
                    NSArray *viewControllers = [[NSArray alloc] initWithObjects:[self.splitViewController.viewControllers objectAtIndex:0], detailWrapperViewController, nil];
                    self.splitViewController.viewControllers = viewControllers;

                    if (rootPopoverButtonItem != nil) {
                        [detailWrapperViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
                    }
                    
                }
                
                if (popoverController != nil) {
                    [popoverController dismissPopoverAnimated:YES];
                }
                
            }
            [tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];


            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            selectedIndexPath = indexPath;
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            selectedIndexPath = newIndexPath;
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];

    if (afterFetch) {
        afterFetch = NO;
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    } else {
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
   return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    barButtonItem.title = NSLocalizedString(@"Items", @"Items");
    popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    DetailWrapperViewController *detailWrapperViewController = [splitViewController.viewControllers objectAtIndex:1];
    [detailWrapperViewController showRootPopoverButtonItem:rootPopoverButtonItem];
}

- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    DetailWrapperViewController *detailWrapperViewController = [splitViewController.viewControllers objectAtIndex:1];
    [detailWrapperViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    popoverController = nil;
    self.rootPopoverButtonItem = nil;
}

@end
