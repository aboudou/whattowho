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
#import "IDItemViewController.h"
#import "IDKindViewController.h"
#import "IDNotesViewController.h"
#import "MessageViewController.h"

static NSString *const kClassesKey =  @"classes";

@implementation ItemViewController

@synthesize data;

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
    [startKal release];
    [dueKal release];
    
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

    self.title = data.itemName;
    
    _viewControllers = [[NSArray alloc] initWithObjects:
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
						  @"IDKindViewController", @"IDItemViewController", nil], kClassesKey,
						 nil],
						[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSArray arrayWithObjects:
						  @"IDNotesViewController", nil], kClassesKey,
						 nil],
						[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSArray arrayWithObjects:
						  @"IDStartDateViewController", @"IDDueDateViewController", nil], kClassesKey,
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
    
    if (startKal != nil) {
        data.startDate = startKal.selectedDate;
        startKal = nil;
    }
    if (dueKal != nil) {
#warning Créer la notification si date du calendrier non nulle, sinon supprimer la notification
        // data.startDate = dueKal.selectedDate;
        dueKal = nil;
    }
    
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

    } else if ([name isEqualToString:@"IDNotesViewController"]) {
        // Notes
        cell.textLabel.text = NSLocalizedString(@"Notes", @"Notes");
        cell.detailTextLabel.text = data.notes;
        cell.imageView.image = nil;
    
    } else if ([name isEqualToString:@"IDStartDateViewController"]) {
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
    
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *name = [[[_viewControllers objectAtIndex:indexPath.section] objectForKey:kClassesKey] objectAtIndex:indexPath.row];
    
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
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
    } else if ([name isEqualToString:@"MessageViewController"]) {
        // Message / Call
        MessageViewController *detailViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        
        detailViewController.data = data;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
    } else if ([name isEqualToString:@"IDKindViewController"]) {
        // Type of item
        IDKindViewController *detailViewController = [[IDKindViewController alloc] initWithNibName:@"IDBorrowViewController" bundle:nil];
        
        detailViewController.data = data;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
    } else if ([name isEqualToString:@"IDItemViewController"]) {
        // Item
        IDItemViewController *detailViewController = [[IDItemViewController alloc] initWithNibName:@"IDItemViewController" bundle:nil];
        
        detailViewController.data = data;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
    } else if ([name isEqualToString:@"IDNotesViewController"]) {
        // Notes
        IDNotesViewController *detailViewController = [[IDNotesViewController alloc] initWithNibName:@"IDNotesViewController" bundle:nil];
        
        detailViewController.data = data;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
    } else if ([name isEqualToString:@"IDStartDateViewController"]) {
        // Start date
        startKal = [[[KalViewController alloc] initWithSelectedDate:data.startDate] autorelease];
        startKal.title = NSLocalizedString(@"Date", @"Date");
        
        startKal.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", @"Today") style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectTodayStartKal)] autorelease];

        startKal.delegate = self;
        
        [self.navigationController pushViewController:startKal animated:YES];

    } else if ([name isEqualToString:@"IDDueDateViewController"]) {
        // Due date

#warning Récupérer la date de la notification
        
        dueKal = [[[KalViewController alloc] init] autorelease];
        dueKal.title = NSLocalizedString(@"Due date", @"Due date");
        
        dueKal.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", @"Today") style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectTodayStartKal)] autorelease];
        
        dueKal.delegate = self;
        
        [self.navigationController pushViewController:dueKal animated:YES];
        
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

#pragma mark - Misc. methods

// Action handler for the navigation bar's right bar button item (start kal)
- (void)showAndSelectTodayStartKal {
    [startKal showAndSelectDate:[NSDate date]];
}

// Action handler for the navigation bar's right bar button item (due kal)
- (void)showAndSelectTodayDueKal {
    [dueKal showAndSelectDate:[NSDate date]];
}

@end
