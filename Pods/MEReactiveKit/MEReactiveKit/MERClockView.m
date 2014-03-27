//
//  MERClockView.m
//  MEReactiveKit
//
//  Created by William Towe on 3/9/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERClockView.h"
#import <MEFoundation/NSDate+MEExtensions.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTKeyPathCoding.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEDebugging.h>

#import <QuartzCore/QuartzCore.h>

static inline CGFloat kMERClockViewDegreesToRadians(CGFloat degrees) {
    return (degrees * (M_PI / 180.0));
}

static CGFloat const kMERClockViewLayerWidth = 1.0;

@interface MERClockView ()
@property (strong,nonatomic) CAShapeLayer *borderLayer;
@property (strong,nonatomic) CALayer *containerLayer;
@property (strong,nonatomic) CAShapeLayer *hourLayer;
@property (strong,nonatomic) CAShapeLayer *minuteLayer;

- (void)_MERClockView_init;
+ (UIColor *)_defaultColor;
+ (NSTimeInterval)_defaultTimeAnimationDuration;
+ (NSDate *)_defaultTime;
@end

@implementation MERClockView
#pragma mark *** Subclass Overrides ***
- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MERClockView_init];
    
    return self;
}
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERClockView_init];
    
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];

    if ([self.layer isEqual:layer]) {
        [self.borderLayer setFrame:self.bounds];
        [self.borderLayer setPath:[UIBezierPath bezierPathWithOvalInRect:self.layer.bounds].CGPath];
        
        [self.containerLayer setFrame:self.bounds];
        [self.containerLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
        
        CGPoint center = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds));
        CGFloat length = MIN(CGRectGetWidth(self.layer.bounds), CGRectGetHeight(self.layer.bounds)) * 0.5;
        CGFloat minuteLength = length * 0.75;
        CGFloat hourLength = length * 0.6;
        
        [self.hourLayer setPosition:center];
        [self.hourLayer setBounds:CGRectMake(0, 0, kMERClockViewLayerWidth, hourLength)];
        [self.hourLayer setAnchorPoint:CGPointMake(0.5, 0)];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:self.hourLayer.anchorPoint];
        [path addLineToPoint:CGPointMake(self.hourLayer.anchorPoint.x, hourLength)];
        
        [self.hourLayer setPath:path.CGPath];
        
        [self.minuteLayer setPosition:center];
        [self.minuteLayer setBounds:CGRectMake(0, 0, kMERClockViewLayerWidth, minuteLength)];
        [self.minuteLayer setAnchorPoint:CGPointMake(0.5, 0)];
        
        path = [UIBezierPath bezierPath];
        
        [path moveToPoint:self.minuteLayer.anchorPoint];
        [path addLineToPoint:CGPointMake(self.minuteLayer.anchorPoint.x, minuteLength)];
        
        [self.minuteLayer setPath:path.CGPath];
    }
}
#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setTime:(NSDate *)time {
    [self setTime:time animated:NO];
}
- (void)setTime:(NSDate *)time animated:(BOOL)animated {
    [self willChangeValueForKey:@keypath(self,time)];
    _time = (time) ?: [self.class _defaultTime];
    [self didChangeValueForKey:@keypath(self,time)];
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self.time];
    CGFloat minuteAngle = kMERClockViewDegreesToRadians(comps.minute / NSMaxRange([[NSCalendar currentCalendar] maximumRangeOfUnit:NSCalendarUnitMinute]) * 360.0);
    CGFloat hourAngle = kMERClockViewDegreesToRadians(comps.hour / 12.0 * 360.0) + minuteAngle / 12.0;
    CATransform3D minuteTransform = CATransform3DMakeRotation(minuteAngle + M_PI, 0, 0, 1);
    CATransform3D hourTransform = CATransform3DMakeRotation(hourAngle + M_PI, 0, 0, 1);
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.timeAnimationDuration];
    [CATransaction setDisableActions:!animated];
    
    [self.minuteLayer setTransform:minuteTransform];
    [self.hourLayer setTransform:hourTransform];
    
    [CATransaction commit];
}

- (void)setTimeAnimationDuration:(NSTimeInterval)timeAnimationDuration {
    _timeAnimationDuration = (timeAnimationDuration <= 0.0) ? [self.class _defaultTimeAnimationDuration] : timeAnimationDuration;
}
- (void)setColor:(UIColor *)color {
    _color = (color) ?: [self.class _defaultColor];
}
#pragma mark *** Private Methods ***
- (void)_MERClockView_init; {
    _color = [self.class _defaultColor];
    _timeAnimationDuration = [self.class _defaultTimeAnimationDuration];
    _time = [self.class _defaultTime];
    
    [self setBorderLayer:[CAShapeLayer layer]];
    [self.borderLayer setLineWidth:1];
    [self.borderLayer setFillColor:[UIColor clearColor].CGColor];
    [self.layer addSublayer:self.borderLayer];
    
    [self setContainerLayer:[CALayer layer]];
    [self.layer addSublayer:self.containerLayer];
    
    [self setMinuteLayer:[CAShapeLayer layer]];
    [self.minuteLayer setLineWidth:kMERClockViewLayerWidth];
    [self.minuteLayer setLineCap:kCALineCapRound];
    [self.containerLayer addSublayer:self.minuteLayer];
    
    [self setHourLayer:[CAShapeLayer layer]];
    [self.hourLayer setLineWidth:kMERClockViewLayerWidth];
    [self.hourLayer setLineCap:kCALineCapRound];
    [self.containerLayer addSublayer:self.hourLayer];
    
    RACSignal *colorSignal = [[[RACObserve(self, color) distinctUntilChanged] map:^id(UIColor *value) {
        return (__bridge id)value.CGColor;
    }] deliverOn:[RACScheduler mainThreadScheduler]];
    
    RAC(self.borderLayer,strokeColor) = colorSignal;
    RAC(self.hourLayer,strokeColor) = colorSignal;
    RAC(self.minuteLayer,strokeColor) = colorSignal;
}

+ (UIColor *)_defaultColor; {
    return [UIColor blackColor];
}
+ (NSTimeInterval)_defaultTimeAnimationDuration; {
    return 1.0;
}
+ (NSDate *)_defaultTime; {
    return [[NSDate date] ME_startOfDay];
}

@end
