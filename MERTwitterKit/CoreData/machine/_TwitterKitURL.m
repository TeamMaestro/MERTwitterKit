// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitURL.m instead.

#import "_TwitterKitURL.h"

const struct TwitterKitURLAttributes TwitterKitURLAttributes = {
	.displayUrl = @"displayUrl",
	.endTextIndex = @"endTextIndex",
	.expandedUrl = @"expandedUrl",
	.startTextIndex = @"startTextIndex",
	.url = @"url",
};

const struct TwitterKitURLRelationships TwitterKitURLRelationships = {
	.tweet = @"tweet",
};

const struct TwitterKitURLFetchedProperties TwitterKitURLFetchedProperties = {
};

@implementation TwitterKitURLID
@end

@implementation _TwitterKitURL

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitURL" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitURL";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitURL" inManagedObjectContext:moc_];
}

- (TwitterKitURLID*)objectID {
	return (TwitterKitURLID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"endTextIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"endTextIndex"];
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





@dynamic url;






@dynamic tweet;

	






@end
