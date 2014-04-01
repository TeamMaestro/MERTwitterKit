// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitHashTag.m instead.

#import "_TwitterKitHashTag.h"

const struct TwitterKitHashTagAttributes TwitterKitHashTagAttributes = {
	.endStartIndex = @"endStartIndex",
	.startTextIndex = @"startTextIndex",
	.text = @"text",
};

const struct TwitterKitHashTagRelationships TwitterKitHashTagRelationships = {
	.tweets = @"tweets",
};

const struct TwitterKitHashTagFetchedProperties TwitterKitHashTagFetchedProperties = {
};

@implementation TwitterKitHashTagID
@end

@implementation _TwitterKitHashTag

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitHashTag" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitHashTag";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitHashTag" inManagedObjectContext:moc_];
}

- (TwitterKitHashTagID*)objectID {
	return (TwitterKitHashTagID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"endStartIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"endStartIndex"];
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




@dynamic endStartIndex;



- (int16_t)endStartIndexValue {
	NSNumber *result = [self endStartIndex];
	return [result shortValue];
}

- (void)setEndStartIndexValue:(int16_t)value_ {
	[self setEndStartIndex:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveEndStartIndexValue {
	NSNumber *result = [self primitiveEndStartIndex];
	return [result shortValue];
}

- (void)setPrimitiveEndStartIndexValue:(int16_t)value_ {
	[self setPrimitiveEndStartIndex:[NSNumber numberWithShort:value_]];
}





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





@dynamic text;






@dynamic tweets;

	
- (NSMutableSet*)tweetsSet {
	[self willAccessValueForKey:@"tweets"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tweets"];
  
	[self didAccessValueForKey:@"tweets"];
	return result;
}
	






@end
