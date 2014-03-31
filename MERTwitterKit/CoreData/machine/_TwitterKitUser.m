// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitUser.m instead.

#import "_TwitterKitUser.h"

const struct TwitterKitUserAttributes TwitterKitUserAttributes = {
	.identity = @"identity",
	.name = @"name",
	.profileImageUrl = @"profileImageUrl",
	.screenName = @"screenName",
};

const struct TwitterKitUserRelationships TwitterKitUserRelationships = {
	.tweets = @"tweets",
};

const struct TwitterKitUserFetchedProperties TwitterKitUserFetchedProperties = {
};

@implementation TwitterKitUserID
@end

@implementation _TwitterKitUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitUser" inManagedObjectContext:moc_];
}

- (TwitterKitUserID*)objectID {
	return (TwitterKitUserID*)[super objectID];
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





@dynamic name;






@dynamic profileImageUrl;






@dynamic screenName;






@dynamic tweets;

	
- (NSMutableSet*)tweetsSet {
	[self willAccessValueForKey:@"tweets"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tweets"];
  
	[self didAccessValueForKey:@"tweets"];
	return result;
}
	






@end
