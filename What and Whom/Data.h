//
//  Data.h
//  What and Whom
//
//  Created by Arnaud Boudou on 03/04/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface Data : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSData * dueDate;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * itemType;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * borrow;
@property (nonatomic, retain) NSNumber * idAddressBook;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) UIImage * contactPicture;
@property (nonatomic, retain) NSData * photo;

@end
