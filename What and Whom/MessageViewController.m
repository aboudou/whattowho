//
//  MessageViewController.m
//  What and Whom
//
//  Created by Arnaud Boudou on 17/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageViewController.h"

static NSString *const kClassesKey =  @"classes";
static NSString *const kTitleKey =  @"title";

@implementation MessageViewController

@synthesize data;
@synthesize parentView;
@synthesize viewControllers;

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

    self.title = NSLocalizedString(@"Contact", @"Contact");
    
    viewControllers = [[NSMutableArray alloc] initWithCapacity:1];

    // Get contact from Address Book
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)[NSString stringWithFormat:@"%@ %@", data.whoFirstName, data.whoName]);
    if ((people != nil) && (CFArrayGetCount(people) > 0)) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, 0);
        
        if (person != nil) {
            ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSArray* phoneNumbers = (__bridge_transfer NSArray*)ABMultiValueCopyArrayOfAllValues(phoneNumberProperty);
            CFRelease(phoneNumberProperty);

            if ([phoneNumbers count] != 0) {
                // Add phone numbers if the device can send text messages
                if([MFMessageComposeViewController canSendText]) {
                    [viewControllers addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 phoneNumbers, kClassesKey, NSLocalizedString(@"text", @"text"), kTitleKey,
                                                 nil]];
                }
    
                // Add phone numbers if the device can make phone calls
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://+11111"]]) {
                    [viewControllers addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 phoneNumbers, kClassesKey, NSLocalizedString(@"phone", @"phone"), kTitleKey,
                                                 nil]];
                }
            }
        
            
            // Add emails
            if([MFMailComposeViewController canSendMail]) {
                ABMutableMultiValueRef multiEmail = ABRecordCopyValue(person, kABPersonEmailProperty);
                NSMutableArray *emails = [[NSMutableArray alloc] init];
                for (int i = 0; i < ABMultiValueGetCount(multiEmail); i++) {
                    NSString *anEmail = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(multiEmail, i);
                    [emails addObject:anEmail];
                }
                CFRelease(multiEmail);
                if ([emails count] != 0) {
                    [viewControllers addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 emails, kClassesKey, NSLocalizedString(@"email", @"email"), kTitleKey,
                                                 nil]];
                }
            }
        }
    }
    if (people != nil) {
        CFRelease(people);
    }
    CFRelease(addressBook);
    
    // Case of an empty list
    if ([viewControllers count] == 0) {
        [viewControllers addObject:[NSDictionary dictionaryWithObjectsAndKeys:
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [viewControllers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[viewControllers objectAtIndex:section] objectForKey:kClassesKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *name = [[[viewControllers objectAtIndex:indexPath.section] objectForKey:kClassesKey] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = name;
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    if ([[[viewControllers objectAtIndex:indexPath.section] objectForKey:kTitleKey] isEqualToString:@""]) {
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[viewControllers objectAtIndex:section] objectForKey:kTitleKey];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSString *name = [[[viewControllers objectAtIndex:indexPath.section] objectForKey:kClassesKey] objectAtIndex:indexPath.row];

    if ([[[viewControllers objectAtIndex:indexPath.section] objectForKey:kTitleKey] isEqualToString:NSLocalizedString(@"text", @"text")]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.body = @"";
		controller.recipients = [NSArray arrayWithObjects:[name stringByReplacingOccurrencesOfString:@" " withString:@""], nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];

    } else if ([[[viewControllers objectAtIndex:indexPath.section] objectForKey:kTitleKey] isEqualToString:NSLocalizedString(@"phone", @"phone")]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [name stringByReplacingOccurrencesOfString:@" " withString:@""]]]];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [parentView.popoverController dismissPopoverAnimated:YES];
            parentView.popoverController = nil;
        }
    
    } else if ([[[viewControllers objectAtIndex:indexPath.section] objectForKey:kTitleKey] isEqualToString:NSLocalizedString(@"email", @"email")]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setMessageBody:@"" isHTML:NO];
		[controller setToRecipients:[NSArray arrayWithObjects:[name stringByReplacingOccurrencesOfString:@" " withString:@""], nil]];
		controller.mailComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
        
    }
        
}

#pragma mark - Message composer delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    UIAlertView *alert;
    
	switch (result) {
		case MessageComposeResultFailed:
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"What to Who", @"What to Who") message:NSLocalizedString(@"Unknown error", @"Unknown error") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
			
            break;

		case MessageComposeResultCancelled:
            
			break;
            
		case MessageComposeResultSent:
            
			break;

		default:

			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [parentView.popoverController dismissPopoverAnimated:YES];
        parentView.popoverController = nil;
    }

}

#pragma mark - Mail composer delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    UIAlertView *alert;

    switch (result) {
        case MFMailComposeResultCancelled:
            
            break;
            
        case MFMailComposeResultSaved:
            
            break;
            
        case MFMailComposeResultSent:
            
            break;
            
        case MFMailComposeResultFailed:
            
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"What to Who", @"What to Who") message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
			
            break;
            
    }
    
	[self dismissModalViewControllerAnimated:YES];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [parentView.popoverController dismissPopoverAnimated:YES];
        parentView.popoverController = nil;
    }

}

@end
