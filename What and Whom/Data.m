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
@dynamic whoName;
@dynamic whoFirstName;
@dynamic displayName;

//@synthesize displayName;

// Migre les données vers le nouveau datamodel
- (void) migrateContactWithId:(NSNumber *)abId {
    ABAddressBookRef addressBook = ABAddressBookCreate();
    if (abId != nil && [abId intValue] != 0) {
        ABRecordID abId = (ABRecordID)[self.idAddressBook intValue];
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook,abId);
        
        if (person != nil) {
            self.whoName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            self.whoFirstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            self.idAddressBook = nil;
        } else {
            self.whoName = NSLocalizedString(@"Unknown", @"");
            self.whoFirstName = @"";
            self.idAddressBook = nil;
        }
    }
    if ((abId == nil || [abId intValue] == 0) && [self.whoName length] == 0 && [self.whoFirstName length] == 0) {
        self.whoName = NSLocalizedString(@"Unknown", @"");
    }
    
    // Update displayName
    CFArrayRef people = ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)[NSString stringWithFormat:@"%@ %@", self.whoFirstName, self.whoName]);
    if (self.whoFirstName == nil) {
        self.whoFirstName = @"";
    }
    if (self.whoName == nil) {
        self.whoName = @"";
    }
    if ((people != nil) && (CFArrayGetCount(people) > 0)) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, 0);
        if (person != nil) {
            self.displayName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
        } else { 
            self.displayName = [NSString stringWithFormat:@"%@ %@", self.whoFirstName, self.whoName];
        }
    } else {
        self.displayName = [NSString stringWithFormat:@"%@ %@", self.whoFirstName, self.whoName];
    }
    if (people != nil) {
        CFRelease(people);
    }

    if (addressBook != nil) {
        CFRelease(addressBook);
    }
}

- (UIImage *) contactPicture {
    // Get contact from Address Book
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)[NSString stringWithFormat:@"%@ %@", self.whoFirstName, self.whoName]);
    if ((people != nil) && (CFArrayGetCount(people) > 0)) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, 0);
        if (person != nil && ABPersonHasImageData(person)) {
            if ( &ABPersonCopyImageDataWithFormat != nil ) {
                UIImage *image = [UIImage imageWithData:(__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)];
                CFRelease(people);
                if (addressBook != nil) {
                    CFRelease(addressBook);
                }
                return image;
            } else { 
                UIImage *image = [UIImage imageWithData:(NSData *)(__bridge_transfer NSData *)ABPersonCopyImageData(person)];
                CFRelease(people);
                if (addressBook != nil) {
                    CFRelease(addressBook);
                }
                return image;
            }
        } else { 
            CFRelease(people);
            if (addressBook != nil) {
                CFRelease(addressBook);
            }
            return nil;
        }
    } else {
        if (people != nil) {
            CFRelease(people);
        }
        if (addressBook != nil) {
            CFRelease(addressBook);
        }
        return nil;
    }
}


@end
