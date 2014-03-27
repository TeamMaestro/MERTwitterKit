//
//  NSDate+MEExtensions.m
//  MEFoundation
//
//  Created by Joshua Kovach on 4/27/12.
//  Copyright (c) 2012 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "NSDate+MEExtensions.h"

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

NSTimeInterval const METimeIntervalOneMinute = 60;
NSTimeInterval const METimeIntervalOneHour = 3600;
NSTimeInterval const METimeIntervalOneDay = 86400;
NSTimeInterval const METimeIntervalOneWeek = 604800;

@implementation NSDate (MEExtensions)

- (BOOL)ME_isBeforeDate:(NSDate *)otherDate {
    return [[self earlierDate:otherDate] isEqualToDate:self];
}

- (BOOL)ME_isAfterDate:(NSDate *)otherDate {
    return [[self laterDate:otherDate] isEqualToDate:self];
}

- (NSDateComponents *)ME_components:(NSUInteger)unitFlags toDate:(NSDate *)toDate {
    
    return [[NSCalendar currentCalendar] components:unitFlags fromDate:self toDate:toDate options:0];
}

- (NSDateComponents *)ME_components:(NSUInteger)unitFlags fromDate:(NSDate *)fromDate {
    return [[NSCalendar currentCalendar] components:unitFlags fromDate:fromDate toDate:self options:0];
}

+ (NSDate *)ME_startOfDayForDate:(NSDate *)date; {
    NSParameterAssert(date);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    
    [comps setHour:[calendar maximumRangeOfUnit:NSCalendarUnitHour].location];
    [comps setMinute:[calendar maximumRangeOfUnit:NSCalendarUnitMinute].location];
    [comps setSecond:[calendar maximumRangeOfUnit:NSCalendarUnitSecond].location + 1];
    
    return [calendar dateFromComponents:comps];
}
- (NSDate *)ME_startOfDay; {
    return [self.class ME_startOfDayForDate:self];
}
+ (NSDate *)ME_endOfDayForDate:(NSDate *)date; {
    NSParameterAssert(date);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    
    [comps setHour:NSMaxRange([calendar maximumRangeOfUnit:NSCalendarUnitHour]) - 1];
    [comps setMinute:NSMaxRange([calendar maximumRangeOfUnit:NSCalendarUnitMinute]) - 1];
    [comps setSecond:NSMaxRange([calendar maximumRangeOfUnit:NSCalendarUnitSecond]) - 1];
    
    return [calendar dateFromComponents:comps];
}
- (NSDate *)ME_endOfDay; {
    return [self.class ME_endOfDayForDate:self];
}

+ (NSDate *)ME_startOfWeekForDate:(NSDate *)date; {
    NSParameterAssert(date);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    
    [comps setDay:comps.day - comps.weekday + calendar.firstWeekday];
    [comps setHour:[calendar maximumRangeOfUnit:NSCalendarUnitHour].location];
    [comps setMinute:[calendar maximumRangeOfUnit:NSCalendarUnitMinute].location];
    [comps setSecond:[calendar maximumRangeOfUnit:NSCalendarUnitSecond].location + 1];
    
    return [calendar dateFromComponents:comps];
}
- (NSDate *)ME_startOfWeek; {
    return [self.class ME_startOfWeekForDate:self];
}
+ (NSDate *)ME_endOfWeekForDate:(NSDate *)date; {
    NSParameterAssert(date);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    
    [comps setDay:comps.day - comps.weekday + calendar.firstWeekday + NSMaxRange([calendar maximumRangeOfUnit:NSCalendarUnitWeekday]) - 1];
    [comps setHour:NSMaxRange([calendar maximumRangeOfUnit:NSCalendarUnitHour]) - 1];
    [comps setMinute:NSMaxRange([calendar maximumRangeOfUnit:NSCalendarUnitMinute]) - 1];
    [comps setSecond:NSMaxRange([calendar maximumRangeOfUnit:NSCalendarUnitSecond]) - 1];
    
    return [calendar dateFromComponents:comps];
}
- (NSDate *)ME_endOfWeek; {
    return [self.class ME_endOfWeekForDate:self];
}

+ (NSDate *)ME_startOfMonthForDate:(NSDate *)date; {
    NSParameterAssert(date);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    
    [comps setDay:[calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].location];
    [comps setHour:[calendar maximumRangeOfUnit:NSCalendarUnitHour].location];
    [comps setMinute:[calendar maximumRangeOfUnit:NSCalendarUnitMinute].location];
    [comps setSecond:[calendar maximumRangeOfUnit:NSCalendarUnitSecond].location + 1];
    
    return [calendar dateFromComponents:comps];
}
- (NSDate *)ME_startOfMonth; {
    return [self.class ME_startOfMonthForDate:self];
}
+ (NSDate *)ME_endOfMonthForDate:(NSDate *)date; {
    NSParameterAssert(date);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    
    [comps setDay:NSMaxRange([calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date]) - 1];
    [comps setHour:NSMaxRange([calendar maximumRangeOfUnit:NSCalendarUnitHour]) - 1];
    [comps setMinute:NSMaxRange([calendar maximumRangeOfUnit:NSCalendarUnitMinute]) - 1];
    [comps setSecond:NSMaxRange([calendar maximumRangeOfUnit:NSCalendarUnitSecond]) - 1];
    
    return [calendar dateFromComponents:comps];
}
- (NSDate *)ME_endOfMonth; {
    return [self.class ME_endOfMonthForDate:self];
}

+ (NSDate *)ME_startOfYearForDate:(NSDate *)date; {
    NSParameterAssert(date);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear fromDate:date];
    
    [comps setMonth:[calendar maximumRangeOfUnit:NSCalendarUnitMonth].location];
    [comps setDay:[calendar maximumRangeOfUnit:NSCalendarUnitDay].location];
    [comps setHour:[calendar maximumRangeOfUnit:NSCalendarUnitHour].location];
    [comps setMinute:[calendar maximumRangeOfUnit:NSCalendarUnitMinute].location];
    [comps setSecond:[calendar maximumRangeOfUnit:NSCalendarUnitSecond].location + 1];
    
    return [calendar dateFromComponents:comps];
}
- (NSDate *)ME_startOfYear; {
    return [self.class ME_startOfYearForDate:self];
}
+ (NSDate *)ME_endOfYearForDate:(NSDate *)date; {
    NSParameterAssert(date);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:1];
    [comps setSecond:-2];
    
    return [calendar dateByAddingComponents:comps toDate:[date ME_startOfYear] options:0];
}
- (NSDate *)ME_endOfYear; {
    return [self.class ME_endOfYearForDate:self];
}

@end
