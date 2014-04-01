// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitMediaSize.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitMediaSizeAttributes {
	__unsafe_unretained NSString *height;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *resize;
	__unsafe_unretained NSString *width;
} TwitterKitMediaSizeAttributes;

extern const struct TwitterKitMediaSizeRelationships {
	__unsafe_unretained NSString *media;
} TwitterKitMediaSizeRelationships;

extern const struct TwitterKitMediaSizeFetchedProperties {
} TwitterKitMediaSizeFetchedProperties;

@class TwitterKitMedia;






@interface TwitterKitMediaSizeID : NSManagedObjectID {}
@end

@interface _TwitterKitMediaSize : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitMediaSizeID*)objectID;





@property (nonatomic, strong) NSNumber* height;



@property int16_t heightValue;
- (int16_t)heightValue;
- (void)setHeightValue:(int16_t)value_;

//- (BOOL)validateHeight:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* resize;



//- (BOOL)validateResize:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* width;



@property int16_t widthValue;
- (int16_t)widthValue;
- (void)setWidthValue:(int16_t)value_;

//- (BOOL)validateWidth:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *media;

- (NSMutableSet*)mediaSet;





@end

@interface _TwitterKitMediaSize (CoreDataGeneratedAccessors)

- (void)addMedia:(NSSet*)value_;
- (void)removeMedia:(NSSet*)value_;
- (void)addMediaObject:(TwitterKitMedia*)value_;
- (void)removeMediaObject:(TwitterKitMedia*)value_;

@end

@interface _TwitterKitMediaSize (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveHeight;
- (void)setPrimitiveHeight:(NSNumber*)value;

- (int16_t)primitiveHeightValue;
- (void)setPrimitiveHeightValue:(int16_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveResize;
- (void)setPrimitiveResize:(NSString*)value;




- (NSNumber*)primitiveWidth;
- (void)setPrimitiveWidth:(NSNumber*)value;

- (int16_t)primitiveWidthValue;
- (void)setPrimitiveWidthValue:(int16_t)value_;





- (NSMutableSet*)primitiveMedia;
- (void)setPrimitiveMedia:(NSMutableSet*)value;


@end
