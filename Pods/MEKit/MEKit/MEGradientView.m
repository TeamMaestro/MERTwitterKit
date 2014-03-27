//
//  MEGradientView.m
//  MEKit
//
//  Created by William Towe on 4/15/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MEGradientView.h"

#import <QuartzCore/QuartzCore.h>

@interface MEGradientView ()
@property (readonly,nonatomic) CAGradientLayer *gradientLayer;

- (void)_MEGradientView_init;
@end

@implementation MEGradientView

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MEGradientView_init];
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MEGradientView_init];
    
    return self;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

@dynamic colors;
- (NSArray *)colors {
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:0];
    NSArray *colors = self.gradientLayer.colors;
    
    for (NSUInteger i=0; i<colors.count; i++) {
        CGColorRef color = (__bridge CGColorRef)[colors objectAtIndex:i];
        
        [retval addObject:[UIColor colorWithCGColor:color]];
    }
    
    return retval;
}
- (void)setColors:(NSArray *)colors {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:colors.count];
    
    for (UIColor *color in colors)
        [temp addObject:(__bridge id)color.CGColor];
    
    [self.gradientLayer setColors:temp];
}
@dynamic locations;
- (NSArray *)locations {
    return self.gradientLayer.locations;
}
- (void)setLocations:(NSArray *)locations {
    [self.gradientLayer setLocations:locations];
}

@dynamic startPoint;
- (CGPoint)startPoint {
    return self.gradientLayer.startPoint;
}
- (void)setStartPoint:(CGPoint)startPoint {
    [self.gradientLayer setStartPoint:startPoint];
}
@dynamic endPoint;
- (CGPoint)endPoint {
    return self.gradientLayer.endPoint;
}
- (void)setEndPoint:(CGPoint)endPoint {
    [self.gradientLayer setEndPoint:endPoint];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

- (void)_MEGradientView_init; {
    [self setBackgroundColor:[UIColor clearColor]];
}

@end
