//
//  NSDate+WHLCategory.h
//
//  Created by 王浩霖 on 16/3/25.
//
//

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (WHLCategory)


- (NSString *)timeIntervalDescription;//距离当前的时间间隔描述
- (NSString *)minuteDescription;/*精确到分钟的日期描述*/
- (NSString *)formattedTime;
- (NSString *)formattedDateDescription;//格式化日期描述
- (double)timeIntervalSince1970InMilliSecond;
+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond;
+ (NSString *)formattedTimeFromTimeInterval:(long long)time;
// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isInFuture;
- (BOOL) isInPast;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
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
- (NSString *)formatPlayTime:(NSTimeInterval)duration;

//北京时间转化为当地时间的方法
+(NSDate *)getLocationTimefromBeiJingTime:(NSDate*)beijingTime;

//当地时间转化为北京时间
+(NSDate *)getBeiJingTimeFromLocationTime:(NSDate*)CLocationTimsa;

//世界标准时间转换为系统时区对应时间（ps: 时间后面有＋0000 表示的是当前时间是个世界时间。）
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

//将本地日期字符串转为UTC日期字符串
+ (NSString *)getUTCFormateLocalDate:(NSString *)localDate;

+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate;

//时间转换为指定的字符串
+(NSString *)dateChangString:(NSDate*)newTimeDate WithFormater:(NSString *)formaterStr addTimeZone:(BOOL)addTimeZone;
//字符串转化为时间数据
+(NSDate *)StringChangDate:(NSString*)timeString WithFormater:(NSString *)formaterStr addTimeZone:(BOOL)addTimeZone;

//转换旧的时间格式为一种新的时间格式
+ (NSDate *)switchOldDate:(NSDate *)oldDate withNewFormater:(NSString *)NewFormaterStr oldFormater:(NSString *)oldFormater;

/**
 依照某种格式比较2个时间大小
 @return   NSOrderedDescending oneDay>anotherDay \\ NSOrderedAscending oneDay<anotherDay
 */
+(NSComparisonResult)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay andTheFormater:(NSString *)formaterStr;


+(NSString *)getDateForMateStrWithDate:(NSDate *)date;
/**
  根据日期返回对应星座
 */
+ (NSString *)constellationStrWithFormater:(NSString *)formaterStr formDate:(NSDate *)date;


/**
 根据日期返回年龄
 */
+ (NSInteger )getYearWithDate:(NSDate *)date;


@end

