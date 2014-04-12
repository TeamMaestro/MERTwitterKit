#import "TwitterKitHashtag.h"


@interface TwitterKitHashtag ()

// Private interface goes here.

@end


@implementation TwitterKitHashtag

@dynamic rangeValue;
- (NSRange)rangeValue {
    return self.range.rangeValue;
}
- (void)setRangeValue:(NSRange)rangeValue {
    [self setRange:[NSValue valueWithRange:rangeValue]];
}

@end
