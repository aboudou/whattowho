//
//  MessageViewController.m
//  What and Whom
//
//  Created by Arnaud Boudou on 17/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageViewController.h"
#import <MessageUI/MessageUI.h>

static NSString *const kClassesKey =  @"classes";
static NSString *const kTitleKey =  @"title";

@implementation MessageViewController

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

    self.title = NSLocalizedString(@"Contact", @"Contact");
    
    _viewControllers = [[NSMutableArray alloc] initWithCapacity:1];

    // Get contact from Address Book
    if (data.idAddressBook != nil) {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABRecordID abId = (ABRecordID)[data.idAddressBook intValue];
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, abId);

        if (person != nil) {
            NSArray* phoneNumbers = [[NSMutableArray alloc] init];
            ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(person, kABPersonPhoneProperty);
            phoneNumbers = (NSArray*)ABMultiValueCopyArrayOfAllValues(phoneNumberProperty);
            CFRelease(phoneNumberProperty);

            // Add phone numbers if the device can send text messages
            if([MFMessageComposeViewController canSendText]) {
                [_viewControllers addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                             phoneNumbers, kClassesKey, NSLocalizedString(@"text", @"text"), kTitleKey,
                                             nil]];
            }
    
            // Add phone numbers if the device can make phone calls
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:+11111"]]) {
                [_viewControllers addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                             phoneNumbers, kClassesKey, NSLocalizedString(@"phone", @"phone"), kTitleKey,
                                             nil]];
            }
        
            [phoneNumbers release];
            
            // Add emails
            ABMutableMultiValueRef multiEmail = ABRecordCopyValue(person, kABPersonEmailProperty);
            NSMutableArray *emails = [[NSMutableArray alloc] init];
            for (int i = 0; i < ABMultiValueGetCount(multiEmail); i++) {
                NSString *anEmail = [(NSString*)ABMultiValueCopyValueAtIndex(multiEmail, i) autorelease];
                [emails addObject:anEmail];
            }
            [_viewControllers addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                         emails, kClassesKey, NSLocalizedString(@"email", @"email"), kTitleKey,
                                         nil]];
        }
    }
    
    // Case of an empty list
    if ([_viewControllers count] == 0) {
        [_viewControllers addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSArray arrayWithObjects:
                                      NSLocalizedString(@"No contact info", @"No contact info"), nil], kClassesKey, @"", kTitleKey,
                                      nil]];
    }
    
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
    static NSString *CellIdentifier = @"Cell";
    
    // TODO : détecter la section pour indiquer le type d'action (téléphone / sms / email / rien)
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *name = [[[_viewControllers objectAtIndex:indexPath.section] objectForKey:kClassesKey] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = name;
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    if ([[[_viewControllers objectAtIndex:indexPath.section] objectForKey:kTitleKey] isEqualToString:@""]) {
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[_viewControllers objectAtIndex:section] objectForKey:kTitleKey];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
