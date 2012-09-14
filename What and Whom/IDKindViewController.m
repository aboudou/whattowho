//
//  IDKindViewController.m
//  What and Whom
//
//  Created by Arnaud Boudou on 07/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IDKindViewController.h"

static NSString *const kDataKey =  @"data";

@implementation IDKindViewController

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
    
    self.title = NSLocalizedString(@"Kind of item", @"");
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([language isEqualToString:@"fr"]) {
        viewControllers = [[NSArray alloc] initWithObjects:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSArray arrayWithObjects:
                              @"animal", @"money", @"misc", @"movie", @"game", @"book", @"software", @"music", @"tool", @"clothing", nil], kDataKey,
                             nil],
                            nil];
    } else {
        viewControllers = [[NSArray alloc] initWithObjects:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSArray arrayWithObjects:
                              @"animal", @"book", @"clothing", @"game", @"misc", @"money", @"movie", @"music", @"software", @"tool", nil], kDataKey,
                             nil],
                            nil];
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
    return [viewControllers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[viewControllers objectAtIndex:section] objectForKey:kDataKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *name = [[[viewControllers objectAtIndex:indexPath.section] objectForKey:kDataKey] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = NSLocalizedString(name, @"");
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", name, @".png"]];
    if ([data.itemType isEqualToString:name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = 0;
    }
    
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [[[viewControllers objectAtIndex:indexPath.section] objectForKey:kDataKey] objectAtIndex:indexPath.row];
    
    data.itemType = name;
    
    [self.tableView reloadData];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [parentView.popoverController dismissPopoverAnimated:YES];
        parentView.popoverController = nil;
        [parentView.tableView reloadData];
    }
}

@end
