// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitMediaSize.m instead.

#import "_TwitterKitMediaSize.h"

const struct TwitterKitMediaSizeAttributes TwitterKitMediaSizeAttributes = {
	.height = @"height",
	.name = @"name",
	.resize = @"resize",
	.width = @"width",
};

const struct TwitterKitMediaSizeRelationships TwitterKitMediaSizeRelationships = {
	.media = @"media",
};

const struct TwitterKitMediaSizeFetchedProperties TwitterKitMediaSizeFetchedProperties = {
};

@implementation TwitterKitMediaSizeID
@end

@implementation _TwitterKitMediaSize

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitMediaSize" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitMediaSize";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitMediaSize" inManagedObjectContext:moc_];
}

- (TwitterKitMediaSizeID*)objectID {
	return (TwitterKitMediaSizeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"heightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"height"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"widthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"width"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic height;



- (int16_t)heightValue {
	NSNumber *result = [self height];
	return [result shortValue];
}

- (void)setHeightValue:(int16_t)value_ {
	[self setHeight:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveHeightValue {
	NSNumber *result = [self primitiveHeight];
	return [result shortValue];
}

- (void)setPrimitiveHeightValue:(int16_t)value_ {
	[self setPrimitiveHeight:[NSNumber numberWithShort:value_]];
}





@dynamic name;






@dynamic resize;






@dynamic width;



- (int16_t)widthValue {
	NSNumber *result = [self width];
	return [result shortValue];
}

- (void)setWidthValue:(int16_t)value_ {
	[self setWidth:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveWidthValue {
	NSNumber *result = [self primitiveWidth];
	return [result shortValue];
}

- (void)setPrimitiveWidthValue:(int16_t)value_ {
	[self setPrimitiveWidth:[NSNumber numberWithShort:value_]];
}





@dynamic media;

	






@end
