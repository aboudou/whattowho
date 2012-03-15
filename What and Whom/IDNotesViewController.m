//
//  IDNotesViewController.m
//  What and Whom
//
//  Created by Arnaud Boudou on 09/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IDNotesViewController.h"
#import "Utils.h"

@implementation IDNotesViewController

@synthesize data, notesTextView, doneButton;
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
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocalizedString(@"Notes", @"Notes");
    
    self.notesTextView.text = data.notes;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        data.notes = self.notesTextView.text;
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
        
        data.notes = self.notesTextView.text;
        
        [parentView.tableView reloadData];
    }
}

@end
