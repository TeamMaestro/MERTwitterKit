// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitTweet.m instead.

#import "_TwitterKitTweet.h"

const struct TwitterKitTweetAttributes TwitterKitTweetAttributes = {
	.identity = @"identity",
	.text = @"text",
};

const struct TwitterKitTweetRelationships TwitterKitTweetRelationships = {
	.user = @"user",
};

const struct TwitterKitTweetFetchedProperties TwitterKitTweetFetchedProperties = {
};

@implementation TwitterKitTweetID
@end

@implementation _TwitterKitTweet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitTweet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitTweet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitTweet" inManagedObjectContext:moc_];
}

- (TwitterKitTweetID*)objectID {
	return (TwitterKitTweetID*)[super objectID];
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





@dynamic text;






@dynamic user;

	






@end
