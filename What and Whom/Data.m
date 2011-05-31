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

    if (person != nil) {
        NSString *name = [(NSString *)ABRecordCopyCompositeName(person) autorelease];
        CFRelease(addressBook);
        return name;
    } else { 
        CFRelease(addressBook);
        return NSLocalizedString(@"Unknown", @"Unknown contact");
    }
    
}

- (UIImage *) contactPicture {
    // Get contact from Address Book
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordID abId = (ABRecordID)[self.idAddressBook intValue];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook,abId);
    
    if (person != nil && ABPersonHasImageData(person)) {
        if ( &ABPersonCopyImageDataWithFormat != nil ) {
            UIImage *image = [UIImage imageWithData:[(NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail) autorelease]];
            CFRelease(addressBook);
            return image;
        } else { 
            UIImage *image = [UIImage imageWithData:[(NSData *)(NSData *)ABPersonCopyImageData(person) autorelease]];
            CFRelease(addressBook);
            return image;
        }
    } else { 
        CFRelease(addressBook);
        return nil;
    }
}


@end
