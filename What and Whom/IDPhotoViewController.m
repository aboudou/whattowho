//
//  IDPhotoViewController.m
//  What and Whom
//
//  Created by Arnaud Boudou on 04/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IDPhotoViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation IDPhotoViewController

@synthesize data, imageView, photoBg, addButton, deleteButton, doneButton;
@synthesize popoverController;

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
    [self setTitle:NSLocalizedString(@"Photo", @"")];
    [self.doneButton setTitle:NSLocalizedString(@"doneButton", @"")];
    [self.photoBg setTitle:NSLocalizedString(@"noPhotoButton", @"") forState:UIControlStateNormal];
    [self.addButton setTitle:NSLocalizedString(@"addPhotoButton", @"")];
    [self.deleteButton setTitle:NSLocalizedString(@"deletePhotoButton", @"")];
    
    if (data.photo != nil) {
        [self.imageView setImage:[[UIImage alloc] initWithData:data.photo]];
        [self.imageView setBackgroundColor:[UIColor blackColor]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.imageView.image != nil) {
        data.photo = UIImagePNGRepresentation(self.imageView.image);
    } else {
        data.photo = nil;
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

-(IBAction)addButtonPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // Hide popover if visible.
        if([popoverController isPopoverVisible]){
            [popoverController dismissPopoverAnimated:YES];
            popoverController = nil;
        }
        
        // Un appareil photo est disponible, on laisse le choix de la source
        UIActionSheet *photoSourceSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Add a photo", @"") 
                                                                      delegate:self 
                                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"") 
                                                        destructiveButtonTitle:nil 
                                                             otherButtonTitles:NSLocalizedString(@"Take new photo", @""), 
                                           NSLocalizedString(@"Choose existing photo", @""), 
                                           nil, nil];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [photoSourceSheet showFromBarButtonItem:sender animated:YES];
        } else {
            [photoSourceSheet showInView:self.view];
        }
    } else {
        // Pas d'appareil photo, on va directement dans la bibliothèque d'images
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if(![popoverController isPopoverVisible]){
                // Popover is not visible
                popoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
                [popoverController setPopoverContentSize: CGSizeMake(320.0, 480.0) animated:YES];
                [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }else{
                [popoverController dismissPopoverAnimated:YES];
                popoverController = nil;
            }
        } else {
            [self presentModalViewController:picker animated:YES];
        }
    }
}

-(IBAction)removeButtonPressed:(id)sender {
    self.imageView.image = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate functions


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.data.photo = UIImagePNGRepresentation((UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"]);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            [self dismissModalViewControllerAnimated:YES];
        } else {
            [popoverController dismissPopoverAnimated:YES];
        }
        self.imageView.image = (UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        if (data.photo != nil) {
            self.imageView.image = [[UIImage alloc] initWithData:data.photo];
            self.imageView.backgroundColor = [UIColor blackColor];
        }

    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate functions

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            return;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            [self presentModalViewController:picker animated:YES];
        } else {
            if(![popoverController isPopoverVisible]){
                // Popover is not visible
                popoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
                [popoverController setPopoverContentSize: CGSizeMake(320.0, 480.0) animated:YES];
                [popoverController presentPopoverFromBarButtonItem:self.addButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }else{
                [popoverController dismissPopoverAnimated:YES];
                popoverController = nil;
            }
        }
        
        if (data.photo != nil) {
            self.imageView.image = [[UIImage alloc] initWithData:data.photo];
            self.imageView.backgroundColor = [UIColor blackColor];
        }

    } else {
        [self presentModalViewController:picker animated:YES];
    }

}
@end
