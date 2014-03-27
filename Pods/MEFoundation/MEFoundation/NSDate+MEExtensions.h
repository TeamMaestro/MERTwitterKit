//
//  NSDate+MEExtensions.h
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

#import <Foundation/Foundation.h>

extern NSTimeInterval const METimeIntervalOneMinute;
extern NSTimeInterval const METimeIntervalOneHour;
extern NSTimeInterval const METimeIntervalOneDay;
extern NSTimeInterval const METimeIntervalOneWeek;

@interface NSDate (MEExtensions)

/**
 Returns a Boolean value that indicates whether the receiver date occurs before the given NSDate object.

 @param otherDate - The date to compare with the receiver
 @return YES if the receiver is an NSDate object that occurs before otherDate, otherwise NO.
 @see ME_isAfterDate:
 */

- (BOOL)ME_isBeforeDate:(NSDate *)otherDate;

/**
 Returns a Boolean value that indicates whether the receiver date occurs after the given NSDate object.
 
 @param otherDate - The date to compare with the receiver
 @return YES if the receiver is an NSDate object that occurs after otherDate, otherwise NO.
 @see ME_isBeforeDate:
 */
- (BOOL)ME_isAfterDate:(NSDate *)otherDate;

/**
 Returns an NSDateComponents instance created using the current calendar
 
 This is a shortcut method to convert a date or time interval to its calendar or clock components without having to know you need the calendar.
 
 @param a mask of NSCalendarUnit values you want available, e.g. (NSHourCalendarUnit | NSMinuteCalendarUnit)
 @param the date being counted toward
 @return The NSDateComponent instance containing the requested component units
 @see ME_components:fromDate:
 */
- (NSDateComponents *)ME_components:(NSUInteger)unitFlags toDate:(NSDate *)toDate;

/**
 Returns an NSDateComponents instance created using the current calendar
 
 This is a shortcut method to convert a date or time interval to its calendar or
 clock components without having to know you need the calendar.
 
 @param a mask of NSCalendarUnit values you want available, e.g. (NSHourCalendarUnit | NSMinuteCalendarUnit)
 @param the date being counted from
 @return The NSDateComponent instance containing the requested component units
 @see ME_components:toDate:
 */
- (NSDateComponents *)ME_components:(NSUInteger)unitFlags fromDate:(NSDate *)fromDate;

/**
 Returns a new date from _date_ with the time set to 00:00:01 in the local time zone.
 
 @param date The date for which to return the start of the day
 @return The date representing the start of the day
 @exception NSException Thrown if _date_ is nil
 */
+ (NSDate *)ME_startOfDayForDate:(NSDate *)date;
/**
 Calls `ME_startOfDayForDate:`, passing self.
 
 @return The date representing the start of the day for self
 @see ME_startOfDayForDate:
 */
- (NSDate *)ME_startOfDay;
/**
 Returns a new date from _date_ with the time set to 23:59:59 in the local time zone.
 
 @param date The date for which to return the end of the day
 @return The date representing the end of the day
 @exception NSException Thrown if _date_ is nil
 */
+ (NSDate *)ME_endOfDayForDate:(NSDate *)date;
/**
 Calls `ME_endOfDayForDate:`, passing self.
 
 @return The date representing the end of the day for self
 @see ME_endOfDayForDate:
 */
- (NSDate *)ME_endOfDay;

/**
 Returns a new date from _date_ with the weekday set to 1 and the time set to 00:00:01 in the local time zone.
 
 @param date The date for which to return the start of the week
 @return The date representing the start of the week
 @exception NSException Thrown if _date_ is nil
 */
+ (NSDate *)ME_startOfWeekForDate:(NSDate *)date;
/**
 Calls `ME_startOfWeekForDate:`, passing self.
 
 @return The date representing the start of the week for self
 @see ME_startOfWeekForDate:
 */
- (NSDate *)ME_startOfWeek;
/**
 Returns a new date from _date_ with the weekday set to 7 and the time set to 23:59:59 in the local time zone.
 
 @param date The date for which to return the end of the week
 @return The date representing the end of the week
 @exception NSException Thrown if _date_ is nil
 */
+ (NSDate *)ME_endOfWeekForDate:(NSDate *)date;
/**
 Calls `ME_endOfWeekForDate:`, passing self.
 
 @return The date representing the end of the week for self
 @see ME_endOfWeekForDate:
 */
- (NSDate *)ME_endOfWeek;

/**
 Returns a new date from _date_ with the day set to the first day of the month and the time set to 00:00:01 in the local time zone.
 
 @param date The date for which to return the start of the month
 @return The date representing the start of the month
 @exception NSException Thrown if _date_ is nil
 */
+ (NSDate *)ME_startOfMonthForDate:(NSDate *)date;
/**
 Calls `ME_startOfMonthForDate:`, passing self.
 
 @return The date representing the start of the month for self
 @see ME_startOfMonthForDate:
 */
- (NSDate *)ME_startOfMonth;
/**
 Returns a new date from _date_ with the day set to the last day of the month and the time set to 23:59:59 in the local time zone.
 
 @param date The date for which to return the end of the month
 @return The date representing the end of the month
 @exception NSException Thrown if _date_ is nil
 */
+ (NSDate *)ME_endOfMonthForDate:(NSDate *)date;
/**
 Calls `ME_endOfMonthForDate:`, passing self.
 
 @return The date representing the end of the month for self
 @see ME_endOfMonthForDate:
 */
- (NSDate *)ME_endOfMonth;

/**
 Returns a new date from _date_ with the day set to the first day of the year and the time set to 00:00:01 in the local time zone.
 
 @param date The date for which to return the start of the year
 @return The date representing the start of the year
 @exception NSException Thrown if _date_ is nil
 */
+ (NSDate *)ME_startOfYearForDate:(NSDate *)date;
/**
 Calls `ME_startOfYearForDate:`, passing self.
 
 @return The date representing the start of the year for self
 @see ME_startOfYearForDate:
 */
- (NSDate *)ME_startOfYear;
/**
 Returns a new date from _date_ with the day set to the last day of the year and the time set to 23:59:59 in the local time zone.
 
 @param date The date for which to return the end of the year
 @return The date representing the end of the year
 @exception NSException Thrown if _date_ is nil
 */
+ (NSDate *)ME_endOfYearForDate:(NSDate *)date;
/**
 Calls `ME_endOfYearForDate:`, passing self.
 
 @return The date representing the end of the year for self
 @see ME_endOfYearForDate:
 */
- (NSDate *)ME_endOfYear;

@end
