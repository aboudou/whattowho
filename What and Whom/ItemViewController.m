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
#import "IDContactViewController.h"
#import "IDDateViewController_iPad.h"
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
@synthesize dateViewController;
@synthesize contactButtonFrame;
@synthesize maskView, overView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

    [Utils updateManagedContext];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }

    NSString *name = [[[_viewControllers objectAtIndex:indexPath.section] objectForKey:kClassesKey] objectAtIndex:indexPath.row];
    
    if ([name isEqualToString:@"IDContactViewController"]) {
        // Whom
        cell.textLabel.text = NSLocalizedString(@"Who", @"");
        cell.detailTextLabel.text = data.displayName;
        cell.imageView.image = data.contactPicture;
        cell.imageView.layer.cornerRadius = 9.0;
        cell.imageView.layer.masksToBounds = YES;
    
        
    } else if ([name isEqualToString:@"IDBorrowViewController"]) {
        // Borrowed / Lent
        cell.textLabel.text = NSLocalizedString(@"Borrowed / Lent", @"");
        if ([data.borrow intValue] == 1) {
            cell.detailTextLabel.text = NSLocalizedString(@"Borrowed", @"");
            cell.imageView.image = [UIImage imageNamed:@"borrow.png"];
        } else {
            cell.detailTextLabel.text = NSLocalizedString(@"Lent", @"");
            cell.imageView.image = [UIImage imageNamed:@"lend.png"];
        }
    
    } else if ([name isEqualToString:@"MessageViewController"]) {
        // Contact the contact
        cell.textLabel.text = NSLocalizedString(@"Send a message / Call", @"");
        
    } else if ([name isEqualToString:@"IDKindViewController"]) {
        // Type of item
        cell.textLabel.text = NSLocalizedString(@"Kind of item", @"");
        cell.detailTextLabel.text = NSLocalizedString(data.itemType, @"");
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", data.itemType, @".png"]];;
        
    } else if ([name isEqualToString:@"IDItemViewController"]) {
        // Item
        cell.textLabel.text = NSLocalizedString(@"Item", @"");
        cell.detailTextLabel.text = data.itemName;
        cell.imageView.image = nil;

    } else if ([name isEqualToString:@"IDPhotoViewController"]) {
        // Photo
        cell.textLabel.text = NSLocalizedString(@"Photo", @"");
        cell.imageView.image = nil;
        
    } else if ([name isEqualToString:@"IDNotesViewController"]) {
        // Notes
        cell.textLabel.text = NSLocalizedString(@"Notes", @"");
        cell.detailTextLabel.text = data.notes;
        cell.imageView.image = nil;
    
    } else if ([name isEqualToString:@"IDDateViewController"]) {
        // Start date
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMMM yyyy"];
        cell.detailTextLabel.text = [dateFormat stringFromDate:data.startDate];
        cell.textLabel.text = NSLocalizedString(@"Date", @"");
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
        cell.textLabel.text = NSLocalizedString(@"Due date", @"");
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
        UIActionSheet *contactSourceSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"contactPickerTitle", @"") 
                                                                      delegate:self 
                                                             cancelButtonTitle:NSLocalizedString(@"contactPickerCancel", @"") 
                                                        destructiveButtonTitle:nil 
                                                             otherButtonTitles:NSLocalizedString(@"contactPickerFromAB", @""), 
                                           NSLocalizedString(@"contactPickerOther", @""), 
                                           nil, nil];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            contactButtonFrame = aFrame;
            [contactSourceSheet showFromRect:contactButtonFrame inView:self.view animated:YES];
        } else {
            [contactSourceSheet showInView:self.view];
        }

    } else if ([name isEqualToString:@"IDBorrowViewController"]) {
        // Borrowed / Lent
        IDBorrowViewController *detailViewController = [[IDBorrowViewController alloc] initWithNibName:@"IDBorrowViewController" bundle:nil];
        
        detailViewController.data = data;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            detailViewController.parentView = self;
            [self managePopover:detailViewController frame:aFrame width:320.0 height:detailViewController.tableView.rowHeight * 2];
        } else {
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        
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
        
    } else if ([name isEqualToString:@"IDKindViewController"]) {
        // Type of item
        IDKindViewController *detailViewController = [[IDKindViewController alloc] initWithNibName:@"IDKindViewController" bundle:nil];
        
        detailViewController.data = data;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            detailViewController.parentView = self;
            [self managePopover:detailViewController frame:aFrame width:320.0 height:detailViewController.tableView.rowHeight * 10];
        } else {
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        
    } else if ([name isEqualToString:@"IDItemViewController"]) {
        // Item
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            IDItemViewController *detailViewController = [[IDItemViewController alloc] initWithNibName:@"IDItemViewController_iPad" bundle:nil];
            
            detailViewController.data = data;
            detailViewController.parentView = self;

            [self managePopover:detailViewController frame:aFrame width:320.0 height:114.0];

        } else {
            IDItemViewController *detailViewController = [[IDItemViewController alloc] initWithNibName:@"IDItemViewController" bundle:nil];
            
            detailViewController.data = data;
            
            [self.navigationController pushViewController:detailViewController animated:YES];

        }
        
    } else if ([name isEqualToString:@"IDPhotoViewController"]) {
        // Photo
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            IDPhotoViewController *detailViewController = [[IDPhotoViewController alloc] initWithNibName:@"IDPhotoViewController_iPad" bundle:nil];
            
            detailViewController.data = data;
            
            detailViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:detailViewController animated:YES completion:NULL];

        } else {
            IDPhotoViewController *detailViewController = [[IDPhotoViewController alloc] initWithNibName:@"IDPhotoViewController" bundle:nil];
            
            detailViewController.data = data;
            
            [self.navigationController pushViewController:detailViewController animated:YES];

        }
        
    } else if ([name isEqualToString:@"IDNotesViewController"]) {
        // Notes
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            IDNotesViewController *detailViewController = [[IDNotesViewController alloc] initWithNibName:@"IDNotesViewController_iPad" bundle:nil];
            
            detailViewController.data = data;
            detailViewController.parentView = self;

            [self managePopover:detailViewController frame:aFrame width:320.0 height:300.0];

        } else {
            IDNotesViewController *detailViewController = [[IDNotesViewController alloc] initWithNibName:@"IDNotesViewController" bundle:nil];
            
            detailViewController.data = data;
            
            [self.navigationController pushViewController:detailViewController animated:YES];

        }
        
    } else if ([name isEqualToString:@"IDDateViewController"]) {
        // Date
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            IDDateViewController_iPad *detailViewController = [[IDDateViewController_iPad alloc] initWithNibName:@"IDDateViewController_iPad" bundle:nil];
            
            detailViewController.data = data;
            detailViewController.parentView = self;

            [self managePopover:detailViewController frame:aFrame width:320.0 height:304.0];

        } else {
            dateViewController = [[IDDateViewController alloc] initWithNibName:@"IDDateViewController_iPad" bundle:nil];
            
            dateViewController.data = data;

            [UIView animateWithDuration:0.3f animations:^{
                overView = [[UIView alloc] initWithFrame:self.view.frame];
                
                float compensation = 0.0f;
                
                if (self.tableView.contentSize.height > self.view.frame.size.height) {
                    overView.frame = (CGRect) {0, 0, self.tableView.contentSize};
                } else {
                    overView.frame = (CGRect) {0, 0, [[UIScreen mainScreen] bounds].size};
                    // Issue with iPhone 5, we need to add compensation : navbar height + status bar height
                    compensation = self.navigationController.navigationBar.frame.size.height + 22;
                }
                overView.backgroundColor = [[UIColor alloc] initWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                overView.backgroundColor = [[UIColor alloc] initWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
                
                [self.view addSubview:overView];
                
                dateViewController.view.frame = CGRectMake(
                                                             0,
                                                             overView.frame.size.height,
                                                             overView.frame.size.width,
                                                             dateViewController.view.frame.size.height
                                                           );

                [overView addSubview:dateViewController.view];
                dateViewController.todayButton.target = self;
                dateViewController.todayButton.action = @selector(todayButtonPressed);
                
                dateViewController.doneButton.target = self;
                dateViewController.doneButton.action = @selector(doneButtonPressed);

                dateViewController.view.frame = CGRectMake(
                                                             0,
                                                             overView.frame.size.height - dateViewController.view.frame.size.height - compensation,
                                                             overView.frame.size.width,
                                                             dateViewController.view.frame.size.height
                                                           );
                
            }];

        }
        
    } else if ([name isEqualToString:@"IDDueDateViewController"]) {
        // Due date

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            IDDueDateViewController *detailViewController = [[IDDueDateViewController alloc] initWithNibName:@"IDDueDateViewController_iPad" bundle:nil];
            
            detailViewController.data = data;
            detailViewController.parentView = self;

            [self managePopover:detailViewController frame:aFrame width:320.0 height:304.0];

        } else {
            IDDueDateViewController *detailViewController = [[IDDueDateViewController alloc] initWithNibName:@"IDDueDateViewController" bundle:nil];
            
            detailViewController.data = data;
            
            [self.navigationController pushViewController:detailViewController animated:YES];

        }
    }
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    data.whoName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    data.whoFirstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    data.displayName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [Utils updateManagedContext];
    
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


