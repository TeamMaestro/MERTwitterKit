// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitMedia.m instead.

#import "_TwitterKitMedia.h"

const struct TwitterKitMediaAttributes TwitterKitMediaAttributes = {
	.displayUrl = @"displayUrl",
	.endTextIndex = @"endTextIndex",
	.expandedUrl = @"expandedUrl",
	.identity = @"identity",
	.mediaUrl = @"mediaUrl",
	.startTextIndex = @"startTextIndex",
	.type = @"type",
	.url = @"url",
};

const struct TwitterKitMediaRelationships TwitterKitMediaRelationships = {
	.sizes = @"sizes",
	.tweet = @"tweet",
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
	
	if ([key isEqualToString:@"endTextIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"endTextIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identity"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"startTextIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"startTextIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic displayUrl;






@dynamic endTextIndex;



- (int16_t)endTextIndexValue {
	NSNumber *result = [self endTextIndex];
	return [result shortValue];
}

- (void)setEndTextIndexValue:(int16_t)value_ {
	[self setEndTextIndex:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveEndTextIndexValue {
	NSNumber *result = [self primitiveEndTextIndex];
	return [result shortValue];
}

- (void)setPrimitiveEndTextIndexValue:(int16_t)value_ {
	[self setPrimitiveEndTextIndex:[NSNumber numberWithShort:value_]];
}





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






@dynamic startTextIndex;



- (int16_t)startTextIndexValue {
	NSNumber *result = [self startTextIndex];
	return [result shortValue];
}

- (void)setStartTextIndexValue:(int16_t)value_ {
	[self setStartTextIndex:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveStartTextIndexValue {
	NSNumber *result = [self primitiveStartTextIndex];
	return [result shortValue];
}

- (void)setPrimitiveStartTextIndexValue:(int16_t)value_ {
	[self setPrimitiveStartTextIndex:[NSNumber numberWithShort:value_]];
}





@dynamic type;






@dynamic url;






@dynamic sizes;

	
- (NSMutableSet*)sizesSet {
	[self willAccessValueForKey:@"sizes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"sizes"];
  
	[self didAccessValueForKey:@"sizes"];
	return result;
}
	

@dynamic tweet;

	






@end
