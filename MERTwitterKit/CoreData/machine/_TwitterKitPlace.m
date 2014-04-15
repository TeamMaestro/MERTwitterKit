// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitPlace.m instead.

#import "_TwitterKitPlace.h"

const struct TwitterKitPlaceAttributes TwitterKitPlaceAttributes = {
	.boundingBox = @"boundingBox",
	.country = @"country",
	.countryCode = @"countryCode",
	.fullName = @"fullName",
	.identity = @"identity",
	.name = @"name",
	.type = @"type",
};

const struct TwitterKitPlaceRelationships TwitterKitPlaceRelationships = {
	.containedWithin = @"containedWithin",
	.contains = @"contains",
	.tweet = @"tweet",
};

const struct TwitterKitPlaceFetchedProperties TwitterKitPlaceFetchedProperties = {
};

@implementation TwitterKitPlaceID
@end

@implementation _TwitterKitPlace

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitPlace" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitPlace";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitPlace" inManagedObjectContext:moc_];
}

- (TwitterKitPlaceID*)objectID {
	return (TwitterKitPlaceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic boundingBox;






@dynamic country;






@dynamic countryCode;






@dynamic fullName;






@dynamic identity;






@dynamic name;






@dynamic type;






@dynamic containedWithin;

	
- (NSMutableSet*)containedWithinSet {
	[self willAccessValueForKey:@"containedWithin"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"containedWithin"];
  
	[self didAccessValueForKey:@"containedWithin"];
	return result;
}
	

@dynamic contains;

	
- (NSMutableSet*)containsSet {
	[self willAccessValueForKey:@"contains"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"contains"];
  
	[self didAccessValueForKey:@"contains"];
	return result;
}
	

@dynamic tweet;

	






@end