#pragma mark - UIActionSheetDelegate functions

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

    ABPeoplePickerNavigationController *picker = nil;
    
    switch (buttonIndex) {
        case 0:
            picker = [[ABPeoplePickerNavigationController alloc] init];
            picker.peoplePickerDelegate = self;
                  
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        case 1:

            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                IDContactViewController *detailViewController = [[IDContactViewController alloc] initWithNibName:@"IDContactViewController_iPad" bundle:nil];
                
                detailViewController.data = data;
                detailViewController.parentView = self;
                
                [self managePopover:detailViewController frame:contactButtonFrame width:320.0 height:153.0];
                
            } else {
                IDContactViewController *detailViewController = [[IDContactViewController alloc] initWithNibName:@"IDContactViewController" bundle:nil];
                
                detailViewController.data = data;
                
                [self.navigationController pushViewController:detailViewController animated:YES];
                
            }
            
            break;
        default:
            return;
    }
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

- (void) todayButtonPressed {
    [dateViewController.datePicker setDate:[NSDate date] animated:YES];
}

- (void) doneButtonPressed {
    data.startDate = dateViewController.datePicker.date;
    
    [UIView animateWithDuration:0.3f animations:^{
        dateViewController.view.frame = CGRectMake(
                                                   0,
                                                   self.view.frame.size.height,
                                                   self.view.frame.size.width,
                                                   304);
        
        overView.backgroundColor = [[UIColor alloc] initWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];

        [self.tableView reloadData];
    } completion:^(BOOL finished){
        [overView removeFromSuperview];
        [dateViewController.view removeFromSuperview];
    }];

}

@end
