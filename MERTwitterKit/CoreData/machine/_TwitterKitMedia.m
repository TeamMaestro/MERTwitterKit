// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitMedia.m instead.

#import "_TwitterKitMedia.h"

const struct TwitterKitMediaAttributes TwitterKitMediaAttributes = {
	.displayUrl = @"displayUrl",
	.expandedUrl = @"expandedUrl",
	.identity = @"identity",
	.mediaUrl = @"mediaUrl",
	.type = @"type",
	.url = @"url",
};

const struct TwitterKitMediaRelationships TwitterKitMediaRelationships = {
	.ranges = @"ranges",
	.sizes = @"sizes",
};

const struct TwitterKitMediaFetchedProperties TwitterKitMediaFetchedProperties = {
};

@implementation TwitterKitMediaID
@end

@implementation _TwitterKitMedia

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitMedia" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitMedia";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitMedia" inManagedObjectContext:moc_];
}

- (TwitterKitMediaID*)objectID {
	return (TwitterKitMediaID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"identityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identity"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic displayUrl;






@dynamic expandedUrl;






@dynamic identity;



- (int64_t)identityValue {
	NSNumber *result = [self identity];
	return [result longLongValue];
}

- (void)setIdentityValue:(int64_t)value_ {
	[self setIdentity:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveIdentityValue {
	NSNumber *result = [self primitiveIdentity];
	return [result longLongValue];
}

- (void)setPrimitiveIdentityValue:(int64_t)value_ {
	[self setPrimitiveIdentity:[NSNumber numberWithLongLong:value_]];
}





@dynamic mediaUrl;






@dynamic type;






@dynamic url;






@dynamic ranges;

	
- (NSMutableSet*)rangesSet {
	[self willAccessValueForKey:@"ranges"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"ranges"];
  
	[self didAccessValueForKey:@"ranges"];
	return result;
}
	

@dynamic sizes;

	
- (NSMutableSet*)sizesSet {
	[self willAccessValueForKey:@"sizes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"sizes"];
  
	[self didAccessValueForKey:@"sizes"];
	return result;
}
	






@end
