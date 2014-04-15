// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitMediaRange.m instead.

#import "_TwitterKitMediaRange.h"

const struct TwitterKitMediaRangeAttributes TwitterKitMediaRangeAttributes = {
	.range = @"range",
};

const struct TwitterKitMediaRangeRelationships TwitterKitMediaRangeRelationships = {
	.media = @"media",
	.tweet = @"tweet",
};

const struct TwitterKitMediaRangeFetchedProperties TwitterKitMediaRangeFetchedProperties = {
};

@implementation TwitterKitMediaRangeID
@end

@implementation _TwitterKitMediaRange

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitMediaRange" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitMediaRange";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitMediaRange" inManagedObjectContext:moc_];
}

- (TwitterKitMediaRangeID*)objectID {
	return (TwitterKitMediaRangeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic range;






@dynamic media;

	

@dynamic tweet;

	






@end
