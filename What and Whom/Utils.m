//
//  Utils.m
//  What and Whom
//
//  Created by Boudou Arnaud on 23/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "What_and_WhomAppDelegate.h"

@implementation Utils

+ (void) updateManagedContext {
    What_and_WhomAppDelegate *appDelegate = (What_and_WhomAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
}

+ (UIColor *) defaultBgColor {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    } else {
        return [[UIColor alloc] initWithRed:220.0f/255.0f green:223.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    }
}

@end
