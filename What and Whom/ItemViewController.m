//
//  ObjectViewController.m
//  What and Whom
//
//  Created by Arnaud Boudou on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "IDBorrowViewController.h"
#import "IDDateViewController.h"
#import "IDDueDateViewController.h"
#import "IDItemViewController.h"
#import "IDKindViewController.h"
#import "IDNotesViewController.h"
#import "IDPhotoViewController.h"
#import "MessageViewController.h"

static NSString *const kClassesKey =  @"classes";

@implementation ItemViewController

@synthesize data;
@synthesize popoverController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [data release];
    [_viewControllers release];
    [popoverController release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.navItem.title = data.itemName;
    } else {
        self.title = data.itemName;
    }
    
    _viewControllers = [[NSMutableArray alloc] initWithObjects:
						[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSArray arrayWithObjects:
						  @"IDContactViewController", @"IDBorrowViewController", nil], kClassesKey,
						 nil],
						[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSArray arrayWithObjects:
						  @"MessageViewController", nil], kClassesKey,
						 nil],
						[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSArray arrayWithObjects:
						  @"IDKindViewController", @"IDItemViewController", @"IDPhotoViewController", nil], kClassesKey,
						 nil],
						[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSArray arrayWithObjects:
						  @"IDNotesViewController", nil], kClassesKey,
						 nil],
						[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSArray arrayWithObjects:
						  @"IDDateViewController", /*@"IDDueDateViewController",*/ nil], kClassesKey,
						 nil],
						nil];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = data.itemName;
        
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_viewControllers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_viewControllers objectAtIndex:section] objectForKey:kClassesKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
    }

    NSString *name = [[[_viewControllers objectAtIndex:indexPath.section] objectForKey:kClassesKey] objectAtIndex:indexPath.row];
    
    if ([name isEqualToString:@"IDContactViewController"]) {
        // Whom
        cell.textLabel.text = NSLocalizedString(@"Who", @"Who");
        cell.detailTextLabel.text = data.displayName;
        cell.imageView.image = data.contactPicture;
        cell.imageView.layer.cornerRadius = 9.0;
        cell.imageView.layer.masksToBounds = YES;
    
        
    } else if ([name isEqualToString:@"IDBorrowViewController"]) {
        // Borrowed / Lent
        cell.textLabel.text = NSLocalizedString(@"Borrowed / Lent", @"Borrowed / Lent");
        if ([data.borrow intValue] == 1) {
            cell.detailTextLabel.text = NSLocalizedString(@"Borrowed", @"Borrowed");
            cell.imageView.image = [UIImage imageNamed:@"borrow.png"];
        } else {
            cell.detailTextLabel.text = NSLocalizedString(@"Lent", @"Lent");
            cell.imageView.image = [UIImage imageNamed:@"lend.png"];
        }
    
    } else if ([name isEqualToString:@"MessageViewController"]) {
        // Contact the contact
        cell.textLabel.text = NSLocalizedString(@"Send a message / Call", @"Send a message / Call");
        
    } else if ([name isEqualToString:@"IDKindViewController"]) {
        // Type of item
        cell.textLabel.text = NSLocalizedString(@"Kind of item", @"Kind of item");
        cell.detailTextLabel.text = NSLocalizedString(data.itemType, data.itemType);
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", data.itemType, @".png"]];;
        
    } else if ([name isEqualToString:@"IDItemViewController"]) {
        // Item
        cell.textLabel.text = NSLocalizedString(@"Item", @"Item");
        cell.detailTextLabel.text = data.itemName;
        cell.imageView.image = nil;

    } else if ([name isEqualToString:@"IDPhotoViewController"]) {
        // Photo
        cell.textLabel.text = NSLocalizedString(@"Photo", @"Photo");
        cell.imageView.image = nil;
        
    } else if ([name isEqualToString:@"IDNotesViewController"]) {
        // Notes
        cell.textLabel.text = NSLocalizedString(@"Notes", @"Notes");
        cell.detailTextLabel.text = data.notes;
        cell.imageView.image = nil;
    
    } else if ([name isEqualToString:@"IDDateViewController"]) {
        // Start date
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMMM yyyy"];
        cell.detailTextLabel.text = [dateFormat stringFromDate:data.startDate];
        cell.textLabel.text = NSLocalizedString(@"Date", @"Date");
        [dateFormat release];
        cell.imageView.image = nil;
        
    } else if ([name isEqualToString:@"IDDueDateViewController"]) {
        // Due date
#warning Récupérer la date de la notification
        /* 
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMMM yyyy"];
        cell.detailTextLabel.text = [dateFormat stringFromDate:data.startDate];
         [dateFormat release];
         */
        cell.textLabel.text = NSLocalizedString(@"Due date", @"Due date");
        cell.imageView.image = nil;
    }
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *name = [[[_viewControllers objectAtIndex:indexPath.section] objectForKey:kClassesKey] objectAtIndex:indexPath.row];
    
    CGRect aFrame = [self.tableView rectForRowAtIndexPath:indexPath];
    
    if ([name isEqualToString:@"IDContactViewController"]) {
        // Whom
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
    } else if ([name isEqualToString:@"IDBorrowViewController"]) {
        // Borrowed / Lent
        IDBorrowViewController *detailViewController = [[IDBorrowViewController alloc] initWithNibName:@"IDBorrowViewController" bundle:nil];
        
        detailViewController.data = data;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            detailViewController.parentView = self;
            [self managePopover:detailViewController frame:aFrame width:320.0 height:detailViewController.tableView.rowHeight * 2.5];
        } else {
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        [detailViewController release];
        
    } else if ([name isEqualToString:@"MessageViewController"]) {
        // Message / Call
        MessageViewController *detailViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        
        detailViewController.data = data;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            detailViewController.parentView = self;
            [self managePopover:detailViewController frame:aFrame width:320.0 height:480.0];
        } else {
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        [detailViewController release];
        
    } else if ([name isEqualToString:@"IDKindViewController"]) {
        // Type of item
        IDKindViewController *detailViewController = [[IDKindViewController alloc] initWithNibName:@"IDKindViewController" bundle:nil];
        
        detailViewController.data = data;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            detailViewController.parentView = self;
            [self managePopover:detailViewController frame:aFrame width:320.0 height:detailViewController.tableView.rowHeight * 10.5];
        } else {
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        [detailViewController release];
        
    } else if ([name isEqualToString:@"IDItemViewController"]) {
        // Item
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            IDItemViewController *detailViewController = [[IDItemViewController alloc] initWithNibName:@"IDItemViewController_iPad" bundle:nil];
            
            detailViewController.data = data;
            detailViewController.parentView = self;

            [self managePopover:detailViewController frame:aFrame width:320.0 height:114.0];

            [detailViewController release];
        } else {
            IDItemViewController *detailViewController = [[IDItemViewController alloc] initWithNibName:@"IDItemViewController" bundle:nil];
            
            detailViewController.data = data;
            
            [self.navigationController pushViewController:detailViewController animated:YES];

            [detailViewController release];
        }
        
    } else if ([name isEqualToString:@"IDPhotoViewController"]) {
        // Photo
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            IDPhotoViewController *detailViewController = [[IDPhotoViewController alloc] initWithNibName:@"IDPhotoViewController_iPad" bundle:nil];
            
            detailViewController.data = data;
            
            detailViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentModalViewController:detailViewController animated:YES];

            [detailViewController release];
        } else {
            IDPhotoViewController *detailViewController = [[IDPhotoViewController alloc] initWithNibName:@"IDPhotoViewController" bundle:nil];
            
            detailViewController.data = data;
            
            [self.navigationController pushViewController:detailViewController animated:YES];

            [detailViewController release];
        }
        
    } else if ([name isEqualToString:@"IDNotesViewController"]) {
        // Notes
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            IDNotesViewController *detailViewController = [[IDNotesViewController alloc] initWithNibName:@"IDNotesViewController_iPad" bundle:nil];
            
            detailViewController.data = data;
            detailViewController.parentView = self;

            [self managePopover:detailViewController frame:aFrame width:320.0 height:300.0];

            [detailViewController release];
        } else {
            IDNotesViewController *detailViewController = [[IDNotesViewController alloc] initWithNibName:@"IDNotesViewController" bundle:nil];
            
            detailViewController.data = data;
            
            [self.navigationController pushViewController:detailViewController animated:YES];

            [detailViewController release];
        }
        
    } else if ([name isEqualToString:@"IDDateViewController"]) {
        // Date
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            IDDateViewController *detailViewController = [[IDDateViewController alloc] initWithNibName:@"IDDateViewController_iPad" bundle:nil];
            
            detailViewController.data = data;
            detailViewController.parentView = self;

            [self managePopover:detailViewController frame:aFrame width:320.0 height:304.0];

            [detailViewController release];
        } else {
            IDDateViewController *detailViewController = [[IDDateViewController alloc] initWithNibName:@"IDDateViewController" bundle:nil];
            
            detailViewController.data = data;
            
            [self.navigationController pushViewController:detailViewController animated:YES];

            [detailViewController release];
        }
        
    } else if ([name isEqualToString:@"IDDueDateViewController"]) {
        // Due date

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            IDDueDateViewController *detailViewController = [[IDDueDateViewController alloc] initWithNibName:@"IDDueDateViewController_iPad" bundle:nil];
            
            detailViewController.data = data;
            detailViewController.parentView = self;

            [self managePopover:detailViewController frame:aFrame width:320.0 height:304.0];

            [detailViewController release];
        } else {
            IDDueDateViewController *detailViewController = [[IDDueDateViewController alloc] initWithNibName:@"IDDueDateViewController" bundle:nil];
            
            detailViewController.data = data;
            
            [self.navigationController pushViewController:detailViewController animated:YES];

            [detailViewController release];
        }
    }
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSNumber *idPerson = [NSNumber numberWithInteger: ABRecordGetRecordID(person)];
    data.idAddressBook = idPerson;
    
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover: (UIPopoverController *)p_popoverController {
    // Force la mise à jour des données avant de rafraichir la vue courante
//    [p_popoverController.contentViewController viewWillDisappear:YES];
//    [self.tableView reloadData];
}

#pragma mark - Misc. methods
- (void)managePopover:(UIViewController *)controller frame:(CGRect)aFrame width:(float)aWidth height:(float)aHeight {
    if(![popoverController isPopoverVisible]){
        // Popover is not visible
        popoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        popoverController.delegate = self;
        [popoverController setPopoverContentSize: CGSizeMake(aWidth, aHeight) animated:YES];
        [popoverController presentPopoverFromRect:aFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [popoverController dismissPopoverAnimated:YES];
        popoverController = nil;
    }
}

@end
