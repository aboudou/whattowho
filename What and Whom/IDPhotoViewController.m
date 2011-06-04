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

@synthesize data, imageView, photoBg, addButton, removeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [data release];
    [imageView release];
    [photoBg release];
    [addButton release];
    [removeButton release];
    
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
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocalizedString(@"Photo", @"Photo");
    
    if (data.photo != nil) {
        self.imageView.image = [[[UIImage alloc] initWithData:data.photo] autorelease];
        /*
        [[photoBg layer] setCornerRadius:8.0f];
        [[photoBg layer] setMasksToBounds:YES];
        [[photoBg layer] setBorderWidth:1.0f];
        [photoBg setBackgroundColor:[UIColor blackColor]];
        */
        self.imageView.backgroundColor = [UIColor blackColor];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.imageView.image != nil) {
        data.photo = UIImagePNGRepresentation(self.imageView.image);
    } else {
        data.photo = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI management functions

-(IBAction)addButtonPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // Un appareil photo est disponible, on laisse le choix de la source
        UIActionSheet *photoSourceSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Add a photo", @"Title for photo source sheet") 
                                                                      delegate:self 
                                                             cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel button on photo source sheet") 
                                                        destructiveButtonTitle:nil 
                                                             otherButtonTitles:NSLocalizedString(@"Take new photo", "Photo from camera button on photo source sheet"), 
                                           NSLocalizedString(@"Choose existing photo", "Photo from library on photo source sheet"), 
                                           nil, nil];
        [photoSourceSheet showInView:self.view];
        [photoSourceSheet release];
    } else {
        // Pas d'appareil photo, on va directement dans la bibliothèque d'images
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        [self presentModalViewController:picker animated:YES];
    }
}

-(IBAction)removeButtonPressed:(id)sender {
    self.imageView.image = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate functions


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    self.data.photo = UIImagePNGRepresentation(image);
    
    [self dismissModalViewControllerAnimated:YES];
    [picker release];
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
            [picker release];
            return;
    }
    
    [self presentModalViewController:picker animated:YES];
}
@end
