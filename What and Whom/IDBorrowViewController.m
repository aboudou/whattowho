//
//  IDBorrowViewController.m
//  What and Whom
//
//  Created by Arnaud Boudou on 07/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IDBorrowViewController.h"
#import "ItemViewController.h"
#import "ItemViewController.h"
#import "Utils.h"

static NSString *const kDataKey =  @"data";

@implementation IDBorrowViewController

@synthesize data;
@synthesize parentView;

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
    [parentView release];

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

    self.title = NSLocalizedString(@"Borrowed / Lent", @"Borrowed / Lent");
    
    _viewControllers = [[NSArray alloc] initWithObjects:
						[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSArray arrayWithObjects:
						  @"borrowed", @"lent", nil], kDataKey,
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    return [_viewControllers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_viewControllers objectAtIndex:section] objectForKey:kDataKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSString *name = [[[_viewControllers objectAtIndex:indexPath.section] objectForKey:kDataKey] objectAtIndex:indexPath.row];
    
    if ([name isEqualToString:@"borrowed"]) {
        // Borrowed
        cell.textLabel.text = NSLocalizedString(@"Borrowed", @"Borrowed");
        cell.imageView.image = [UIImage imageNamed:@"borrow.png"];
        if ([data.borrow intValue] == 1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = 0;
        }
        
    } else if ([name isEqualToString:@"lent"]) {
        // Lent
        cell.textLabel.text = NSLocalizedString(@"Lent", @"Lent");
        cell.imageView.image = [UIImage imageNamed:@"lend.png"];
        if ([data.borrow intValue] == 0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = 0;
        }
    }
    
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [[[_viewControllers objectAtIndex:indexPath.section] objectForKey:kDataKey] objectAtIndex:indexPath.row];
    
    if ([name isEqualToString:@"borrowed"]) {
        data.borrow = [NSNumber numberWithInt:1];
        
    } else if ([name isEqualToString:@"lent"]) {
        data.borrow = [NSNumber numberWithInt:0];
        
    }
    
    [self.tableView reloadData];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [parentView.popoverController dismissPopoverAnimated:YES];
        parentView.popoverController = nil;
        [parentView.tableView reloadData];
    }

}

@end
