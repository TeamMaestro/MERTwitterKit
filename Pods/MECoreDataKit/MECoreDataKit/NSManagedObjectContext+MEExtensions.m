//
//  NSManagedObjectContext+MEExtensions.m
//  MECoreDataKit
//
//  Created by William Towe on 4/30/12.
//  Copyright (c) 2012 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "NSManagedObjectContext+MEExtensions.h"
#import <MEFoundation/MEFunctions.h>
#import <MEFoundation/MEDebugging.h>

#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
#import <AppKit/AppKit.h>
#else
#import <UIKit/UIKit.h>
#endif

#import <objc/runtime.h>

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

@implementation NSManagedObjectContext (MEExtensions)

- (BOOL)ME_saveRecursively:(NSError **)error {
    __block BOOL retval = YES;
    __block NSError *blockError = nil;
    
    __weak typeof(self) weakSelf = self;
    
    [self performBlockAndWait:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSError *outError;
        if ([strongSelf save:&outError]) {
            NSManagedObjectContext *parentContext = strongSelf.parentContext;
            
            while (parentContext) {
                [parentContext performBlockAndWait:^{
                    [parentContext save:NULL];
                }];
                
                parentContext = parentContext.parentContext;
            }
        }
        else {
            retval = NO;
            blockError = outError;
        }
    }];
    
    if (error)
        *error = blockError;
    
    return retval;
}

- (NSArray *)ME_objectsForObjectIDs:(NSArray *)objectIDs error:(NSError **)error; {
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:objectIDs.count];
    
    for (NSManagedObjectID *objectID in objectIDs) {
        NSManagedObject *object = [self existingObjectWithID:objectID error:error];
        
        if (!object)
            break;
        
        [retval addObject:object];
    }
    
    return retval;
}

- (NSArray *)ME_fetchEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error; {
    return [self ME_fetchEntityNamed:entityName limit:0 offset:0 predicate:predicate sortDescriptors:sortDescriptors error:error];
}
- (NSArray *)ME_fetchEntityNamed:(NSString *)entityName limit:(NSUInteger)limit predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error; {
    return [self ME_fetchEntityNamed:entityName limit:limit offset:0 predicate:predicate sortDescriptors:sortDescriptors error:error];
}
- (NSArray *)ME_fetchEntityNamed:(NSString *)entityName limit:(NSUInteger)limit offset:(NSUInteger)offset predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error; {
    NSParameterAssert(entityName);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    if (limit > 0)
        [fetchRequest setFetchLimit:limit];
    if (offset > 0)
        [fetchRequest setFetchOffset:offset];
    if (predicate)
        [fetchRequest setPredicate:predicate];
    if (sortDescriptors)
        [fetchRequest setSortDescriptors:sortDescriptors];
    
    return [self executeFetchRequest:fetchRequest error:error];
}

- (void)ME_fetchEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors completion:(void (^)(NSArray *objects,NSError *error))completion; {
    NSParameterAssert(entityName);
    NSParameterAssert(completion);
    NSParameterAssert(self.concurrencyType == NSMainQueueConcurrencyType);
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [context setUndoManager:nil];
    [context setParentContext:self];
    [context performBlock:^{
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        
        [fetchRequest setResultType:NSManagedObjectIDResultType];
        
        if (predicate)
            [fetchRequest setPredicate:predicate];
        if (sortDescriptors)
            [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSError *outError;
        NSArray *objectIDs = [context executeFetchRequest:fetchRequest error:&outError];
        
        if (objectIDs) {
            [context.parentContext performBlock:^{
                NSError *outError;
                NSArray *objects = [context.parentContext ME_objectsForObjectIDs:objectIDs error:&outError];
                
                completion(objects,outError);
            }];
        }
        else {
            MEDispatchMainAsync(^{completion(nil,outError);});
        }
    }];
}

- (NSUInteger)ME_countForEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError **)error; {
    NSParameterAssert(entityName);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    if (predicate)
        [fetchRequest setPredicate:predicate];
    
    return [self countForFetchRequest:fetchRequest error:error];
}

