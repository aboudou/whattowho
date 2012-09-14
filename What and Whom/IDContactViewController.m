//
//  IDContactViewController.m
//  What and Whom
//
//  Created by Boudou Arnaud on 17/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IDContactViewController.h"

@implementation IDContactViewController

@synthesize data, parentView, firstNameTextField, lastNameTextField, doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

    self.view.backgroundColor = [Utils defaultBgColor];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Localisation
    [self setTitle:NSLocalizedString(@"Who", @"")];
    [self.doneButton setTitle:NSLocalizedString(@"doneButton", @"")];
    [self.firstNameTextField setPlaceholder:NSLocalizedString(@"firstNameDefaultText", @"")];
    [self.lastNameTextField setPlaceholder:NSLocalizedString(@"lastNameDefaultText", @"")];
    
    [self.firstNameTextField setText:data.whoFirstName];
    [self.lastNameTextField setText:data.whoName];
    [self.firstNameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([self.firstNameTextField.text length] == 0 && [self.lastNameTextField.text length] == 0) {
            data.whoName = NSLocalizedString(@"Unknown", @"");
            data.whoFirstName = @"";
        } else {
            data.whoFirstName = self.firstNameTextField.text;
            data.whoName = self.lastNameTextField.text;
        }
        data.displayName = [NSString stringWithFormat:@"%@ %@", data.whoFirstName, data.whoName];
        
    }
    [Utils updateManagedContext];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) doneButtonPressed:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [parentView.popoverController dismissPopoverAnimated:YES];
        parentView.popoverController = nil;
        
        if ([self.firstNameTextField.text length] == 0 && [self.lastNameTextField.text length] == 0) {
            data.whoName = NSLocalizedString(@"Unknown", @"");
            data.whoFirstName = @"";
        } else {
            data.whoFirstName = self.firstNameTextField.text;
            data.whoName = self.lastNameTextField.text;
        }
        data.displayName = [NSString stringWithFormat:@"%@ %@", data.whoFirstName, data.whoName];
        
        [parentView.tableView reloadData];
    }
}

@end
