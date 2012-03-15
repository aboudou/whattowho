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
@end