- (NSArray *)ME_fetchProperties:(NSArray *)properties forEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error; {
    NSParameterAssert(entityName);
    NSParameterAssert(properties);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:properties];
    
    if (predicate)
        [fetchRequest setPredicate:predicate];
    if (sortDescriptors)
        [fetchRequest setSortDescriptors:sortDescriptors];
    
    return [self executeFetchRequest:fetchRequest error:error];
}

static const void *kMEDefaultIdentityKeyKey = &kMEDefaultIdentityKeyKey;

+ (NSString *)ME_defaultIdentityKey {
    static NSString *const kRetval = @"identity";
    NSString *retval = objc_getAssociatedObject(self, kMEDefaultIdentityKeyKey);
    
    return (retval) ?: kRetval;
}
+ (void)ME_setDefaultIdentityKey:(NSString *)key {
    objc_setAssociatedObject(self, kMEDefaultIdentityKeyKey, key, OBJC_ASSOCIATION_COPY);
}

static const void *kMEDefaultDateFormatterKey = &kMEDefaultDateFormatterKey;

+ (NSDateFormatter *)ME_defaultDateFormatter {
    static NSDateFormatter *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[NSDateFormatter alloc] init];
    });
    
    NSDateFormatter *retval = objc_getAssociatedObject(self, kMEDefaultDateFormatterKey);
    
    return (retval) ?: kRetval;
}
+ (void)ME_setDefaultDateFormatter:(NSDateFormatter *)dateFormatter {
    objc_setAssociatedObject(self, kMEDefaultDateFormatterKey, dateFormatter, OBJC_ASSOCIATION_RETAIN);
}

