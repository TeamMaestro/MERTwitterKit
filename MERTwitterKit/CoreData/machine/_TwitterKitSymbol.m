// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitSymbol.m instead.

#import "_TwitterKitSymbol.h"

const struct TwitterKitSymbolAttributes TwitterKitSymbolAttributes = {
	.range = @"range",
	.text = @"text",
};

const struct TwitterKitSymbolRelationships TwitterKitSymbolRelationships = {
	.tweet = @"tweet",
};

const struct TwitterKitSymbolFetchedProperties TwitterKitSymbolFetchedProperties = {
};

@implementation TwitterKitSymbolID
@end

@implementation _TwitterKitSymbol

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitSymbol" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitSymbol";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitSymbol" inManagedObjectContext:moc_];
}

- (TwitterKitSymbolID*)objectID {
	return (TwitterKitSymbolID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic range;






@dynamic text;






@dynamic tweet;

	






@end
