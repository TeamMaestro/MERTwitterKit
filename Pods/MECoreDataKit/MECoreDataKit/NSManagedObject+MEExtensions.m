//
//  NSManagedObject+MEExtensions.m
//  MECoreDataKit
//
//  Created by William Towe on 1/16/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "NSManagedObject+MEExtensions.h"

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

@implementation NSManagedObject (MEExtensions)

- (NSDictionary *)ME_JSONRepresentation; {
    return [self ME_JSONRepresentationWithIdentityKey:@"identity" includeRelationships:NO];
}
- (NSDictionary *)ME_JSONRepresentationWithIdentityKey:(NSString *)identityKey; {
    return [self ME_JSONRepresentationWithIdentityKey:identityKey includeRelationships:NO];
}
- (NSDictionary *)ME_JSONRepresentationWithIdentityKey:(NSString *)identityKey includeRelationships:(BOOL)includeRelationships; {
    NSMutableDictionary *retval = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self.entity.attributesByName enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, NSAttributeDescription *attributeDesc, BOOL *stop) {
        switch (attributeDesc.attributeType) {
            case NSDateAttributeType: {
                NSDate *value = [self valueForKey:attributeName];
                
                if (value)
                    [retval setObject:@(value.timeIntervalSince1970) forKey:attributeName];
            }
                break;
            case NSInteger16AttributeType:
            case NSInteger32AttributeType:
            case NSInteger64AttributeType: {
                NSNumber *value = [self valueForKey:attributeName];
                
                if (value)
                    [retval setObject:value forKey:attributeName];
            }
                break;
            case NSFloatAttributeType:
            case NSDoubleAttributeType:
            case NSDecimalAttributeType: {
                NSNumber *value = [self valueForKey:attributeName];
                
                if (value)
                    [retval setObject:value forKey:attributeName];
            }
                break;
            case NSStringAttributeType: {
                NSNumber *value = [self valueForKey:attributeName];
                
                if (value)
                    [retval setObject:value forKey:attributeName];
            }
                break;
            case NSBooleanAttributeType: {
                NSNumber *value = [self valueForKey:attributeName];
                
                if (value)
                    [retval setObject:value forKey:attributeName];
            }
                break;
            case NSBinaryDataAttributeType: {
                NSData *value = [self valueForKey:attributeName];
                
                if (value)
                    [retval setObject:[value base64EncodedStringWithOptions:0] forKey:attributeName];
            }
                break;
            default:
                break;
        }
    }];
    
    if (includeRelationships) {
        [self.entity.relationshipsByName enumerateKeysAndObjectsUsingBlock:^(NSString *relationshipName, NSRelationshipDescription *relationshipDesc, BOOL *stop) {
            if ([relationshipDesc.destinationEntity.attributesByName objectForKey:identityKey]) {
                if (relationshipDesc.isToMany) {
                    id <NSFastEnumeration> relationship = [self valueForKey:relationshipName];
                    NSMutableArray *identities = [NSMutableArray arrayWithCapacity:0];
                    
                    for (NSManagedObject *object in relationship)
                        [identities addObject:[object valueForKey:identityKey]];
                    
                    if (identities.count > 0)
                        [retval setObject:identities forKey:relationshipName];
                }
                else {
                    NSManagedObject *relationshipObject = [self valueForKey:relationshipName];
                    
                    if (relationshipObject)
                        [retval setObject:[relationshipObject valueForKey:identityKey] forKey:relationshipName];
                }
            }
        }];
    }
    
    return retval;
}

@end