- (void)ME_importJSON:(id<NSFastEnumeration,NSObject>)json entityOrder:(NSArray *)entityOrder entityTransformer:(NSValueTransformer *)entityTransformer propertyTransformer:(NSValueTransformer *)propertyTransformer completion:(void (^)(BOOL success,NSError *error))completion; {
    NSParameterAssert([json isKindOfClass:[NSDictionary class]] || (json && entityOrder.count > 0));
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [context setUndoManager:nil];
    [context setParentContext:self];
    [context performBlock:^{
        if ([json isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *entityNames = [NSMutableArray arrayWithCapacity:0];
            
            if (entityOrder.count == 0)
                [entityNames addObjectsFromArray:[(NSDictionary *)json allKeys]];
            else
                [entityNames addObjectsFromArray:entityOrder];
            
            for (NSString *jsonEntityName in entityNames) {
                NSString *entityName = (entityTransformer) ? [entityTransformer transformedValue:jsonEntityName] : jsonEntityName;
                NSArray *entityDicts = [(NSDictionary *)json objectForKey:jsonEntityName];
                
                for (NSDictionary *entityDict in entityDicts) {
                    NSError *outError;
                    if (![context ME_managedObjectWithDictionary:entityDict entityName:entityName propertyTransformer:propertyTransformer includeProperties:NO includeRelationships:YES error:&outError])
                        MELogObject(outError);
                }
            }
            
            for (NSString *jsonEntityName in entityNames) {
                NSString *entityName = (entityTransformer) ? [entityTransformer transformedValue:jsonEntityName] : jsonEntityName;
                NSArray *entityDicts = [(NSDictionary *)json objectForKey:jsonEntityName];
                
                for (NSDictionary *entityDict in entityDicts) {
                    NSError *outError;
                    if (![context ME_managedObjectWithDictionary:entityDict entityName:entityName propertyTransformer:propertyTransformer includeProperties:YES includeRelationships:YES error:&outError])
                        MELogObject(outError);
                }
            }
        }
        else {
            NSString *entityName = (entityTransformer) ? [entityTransformer transformedValue:entityOrder.lastObject] : entityOrder.lastObject;
            
            for (NSDictionary *entityDict in json) {
                NSError *outError;
                if (![context ME_managedObjectWithDictionary:entityDict entityName:entityName propertyTransformer:propertyTransformer includeProperties:NO includeRelationships:YES error:&outError])
                    MELogObject(outError);
            }
            
            for (NSDictionary *entityDict in json) {
                NSError *outError;
                if (![context ME_managedObjectWithDictionary:entityDict entityName:entityName propertyTransformer:propertyTransformer includeProperties:YES includeRelationships:YES error:&outError])
                    MELogObject(outError);
            }
        }
        
        NSError *outError;
        if ([context save:&outError]) {
            NSManagedObjectContext *parentContext = context.parentContext;
            
            while (parentContext) {
                [parentContext performBlockAndWait:^{
                    NSError *outError;
                    if (![parentContext save:&outError])
                        MELogObject(outError);
                }];
                
                parentContext = parentContext.parentContext;
            }
            
            if (completion) {
                MEDispatchMainAsync(^{
                    completion(YES,nil);
                });
            }
        }
        else {
            if (completion) {
                MEDispatchMainAsync(^{
                    completion(NO,outError);
                });
            }
        }
    }];
}
- (NSManagedObject *)ME_managedObjectWithDictionary:(NSDictionary *)dictionary entityName:(NSString *)entityName propertyTransformer:(NSValueTransformer *)propertyTransformer includeProperties:(BOOL)includeProperties includeRelationships:(BOOL)includeRelationships error:(NSError **)error; {
    NSParameterAssert(dictionary);
    NSParameterAssert(entityName);
    
    NSString *const kIdentityPropertyName = [self.class ME_defaultIdentityKey];
    id identity = (propertyTransformer) ? dictionary[[propertyTransformer reverseTransformedValue:kIdentityPropertyName]] : dictionary[kIdentityPropertyName];
    
    NSParameterAssert(identity);
    
    NSManagedObject *entity = [self ME_fetchEntityNamed:entityName limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",kIdentityPropertyName,identity] sortDescriptors:nil error:NULL].lastObject;
    
    if (!entity) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
        
        [entity setValue:identity forKey:kIdentityPropertyName];
        
        MELog(@"created entity %@ with identity %@",entityName,identity);
    }
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *jsonPropertyName, id value, BOOL *stop) {
        NSString *propertyName = (propertyTransformer) ? [propertyTransformer transformedValue:jsonPropertyName] : jsonPropertyName;
        NSAttributeDescription *attributeDesc = entityDesc.attributesByName[propertyName];
        NSRelationshipDescription *relationshipDesc = entityDesc.relationshipsByName[propertyName];
        
        if (attributeDesc && includeProperties) {
            switch (attributeDesc.attributeType) {
                case NSInteger16AttributeType:
                case NSInteger32AttributeType:
                case NSInteger64AttributeType:
                case NSDoubleAttributeType:
                case NSFloatAttributeType:
                case NSStringAttributeType:
                case NSBooleanAttributeType:
                    [entity setValue:([value isEqual:[NSNull null]]) ? nil : value forKey:propertyName];
                    break;
                case NSDecimalAttributeType: {
                    if ([value isKindOfClass:[NSString class]]) {
                        NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithString:value];
                        
                        [entity setValue:decimalNumber forKey:propertyName];
                    }
                    else
                        [entity setValue:nil forKey:propertyName];
                }
                    break;
                case NSDateAttributeType: {
                    if ([value isKindOfClass:[NSString class]]) {
                        NSDate *date = [[self.class ME_defaultDateFormatter] dateFromString:value];
                        
                        [entity setValue:date forKey:propertyName];
                    }
                    else if ([value isKindOfClass:[NSNumber class]])
                        [entity setValue:[NSDate dateWithTimeIntervalSince1970:[value doubleValue]] forKey:propertyName];
                    else
                        [entity setValue:nil forKey:propertyName];
                }
                    break;
                case NSBinaryDataAttributeType:
                    if ([value isKindOfClass:[NSString class]])
                        [entity setValue:[[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters] forKey:propertyName];
                    else
                        [entity setValue:nil forKey:propertyName];
                    break;
                case NSTransformableAttributeType:
                    if (attributeDesc.attributeValueClassName || attributeDesc.userInfo[@"attributeValueClassName"]) {
#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
                        if ([attributeDesc.userInfo[@"attributeValueClassName"] isEqualToString:NSStringFromClass([NSImage class])] && [value isKindOfClass:[NSString class]])
                            [entity setValue:[[NSImage alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters]] forKey:propertyName];
#else
                        if ([attributeDesc.userInfo[@"attributeValueClassName"] isEqualToString:NSStringFromClass([UIImage class])] && [value isKindOfClass:[NSString class]])
                            [entity setValue:[[UIImage alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters]] forKey:propertyName];
#endif
                        else if ([value isKindOfClass:[NSString class]])
                            [entity setValue:[[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters] forKey:propertyName];
                        else if (attributeDesc.valueTransformerName)
                            [entity setValue:[[NSValueTransformer valueTransformerForName:attributeDesc.valueTransformerName] transformedValue:value] forKey:propertyName];
                        else
                            [entity setValue:value forKey:propertyName];
                    }
                    else
                        [entity setValue:nil forKey:propertyName];
                    break;
                case NSUndefinedAttributeType:
                default:
                    break;
            }
        }
        else if (relationshipDesc && includeRelationships) {
            NSString *destEntityName = relationshipDesc.destinationEntity.name;
            
            if (relationshipDesc.isToMany) {
                if ([value isKindOfClass:[NSDictionary class]]) {
                    id destEntities = (relationshipDesc.isOrdered) ? [NSMutableOrderedSet orderedSetWithCapacity:0] : [NSMutableSet setWithCapacity:0];
                    NSManagedObject *destEntity = [self ME_managedObjectWithDictionary:value entityName:destEntityName propertyTransformer:propertyTransformer includeProperties:includeProperties includeRelationships:includeRelationships error:NULL];
                    
                    if (destEntity)
                        [destEntities addObject:destEntity];
                    
                    [entity setValue:destEntities forKey:propertyName];
                }
                else if ([value conformsToProtocol:@protocol(NSFastEnumeration)]) {
                    id destEntities = (relationshipDesc.isOrdered) ? [NSMutableOrderedSet orderedSetWithCapacity:0] : [NSMutableSet setWithCapacity:0];
                    
                    for (id destEntityIdentityOrDict in value) {
                        if ([destEntityIdentityOrDict isKindOfClass:[NSDictionary class]]) {
                            NSManagedObject *destEntity = [self ME_managedObjectWithDictionary:destEntityIdentityOrDict entityName:destEntityName propertyTransformer:propertyTransformer includeProperties:includeProperties includeRelationships:includeRelationships error:NULL];
                            
                            if (destEntity)
                                [destEntities addObject:destEntity];
                        }
                        else {
                            NSManagedObject *destEntity = [self ME_fetchEntityNamed:destEntityName limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",kIdentityPropertyName,destEntityIdentityOrDict] sortDescriptors:nil error:NULL].lastObject;
                            
                            if (destEntity)
                                [destEntities addObject:destEntity];
                        }
                    }
                    
                    [entity setValue:destEntities forKey:propertyName];
                }
                else {
                    [entity setValue:nil forKey:propertyName];
                }
            }
            else {
                if ([value isEqual:[NSNull null]]) {
                    [entity setValue:nil forKey:propertyName];
                }
                else if ([value isKindOfClass:[NSDictionary class]]) {
                    NSManagedObject *destEntity = [self ME_managedObjectWithDictionary:value entityName:destEntityName propertyTransformer:propertyTransformer includeProperties:includeProperties includeRelationships:includeRelationships error:NULL];
                    
                    [entity setValue:destEntity forKey:propertyName];
                }
                else {
                    NSManagedObject *destEntity = [self ME_fetchEntityNamed:destEntityName limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",kIdentityPropertyName,value] sortDescriptors:nil error:NULL].lastObject;
                    
                    [entity setValue:destEntity forKey:propertyName];
                }
            }
        }
    }];
    
    return entity;
}
@end
