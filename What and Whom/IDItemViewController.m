//
//  IDItemViewController.m
//  What and Whom
//
//  Created by Arnaud Boudou on 07/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IDItemViewController.h"

@implementation IDItemViewController

@synthesize data, itemNameTextField, doneButton;
@synthesize parentView;

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
    [self setTitle:NSLocalizedString(@"What ?", @"")];
    [self.doneButton setTitle:NSLocalizedString(@"doneButton", @"")];
    [self.itemNameTextField setPlaceholder:NSLocalizedString(@"What ?", @"")];
    
    [self.itemNameTextField setText:data.itemName];
    [self.itemNameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([self.itemNameTextField.text length] == 0) {
            data.itemName = NSLocalizedString(@"What ?", @"");
        } else {
            data.itemName = self.itemNameTextField.text;
        }
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
        
        if ([self.itemNameTextField.text length] == 0) {
            data.itemName = NSLocalizedString(@"What ?", @"");
        } else {
            data.itemName = self.itemNameTextField.text;
        }

        [parentView.tableView reloadData];
    }
}

@end
