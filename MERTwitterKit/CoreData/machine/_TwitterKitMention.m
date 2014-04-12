// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitMention.m instead.

#import "_TwitterKitMention.h"

const struct TwitterKitMentionAttributes TwitterKitMentionAttributes = {
	.range = @"range",
};

const struct TwitterKitMentionRelationships TwitterKitMentionRelationships = {
	.tweet = @"tweet",
	.user = @"user",
};

const struct TwitterKitMentionFetchedProperties TwitterKitMentionFetchedProperties = {
};

@implementation TwitterKitMentionID
@end

@implementation _TwitterKitMention

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitMention" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitMention";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitMention" inManagedObjectContext:moc_];
}

- (TwitterKitMentionID*)objectID {
	return (TwitterKitMentionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic range;






@dynamic tweet;

	

@dynamic user;

	






@end
