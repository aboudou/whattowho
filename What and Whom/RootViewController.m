//
//  RootViewController.m
//  What and Whom
//
//  Created by Arnaud Boudou on 02/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RootViewController

@synthesize fetchedResultsController=__fetchedResultsController;

@synthesize managedObjectContext=__managedObjectContext;

@synthesize detailViewController;

@synthesize splitViewController, rootPopoverButtonItem, popoverController;

NSIndexPath *selectedIndexPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];

    // Do not unselect items on viewWillAppear for iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
    } else {
        self.clearsSelectionOnViewWillAppear = YES;
    }
    
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
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
        if (![context save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
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
        [viewControllers release];
        
        if (popoverController != nil) {
            [popoverController dismissPopoverAnimated:YES];
        }
        
        // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
        if (rootPopoverButtonItem != nil) {
            [itemViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
        }

        [itemViewController release];

    } else {
        ItemViewController *itemViewController = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
        
        itemViewController.data = [self.fetchedResultsController objectAtIndexPath:indexPath];

        [self.navigationController pushViewController:itemViewController animated:YES];
        [itemViewController release];
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
}

- (void)dealloc
{
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [super dealloc];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = (NSString *)[[managedObject valueForKey:@"itemName"] description];
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
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Data *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:NSLocalizedString(@"What ?", @"Default object name") forKey:@"itemName"];
    [newManagedObject setValue:[NSDate date] forKey:@"startDate"];
    [newManagedObject setValue:[NSNumber numberWithInt:0] forKey:@"borrow"];
    
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
        [viewControllers release];
        
        // Select in tableview new created item
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        // Hide popover if needed
        if (popoverController != nil) {
            [popoverController dismissPopoverAnimated:YES];
        }
        
        // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
        if (rootPopoverButtonItem != nil) {
            [itemViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
        }

        [itemViewController release];
    } else {
        ItemViewController *itemViewController = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
    
        itemViewController.data = newManagedObject;
    
        [self.navigationController pushViewController:itemViewController animated:YES];
        [itemViewController release];
    }

}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idAddressBook" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"displayName" cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
        {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
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
                    [viewControllers release];

                    if (rootPopoverButtonItem != nil) {
                        [detailWrapperViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
                    }
                    
                    [detailWrapperViewController release];
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

    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
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
