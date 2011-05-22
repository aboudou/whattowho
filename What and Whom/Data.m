//
//  Data.m
//  What and Whom
//
//  Created by Arnaud Boudou on 03/04/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Data.h"


@implementation Data
@dynamic startDate;
@dynamic dueDate;
@dynamic itemName;
@dynamic itemType;
@dynamic notes;
@dynamic borrow;
@dynamic idAddressBook;
@dynamic contactPicture;
@dynamic photo;

@synthesize displayName;


- (NSString *) displayName {
    // Get contact from Address Book
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordID abId = (ABRecordID)[self.idAddressBook intValue];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook,abId);
    
    if (person != nil)
        return [(NSString *)ABRecordCopyCompositeName(person) autorelease];
    else 
        return NSLocalizedString(@"Unknown", @"Unknown contact");
}

- (UIImage *) contactPicture {
    // Get contact from Address Book
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordID abId = (ABRecordID)[self.idAddressBook intValue];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook,abId);
    
    if (person != nil && ABPersonHasImageData(person))
        if ( &ABPersonCopyImageDataWithFormat != nil )
            return [UIImage imageWithData:(NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
        else 
            return [UIImage imageWithData:(NSData *)ABPersonCopyImageData(person)];
    else 
        return nil;
}


@end
