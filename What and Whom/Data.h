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

}

@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSData * dueDate;
@property (nonatomic, strong) NSString * itemName;
@property (nonatomic, strong) NSString * itemType;
@property (nonatomic, strong) NSString * notes;
@property (nonatomic, strong) NSNumber * borrow;
@property (nonatomic, strong) NSNumber * idAddressBook;
@property (nonatomic, strong) NSString * displayName;
@property (nonatomic, strong) UIImage * contactPicture;
@property (nonatomic, strong) NSData * photo;
@property (nonatomic, strong) NSString *whoName;
@property (nonatomic, strong) NSString *whoFirstName;

- (void) migrateContactWithId:(NSNumber *)abId;

@end
