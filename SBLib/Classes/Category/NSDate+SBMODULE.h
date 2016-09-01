/*
#####################################################################
# File    : NSDateCagegory.h
# Project : 
# Created : 2013-03-30
# DevTeam : Thomas Develop
# Author  : 
# Notes   :
#####################################################################
### Change Logs   ###################################################
#####################################################################
---------------------------------------------------------------------
# Date  :
# Author:
# Notes :
#
#####################################################################
*/

//为SDK自带的 NSDate 类添加一些实用方法
@interface NSDate (sbmodule)

/** 比较两个时间之间差距的绝对值 */
- (NSTimeInterval)absIntervalSinceDate:(NSDate *)date;

/** 当前时间对象和现在时间差的绝对值 */
- (NSTimeInterval)absIntervalSinceNow;


/** 以下都是从网上copy来的 */
#pragma mark - Relative dates from the current date
/**
明天的日期

@return 明天的日期
*/
+ (NSDate *)dateTomorrow;

/**
昨天的日期

@return 昨天的日期
*/
+ (NSDate *)dateYesterday;

/**
现在以后N天的日期

@param dDays N天

@return 现在以后N天的日期
*/
+ (NSDate *)dateWithDaysFromNow:(NSInteger) dDays;

/**
现在以前N天的日期

@param dDays N天

@return 现在以前的N天日期
*/
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger) dDays;

+ (NSDate *)dateWithHoursFromNow:(NSInteger) dHours;

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger) dHours;

+ (NSDate *)dateWithMinutesFromNow:(NSInteger) dMinutes;

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger) dMinutes;

#pragma mark - Comparing dates

- (BOOL)isEqualToDateIgnoringTime:(NSDate *) otherDate;

- (BOOL)isToday;

- (BOOL)isTomorrow;

- (BOOL)isYesterday;

- (BOOL)isSameWeekAsDate:(NSDate *) aDate;

- (BOOL)isThisWeek;

- (BOOL)isNextWeek;

- (BOOL)isLastWeek;

- (BOOL)isSameMonthAsDate:(NSDate *) aDate;

- (BOOL)isThisMonth;

- (BOOL)isSameYearAsDate:(NSDate *) aDate;

- (BOOL)isThisYear;

- (BOOL)isNextYear;

- (BOOL)isLastYear;

- (BOOL)isEarlierThanDate:(NSDate *) aDate;

- (BOOL)isLaterThanDate:(NSDate *) aDate;

- (BOOL)isEarlierThanOrEqualDate:(NSDate *) aDate;

- (BOOL)isLaterThanOrEqualDate:(NSDate *) aDate;

- (BOOL)isInFuture;

- (BOOL)isInPast;

#pragma mark - Date roles

/**
是否工作日

@return 是否工作日
*/
- (BOOL)isTypicallyWorkday;

/**
是否周末

@return 是否周末
*/
- (BOOL)isTypicallyWeekend;

#pragma mark - Adjusting dates
- (NSDate *)dateByAddingYears:(NSInteger) dYears;

- (NSDate *)dateBySubtractingYears:(NSInteger) dYears;

- (NSDate *)dateByAddingMonths:(NSInteger) dMonths;

- (NSDate *)dateBySubtractingMonths:(NSInteger) dMonths;

- (NSDate *)dateByAddingDays:(NSInteger) dDays;

- (NSDate *)dateBySubtractingDays:(NSInteger) dDays;

- (NSDate *)dateByAddingHours:(NSInteger) dHours;

- (NSDate *)dateBySubtractingHours:(NSInteger) dHours;

- (NSDate *)dateByAddingMinutes:(NSInteger) dMinutes;

- (NSDate *)dateBySubtractingMinutes:(NSInteger) dMinutes;

- (NSDate *)dateAtStartOfDay;

- (NSDate *)dateAtEndOfDay;

- (NSDate *)dateAtStartOfMonth;

- (NSDate *)dateAtEndOfMonth;

- (NSDate *)dateAtStartOfYear;

- (NSDate *)dateAtEndOfYear;

#pragma mark - Retrieving intervals

- (NSInteger)minutesAfterDate:(NSDate *) aDate;

- (NSInteger)minutesBeforeDate:(NSDate *) aDate;

- (NSInteger)hoursAfterDate:(NSDate *) aDate;

- (NSInteger)hoursBeforeDate:(NSDate *) aDate;

- (NSInteger)daysAfterDate:(NSDate *) aDate;

- (NSInteger)daysBeforeDate:(NSDate *) aDate;

- (NSInteger)monthsAfterDate:(NSDate *) aDate;

- (NSInteger)monthsBeforeDate:(NSDate *) aDate;

/**
 * return distance days
 */
- (NSInteger)distanceInDaysToDate:(NSDate *) aDate;

#pragma mark - Decomposing dates
/**
 * return nearest hour
 */
@property(readonly) NSInteger nearestHour;
@property(readonly) NSInteger hour;
@property(readonly) NSInteger minute;
@property(readonly) NSInteger seconds;
@property(readonly) NSInteger day;
@property(readonly) NSInteger month;
@property(readonly) NSInteger week;
//  in the Gregorian calendar, n is 7 and Sunday is represented by 1.
@property(readonly) NSInteger weekday;
@property(readonly) NSInteger firstDayOfWeekday;
@property(readonly) NSInteger lastDayOfWeekday;
// e.g. 2nd Tuesday of the month == 2
@property(readonly) NSInteger nthWeekday;
@property(readonly) NSInteger year;
@property(readonly) NSInteger gregorianYear;

@end
