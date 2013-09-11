//
//  IDDueDateViewController.m
//  What and Whom
//
//  Created by Arnaud Boudou on 04/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IDDueDateViewController.h"

@implementation IDDueDateViewController

@synthesize data, datePicker, todayButton, removeButton, doneButton;
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

    self.view.backgroundColor = [Utils defaultBgColor];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Localisation
    [self setTitle:NSLocalizedString(@"Due date", @"")];
    [self.todayButton setTitle:NSLocalizedString(@"todayButton", @"")];
    [self.doneButton setTitle:NSLocalizedString(@"doneButton", @"")];
    [self.removeButton setTitle:NSLocalizedString(@"deleteDueDateButton", @"")];
    
#warning récupérer la date de la notification
    //[self.datePicker setDate:data.startDate animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
#warning créer la notification
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //data.startDate = self.datePicker.date;
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

#pragma mark - UI management functions

-(IBAction)todayButtonPressed:(id)sender {
    [self.datePicker setDate:[NSDate date] animated:YES];
}

-(IBAction)removeButtonPressed:(id)sender {
#warning delete notification
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) doneButtonPressed:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [parentView.popoverController dismissPopoverAnimated:YES];
        parentView.popoverController = nil;
        
#warning créer la notification
        //data.startDate = self.datePicker.date;
        
        [parentView.tableView reloadData];
    }
}

@end
