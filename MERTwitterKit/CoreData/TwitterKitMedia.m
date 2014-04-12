#import "TwitterKitMedia.h"


@interface TwitterKitMedia ()

// Private interface goes here.

@end


@implementation TwitterKitMedia

@dynamic rangeValue;
- (NSRange)rangeValue {
    return self.range.rangeValue;
}
- (void)setRangeValue:(NSRange)rangeValue {
    [self setRange:[NSValue valueWithRange:rangeValue]];
}

@end
