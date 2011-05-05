//
//  IDItemViewController.h
//  What and Whom
//
//  Created by Arnaud Boudou on 07/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface IDItemViewController : UIViewController {
    Data *data;
    IBOutlet UITextField *itemNameTextField;
}

@property(nonatomic, retain) Data *data;
@property(nonatomic, retain) UITextField *itemNameTextField;

@end
