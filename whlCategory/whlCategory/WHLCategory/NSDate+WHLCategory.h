//
//  NSDate+WHLCategory.h
//
//  Created by Haolin Wang on 16/3/25.
//
//

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (WHLCategory)


- (NSString *)whl_timeIntervalDescription;//距离当前的时间间隔描述
- (NSString *)whl_minuteDescription;/*精确到分钟的日期描述*/
- (NSString *)whl_formattedTime;
- (NSString *)whl_formattedDateDescription;//格式化日期描述
- (double)whl_timeIntervalSince1970InMilliSecond;
+ (NSDate *)whl_dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond;
+ (NSString *)whl_formattedTimeFromTimeInterval:(long long)time;
// Relative dates from the current date
+ (NSDate *)whl_dateTomorrow;
+ (NSDate *)whl_dateYesterday;
+ (NSDate *)whl_dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *)whl_dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *)whl_dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *)whl_dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *)whl_dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *)whl_dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Comparing dates
- (BOOL)whl_isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL)whl_isToday;
- (BOOL)whl_isTomorrow;
- (BOOL)whl_isYesterday;
- (BOOL)whl_isSameWeekAsDate: (NSDate *) aDate;
- (BOOL)whl_isThisWeek;
- (BOOL)whl_isNextWeek;
- (BOOL)whl_isLastWeek;
- (BOOL)whl_isSameMonthAsDate: (NSDate *) aDate;
- (BOOL)whl_isThisMonth;
- (BOOL)whl_isSameYearAsDate: (NSDate *) aDate;
- (BOOL)whl_isThisYear;
- (BOOL)whl_isNextYear;
- (BOOL)whl_isLastYear;
- (BOOL)whl_isEarlierThanDate: (NSDate *) aDate;
- (BOOL)whl_isLaterThanDate: (NSDate *) aDate;
- (BOOL)whl_isInFuture;
- (BOOL)whl_isInPast;

// Date roles
- (BOOL)whl_isTypicallyWorkday;
- (BOOL)whl_isTypicallyWeekend;

// Adjusting dates
- (NSDate *)whl_dateByAddingDays: (NSInteger) dDays;
- (NSDate *)whl_dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *)whl_dateByAddingHours: (NSInteger) dHours;
- (NSDate *)whl_dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *)whl_dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *)whl_dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *)whl_dateAtStartOfDay;

// Retrieving intervals
- (NSInteger)whl_minutesAfterDate: (NSDate *) aDate;
- (NSInteger)whl_minutesBeforeDate: (NSDate *) aDate;
- (NSInteger)whl_hoursAfterDate: (NSDate *) aDate;
- (NSInteger)whl_hoursBeforeDate: (NSDate *) aDate;
- (NSInteger)whl_daysAfterDate: (NSDate *) aDate;
- (NSInteger)whl_daysBeforeDate: (NSDate *) aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger weekContainInMonth;
@property (readonly) NSInteger weekContainInYear;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;


@end


//日期转换类
@interface NSDate (WHLDateConversion)



//将时间转换成00:00:00格式
- (NSString *)whl_formatPlayTime:(NSTimeInterval)duration;

//北京时间转化为当地时间的方法
+(NSDate *)whl_getLocationTimefromBeiJingTime:(NSDate*)beijingTime;

//当地时间转化为北京时间
+(NSDate *)whl_getBeiJingTimeFromLocationTime:(NSDate*)CLocationTimsa;

//世界标准时间转换为系统时区对应时间（ps: 时间后面有＋0000 表示的是当前时间是个世界时间。）
+ (NSDate *)whl_getNowDateFromatAnDate:(NSDate *)anyDate;

//将本地日期字符串转为UTC日期字符串
+ (NSString *)whl_getUTCFormateLocalDate:(NSString *)localDate;

+ (NSString *)whl_getLocalDateFormateUTCDate:(NSString *)utcDate;

//时间转换为指定的字符串
+(NSString *)whl_dateChangString:(NSDate*)newTimeDate WithFormater:(NSString *)formaterStr addTimeZone:(BOOL)addTimeZone;
//字符串转化为时间数据
+(NSDate *)whl_StringChangDate:(NSString*)timeString WithFormater:(NSString *)formaterStr addTimeZone:(BOOL)addTimeZone;

//转换旧的时间格式为一种新的时间格式
+ (NSDate *)whl_switchOldDate:(NSDate *)oldDate withNewFormater:(NSString *)NewFormaterStr oldFormater:(NSString *)oldFormater;

/**
 依照某种格式比较2个时间大小
 @return   NSOrderedDescending oneDay>anotherDay \\ NSOrderedAscending oneDay<anotherDay
 */
+(NSComparisonResult)whl_compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay andTheFormater:(NSString *)formaterStr;


+(NSString *)whl_getDateForMateStrWithDate:(NSDate *)date;
/**
  根据日期返回对应星座
 */
+ (NSString *)whl_constellationStrWithFormater:(NSString *)formaterStr formDate:(NSDate *)date;


/**
 根据日期返回年龄
 */
+ (NSInteger )whl_getYearWithDate:(NSDate *)date;


@end

