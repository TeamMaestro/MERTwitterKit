// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MERTweet.m instead.

#import "_MERTweet.h"

const struct MERTweetAttributes MERTweetAttributes = {
	.identity = @"identity",
	.text = @"text",
};

const struct MERTweetRelationships MERTweetRelationships = {
};

const struct MERTweetFetchedProperties MERTweetFetchedProperties = {
};

@implementation MERTweetID
@end

@implementation _MERTweet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MERTweet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MERTweet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MERTweet" inManagedObjectContext:moc_];
}

- (MERTweetID*)objectID {
	return (MERTweetID*)[super objectID];
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











@end
