// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitUser.m instead.

#import "_TwitterKitUser.h"

const struct TwitterKitUserAttributes TwitterKitUserAttributes = {
	.followersCount = @"followersCount",
	.friendsCount = @"friendsCount",
	.identity = @"identity",
	.name = @"name",
	.profileImageUrl = @"profileImageUrl",
	.screenName = @"screenName",
};

const struct TwitterKitUserRelationships TwitterKitUserRelationships = {
	.mentions = @"mentions",
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
	
	if ([key isEqualToString:@"followersCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"followersCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"friendsCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"friendsCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identity"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic followersCount;



- (int32_t)followersCountValue {
	NSNumber *result = [self followersCount];
	return [result intValue];
}

- (void)setFollowersCountValue:(int32_t)value_ {
	[self setFollowersCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFollowersCountValue {
	NSNumber *result = [self primitiveFollowersCount];
	return [result intValue];
}

- (void)setPrimitiveFollowersCountValue:(int32_t)value_ {
	[self setPrimitiveFollowersCount:[NSNumber numberWithInt:value_]];
}





@dynamic friendsCount;



- (int32_t)friendsCountValue {
	NSNumber *result = [self friendsCount];
	return [result intValue];
}

- (void)setFriendsCountValue:(int32_t)value_ {
	[self setFriendsCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFriendsCountValue {
	NSNumber *result = [self primitiveFriendsCount];
	return [result intValue];
}

- (void)setPrimitiveFriendsCountValue:(int32_t)value_ {
	[self setPrimitiveFriendsCount:[NSNumber numberWithInt:value_]];
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






@dynamic mentions;

	
- (NSMutableSet*)mentionsSet {
	[self willAccessValueForKey:@"mentions"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"mentions"];
  
	[self didAccessValueForKey:@"mentions"];
	return result;
}
	

@dynamic tweets;

	
- (NSMutableSet*)tweetsSet {
	[self willAccessValueForKey:@"tweets"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tweets"];
  
	[self didAccessValueForKey:@"tweets"];
	return result;
}
	






@end
