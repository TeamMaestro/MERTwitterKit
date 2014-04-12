// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitUrl.m instead.

#import "_TwitterKitUrl.h"

const struct TwitterKitUrlAttributes TwitterKitUrlAttributes = {
	.displayUrl = @"displayUrl",
	.expandedUrl = @"expandedUrl",
	.range = @"range",
	.url = @"url",
};

const struct TwitterKitUrlRelationships TwitterKitUrlRelationships = {
	.tweet = @"tweet",
};

const struct TwitterKitUrlFetchedProperties TwitterKitUrlFetchedProperties = {
};

@implementation TwitterKitUrlID
@end

@implementation _TwitterKitUrl

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitUrl" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitUrl";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitUrl" inManagedObjectContext:moc_];
}

- (TwitterKitUrlID*)objectID {
	return (TwitterKitUrlID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic displayUrl;






@dynamic expandedUrl;






@dynamic range;






@dynamic url;






@dynamic tweet;

	






@end
