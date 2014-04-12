// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitHashtag.m instead.

#import "_TwitterKitHashtag.h"

const struct TwitterKitHashtagAttributes TwitterKitHashtagAttributes = {
	.range = @"range",
	.text = @"text",
};

const struct TwitterKitHashtagRelationships TwitterKitHashtagRelationships = {
	.tweet = @"tweet",
};

const struct TwitterKitHashtagFetchedProperties TwitterKitHashtagFetchedProperties = {
};

@implementation TwitterKitHashtagID
@end

@implementation _TwitterKitHashtag

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitHashtag" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitHashtag";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitHashtag" inManagedObjectContext:moc_];
}

- (TwitterKitHashtagID*)objectID {
	return (TwitterKitHashtagID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic range;






@dynamic text;






@dynamic tweet;

	






@end
