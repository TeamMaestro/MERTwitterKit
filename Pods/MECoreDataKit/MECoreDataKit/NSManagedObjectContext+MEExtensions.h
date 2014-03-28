//
//  NSManagedObjectContext+MEExtensions.h
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

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (MEExtensions)

/**
 Saves the receiver and then saves the receiver's parent context and so on.
 
 @param error The error that results from the save operation, if any
 @return YES if all saves completed successfully, NO otherwise
 */
- (BOOL)ME_saveRecursively:(NSError **)error;

/**
 Returns the objects corresponding to the `NSManagedObjectID` instances in `objectIDs`
 
 @param objectIDs An array of `NSManagedObjectID` instances
 @return The array of `NSManagedObject` instances corresponding to the ids in `objectIDs`
 */
- (NSArray *)ME_objectsForObjectIDs:(NSArray *)objectIDs;

/**
 Calls through to `ME_fetchEntityNamed:limit:offset:predicate:sortDescriptors:error:`, passing 0 for the _limit_ and _offset_ parameters.
 */
- (NSArray *)ME_fetchEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error;
/**
 Calls through to `ME_fetchEntityNamed:limit:offset:predicate:sortDescriptors:error:`, passing 0 for the _offset_ parameter.
 */
- (NSArray *)ME_fetchEntityNamed:(NSString *)entityName limit:(NSUInteger)limit predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error;
/**
 Constructs a fetch request for the entity named `entityName` using `predicate` and `sortDescriptors` and returns the result
 
 @param entityName The name of the entity to fetch
 @param limit The fetch limit of the constructed fetch request
 @param offset The fetch offset of the constructed fetch request
 @param predicate The predicate that will constrain the resulting set of objects
 @param sortDescriptors An array of sort descriptors to apply to the resulting set of objects
 @param error An `NSError` object, returned by reference describing the reason the fetch request failed
 @exception NSException Thrown if `entityName` is nil
 @return An `NSArray` of `NSManagedObject` instances
 */
- (NSArray *)ME_fetchEntityNamed:(NSString *)entityName limit:(NSUInteger)limit offset:(NSUInteger)offset predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error;

/**
 Constructs a fetch request for the entity named `entityName` using `predicate` and `sortDescriptors` and calls the completion block with the result
 
 @param entityName The name of the entity to fetch
 @exception NSException Thrown if `entityName` is nil
 @param predicate The predicate that will constrain the resulting set of objects
 @param sortDescriptors An array of sort descriptors to apply to the resulting set of objects
 @param completion The completion block, which takes two arguments: The resulting objects and an error object describing why the fetch request failed
 @exception NSException Thrown if `completion` is nil
 */
- (void)ME_fetchEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors completion:(void (^)(NSArray *objects,NSError *error))completion;

/**
 Identical to `ME_fetchEntityNamed:predicate:sortDescriptors:error:` but returns the result of calling `countForFetchRequest:error:` instead of `executeFetchRequest:error:`
 
 @see ME_fetchEntityNamed:predicate:sortDescriptors:error:
 */
- (NSUInteger)ME_countForEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError **)error;

/**
 Identical to `ME_fetchEntityNamed:predicate:sortDescriptors:error:` but sets the result type of the constructed fetch request to `NSDictionaryResultType` and then sets the properties to fetch to `properties`
 
 @see ME_fetchEntityNamed:predicate:sortDescriptors:error:
 */
- (NSArray *)ME_fetchProperties:(NSArray *)properties forEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error;

/**
 Returns the default identity key used for comparing model entities to json entities
 
 @return The default identity key
 */
+ (NSString *)ME_defaultIdentityKey;
/**
 Sets the default identity key used for comparing model entities to json entities
 
 @param key The new default identity key
 */
+ (void)ME_setDefaultIdentityKey:(NSString *)key;

/**
 Returns the default `NSDateFormatter` used to turn `NSString` instances into `NSDate` instances
 
 @return The default `NSDateFormatter` instance
 */
+ (NSDateFormatter *)ME_defaultDateFormatter;
/**
 Sets the default `NSDateFormatter` instance that will be used to turn `NSString` instances into `NSDate` instances
 
 @param dateFormatter The default date formatter
 */
+ (void)ME_setDefaultDateFormatter:(NSDateFormatter *)dateFormatter;

/**
 Imports a json container into the receiver, creating and updating entities as needed
 
 @param json The json container (`NSDictionary`, `NSArray`, `NSOrderedSet`, or `NSSet`)
 @param entityOrder An array specifying the order in which entities should be imported. If _json_ is not an `NSDictionary`, _entityOrder_ must contain a single entity name
 @param entityTransformer A value transformer that will transform the entity name specified in the json and transform it into the entity name of the model. If nil, the entity names in the json must match the entity names in the model exactly
 @param propertyTransformer A value transformer that will transform the property name from an entity dictionary into the property name of the model. If nil, the property names in the json must match the property names in the model exactly
 @param completion A completion block that is invoked when the operation completes
 */
- (void)ME_importJSON:(id<NSFastEnumeration,NSObject>)json entityOrder:(NSArray *)entityOrder entityTransformer:(NSValueTransformer *)entityTransformer propertyTransformer:(NSValueTransformer *)propertyTransformer completion:(void (^)(BOOL success,NSError *error))completion;

/**
 Creates or updates an entity in the receiver from the given dictionary
 
 @param dictionary A dictionary of attributes and relationships
 @param entityName The name of the entity to create
 @param propertyTransformer A value transformer that will transform the property name the dictionary into the property name of the model. If nil, the property names in the dictionary must match the property names in the model exactly
 @param includeProperties Whether properties in addition to the identity property will be updated
 @param includeRelationships Whether relationships will be followed and populated
 @param error A pointer to an `NSError` object. If this method returns nil and _error_ is non-nil, error will point to an `NSError` that describes the reason for failure
 */
- (NSManagedObject *)ME_managedObjectWithDictionary:(NSDictionary *)dictionary entityName:(NSString *)entityName propertyTransformer:(NSValueTransformer *)propertyTransformer includeProperties:(BOOL)includeProperties includeRelationships:(BOOL)includeRelationships error:(NSError **)error;
@end
