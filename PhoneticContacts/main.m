//
//  main.m
//  PhoneticContacts
//
//  Created by Lex on 24/11/12.
//  Copyright (c) 2012 Lex Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

static NSString *phonetic(NSString *sourceString) {
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    return source;
}

static NSString *kickNull(NSString *string) {
    if (!string) return @"";
    return string;
}


static NSString *removeSpace(NSString *string) {
    if (!string) return @"";
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        ABAddressBook *ab = [ABAddressBook addressBook];
        NSMutableArray *myContacts = [NSMutableArray array];
        for (ABPerson *person in ab.people) {
            NSString *first = [person valueForProperty:kABFirstNameProperty];
            NSString *firstPinyin = first;
            NSString *last = [person valueForProperty:kABLastNameProperty];
            NSString *lastPinyin = last;
            NSMutableString *pinyin = [NSMutableString string];
            if (first) {
                firstPinyin = removeSpace(phonetic(first));
                [pinyin appendString:(firstPinyin)];
                [person setValue:(firstPinyin) forProperty:kABFirstNamePhoneticProperty];
            }
            if (last) {
                lastPinyin = removeSpace(phonetic(last));
                [pinyin appendString:(lastPinyin)];
                [person setValue:(lastPinyin) forProperty:kABLastNamePhoneticProperty];
            }
            [myContacts addObject:pinyin];
            printf("%s\n\n", [[NSString stringWithFormat:@"%@ %@=%@ %@ (LastName, FirstName)",
                           kickNull(last), kickNull(first),
                           (kickNull(lastPinyin)), (kickNull(firstPinyin))] UTF8String]);
        }
        [ab save];
        
    }
    return 0;
}

