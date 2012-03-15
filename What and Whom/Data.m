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
            self.whoName = NSLocalizedString(@"Unknown", @"Unknown contact");
            self.whoFirstName = @"";
            self.idAddressBook = nil;
        }
    }
    if (abId == nil && [self.whoName length] == 0 && [self.whoFirstName length] == 0) {
        self.whoName = NSLocalizedString(@"Unknown", @"Unknown contact");
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

    CFRelease(addressBook);
}

// Remet comme avant
//- (void) migrateContactWithId:(NSNumber *)abId {
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    
//    CFArrayRef people = ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)[NSString stringWithFormat:@"%@ %@", self.whoFirstName, self.whoName]);
//    if ((people != nil) && (CFArrayGetCount(people) > 0)) {
//        ABRecordRef person = CFArrayGetValueAtIndex(people, 0);
//        if (person != nil) {
//            self.whoName = nil;
//            self.whoFirstName = nil;
//            self.idAddressBook = [NSNumber numberWithInteger: ABRecordGetRecordID(person)];
//        }
//    } else {
//        self.whoName = nil;
//        self.whoFirstName = nil;
//        self.idAddressBook = [NSNumber numberWithInteger: 0];
//    }
//    if (people != nil) {
//        CFRelease(people);
//    }
//    CFRelease(addressBook);
//}
//
//- (NSString *) displayName {
//    // Get contact from Address Book
//    NSLog(@"%@ %@ %@ %@", self.idAddressBook, self.whoName, self.whoFirstName, self.itemName);
//    
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    CFArrayRef people = ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)[NSString stringWithFormat:@"%@ %@", self.whoFirstName, self.whoName]);
//    if ((people != nil) && (CFArrayGetCount(people) > 0)) {
//        ABRecordRef person = CFArrayGetValueAtIndex(people, 0);
//        if (person != nil) {
//            NSString *name = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
//            CFRelease(addressBook);
//            CFRelease(people);
//            return name;
//        } else { 
//            CFRelease(addressBook);
//            CFRelease(people);
//            return NSLocalizedString(@"Unknown", @"Unknown contact");
//        }
//    } else {
//        if (people != nil) {
//            CFRelease(people);
//        }
//        NSString *nameToDisplay = [NSString stringWithFormat:@"%@ %@", self.whoFirstName, self.whoName];
//        if ([nameToDisplay isEqualToString:@" "] || [nameToDisplay isEqualToString:@"(null) (null)"]) {
//            CFRelease(addressBook);
//            return NSLocalizedString(@"Unknown", @"Unknown contact");
//        } else {
//            CFRelease(addressBook);
//            return [NSString stringWithFormat:@"%@ %@", self.whoFirstName, self.whoName];
//        }
//    }
//}

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
                CFRelease(addressBook);
                return image;
            } else { 
                UIImage *image = [UIImage imageWithData:(NSData *)(__bridge_transfer NSData *)ABPersonCopyImageData(person)];
                CFRelease(people);
                CFRelease(addressBook);
                return image;
            }
        } else { 
            CFRelease(people);
            CFRelease(addressBook);
            return nil;
        }
    } else {
        if (people != nil) {
            CFRelease(people);
        }
        CFRelease(addressBook);
        return nil;
    }
}


@end
