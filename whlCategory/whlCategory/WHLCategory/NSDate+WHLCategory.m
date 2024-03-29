//
//  NSDate+WHLCategory.m
//
//  Created by Haolin Wang on 16/3/25.
//
//

#import "NSDate+WHLCategory.h"

#define DATE_COMPONENTS  (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (WHLCategory)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

/*距离当前的时间间隔描述*/
- (NSString *)whl_timeIntervalDescription
{
    NSTimeInterval timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < 60) {
        return NSLocalizedString(@"NSDateCategory.text1", @"");
    } else if (timeInterval < 3600) {
        return [NSString stringWithFormat:NSLocalizedString(@"NSDateCategory.text2", @""), timeInterval / 60];
    } else if (timeInterval < 86400) {
        return [NSString stringWithFormat:NSLocalizedString(@"NSDateCategory.text3", @""), timeInterval / 3600];
    } else if (timeInterval < 2592000) {//30天内
        return [NSString stringWithFormat:NSLocalizedString(@"NSDateCategory.text4", @""), timeInterval / 86400];
    } else if (timeInterval < 31536000) {//30天至1年内
        NSDateFormatter *dateFormatter = [self whl_dateFormatterWithFormat:NSLocalizedString(@"NSDateCategory.text5", @"")];
        return [dateFormatter stringFromDate:self];
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"NSDateCategory.text6", @""), timeInterval / 31536000];
    }
}

/*精确到分钟的日期描述*/
- (NSString *)whl_minuteDescription
{
    NSDateFormatter *dateFormatter = [self whl_dateFormatterWithFormat:@"yyyy-MM-dd"];

    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    if ([theDay isEqualToString:currentDay]) {//当天
        [dateFormatter setDateFormat:@"ah:mm"];
        return [dateFormatter stringFromDate:self];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        [dateFormatter setDateFormat:@"ah:mm"];
        return [NSString stringWithFormat:NSLocalizedString(@"NSDateCategory.text7", @'"'), [dateFormatter stringFromDate:self]];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < 86400 * 7) {//间隔一周内
        [dateFormatter setDateFormat:@"EEEE ah:mm"];
        return [dateFormatter stringFromDate:self];
    } else {//以前
        [dateFormatter setDateFormat:@"yyyy-MM-dd ah:mm"];
        return [dateFormatter stringFromDate:self];
    }
}

/*标准时间日期描述*/
- (NSString *)whl_formattedTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateNow = [formatter stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(8, 2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(5, 2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0, 4)] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:components]; //今天 0点时间

    NSInteger hour = [self whl_hoursAfterDate:date];
    NSDateFormatter *dateFormatter = nil;
    NSString *ret = @"";

    //hasAMPM==TURE为12小时制，否则为24小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;

    if (!hasAMPM) { //24小时制
        if (hour <= 24 && hour >= 0) {
            dateFormatter = [self whl_dateFormatterWithFormat:@"HH:mm"];
        } else if (hour < 0 && hour >= -24) {
            dateFormatter = [self whl_dateFormatterWithFormat:NSLocalizedString(@"NSDateCategory.text8", @"")];
        } else {
            dateFormatter = [self whl_dateFormatterWithFormat:@"yyyy-MM-dd"];
        }
    } else {
        if (hour >= 0 && hour <= 6) {
            dateFormatter = [self whl_dateFormatterWithFormat:NSLocalizedString(@"NSDateCategory.text9", @"")];
        } else if (hour > 6 && hour <= 11) {
            dateFormatter = [self whl_dateFormatterWithFormat:NSLocalizedString(@"NSDateCategory.text10", @"")];
        } else if (hour > 11 && hour <= 17) {
            dateFormatter = [self whl_dateFormatterWithFormat:NSLocalizedString(@"NSDateCategory.text11", @"")];
        } else if (hour > 17 && hour <= 24) {
            dateFormatter = [self whl_dateFormatterWithFormat:NSLocalizedString(@"NSDateCategory.text12", @"")];
        } else if (hour < 0 && hour >= -24) {
            dateFormatter = [self whl_dateFormatterWithFormat:NSLocalizedString(@"NSDateCategory.text13", @"")];
        } else {
            dateFormatter = [self whl_dateFormatterWithFormat:@"yyyy-MM-dd"];
        }
    }
    ret = [dateFormatter stringFromDate:self];
    return ret;
}

/*格式化日期描述*/
- (NSString *)whl_formattedDateDescription
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日

    NSInteger timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < 60) {
        return NSLocalizedString(@"NSDateCategory.text1", @"");
    } else if (timeInterval < 3600) {//1小时内
        return [NSString stringWithFormat:NSLocalizedString(@"NSDateCategory.text2", @""), timeInterval / 60];
    } else if (timeInterval < 21600) {//6小时内
        return [NSString stringWithFormat:NSLocalizedString(@"NSDateCategory.text3", @""), timeInterval / 3600];
    } else if ([theDay isEqualToString:currentDay]) {//当天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:NSLocalizedString(@"NSDateCategory.text14", @""), [dateFormatter stringFromDate:self]];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:NSLocalizedString(@"NSDateCategory.text7", @""), [dateFormatter stringFromDate:self]];
    } else {//以前
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:self];
    }
}

- (double)whl_timeIntervalSince1970InMilliSecond {
    double ret;
    ret = [self timeIntervalSince1970] * 1000;

    return ret;
}

+ (NSDate *)whl_dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond {
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if (timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];

    return ret;
}

+ (NSString *)whl_formattedTimeFromTimeInterval:(long long)time {
    return [[NSDate whl_dateWithTimeIntervalInMilliSecondSince1970:time] whl_formattedTime];
}

#pragma mark Relative Dates

+ (NSDate *)whl_dateWithDaysFromNow:(NSInteger)days
{
    return [[NSDate date] whl_dateByAddingDays:days];
}

+ (NSDate *)whl_dateWithDaysBeforeNow:(NSInteger)days
{
    return [[NSDate date] whl_dateBySubtractingDays:days];
}

+ (NSDate *)whl_dateTomorrow
{
    return [NSDate whl_dateWithDaysFromNow:1];
}

+ (NSDate *)whl_dateYesterday
{
    return [NSDate whl_dateWithDaysBeforeNow:1];
}

+ (NSDate *)whl_dateWithHoursFromNow:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)whl_dateWithHoursBeforeNow:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)whl_dateWithMinutesFromNow:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)whl_dateWithMinutesBeforeNow:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark Comparing Dates

- (BOOL)whl_isEqualToDateIgnoringTime:(NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)whl_isToday
{
    return [self whl_isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)whl_isTomorrow
{
    return [self whl_isEqualToDateIgnoringTime:[NSDate whl_dateTomorrow]];
}

- (BOOL)whl_isYesterday
{
    return [self whl_isEqualToDateIgnoringTime:[NSDate whl_dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL)whl_isSameWeekAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];

    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfYear != components2.weekOfYear) return NO;

    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL)whl_isThisWeek
{
    return [self whl_isSameWeekAsDate:[NSDate date]];
}

- (BOOL)whl_isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self whl_isSameWeekAsDate:newDate];
}

- (BOOL)whl_isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self whl_isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL)whl_isSameMonthAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL)whl_isThisMonth
{
    return [self whl_isSameMonthAsDate:[NSDate date]];
}

- (BOOL)whl_isSameYearAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL)whl_isThisYear
{
    // Thanks, baspellis
    return [self whl_isSameYearAsDate:[NSDate date]];
}

- (BOOL)whl_isNextYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];

    return (components1.year == (components2.year + 1));
}

- (BOOL)whl_isLastYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
    return (components1.year == (components2.year - 1));
}

///是否是周末
- (BOOL)whl_isWeekend
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
                        fromDate:self];
    NSInteger weekday = [comps weekday];
    if (weekday == 1 || weekday == 7) {
        return YES;
    }
    return NO;
}

- (BOOL)whl_isEarlierThanDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)whl_isLaterThanDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL)whl_isInFuture
{
    return ([self whl_isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL)whl_isInPast
{
    return ([self whl_isEarlierThanDate:[NSDate date]]);
}

#pragma mark Roles
- (BOOL)whl_isTypicallyWeekend
{
    NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7)) return YES;
    return NO;
}

- (BOOL)whl_isTypicallyWorkday
{
    return ![self whl_isTypicallyWeekend];
}

#pragma mark Adjusting Dates

- (NSDate *)whl_dateByAddingDays:(NSInteger)dDays
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)whl_dateBySubtractingDays:(NSInteger)dDays
{
    return [self whl_dateByAddingDays:(dDays * -1)];
}

- (NSDate *)whl_dateByAddingHours:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)whl_dateBySubtractingHours:(NSInteger)dHours
{
    return [self whl_dateByAddingHours:(dHours * -1)];
}

- (NSDate *)whl_dateByAddingMinutes:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)whl_dateBySubtractingMinutes:(NSInteger)dMinutes
{
    return [self whl_dateByAddingMinutes:(dMinutes * -1)];
}

- (NSDate *)whl_dateAtStartOfDay
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *)whl_componentsWithOffsetFromDate:(NSDate *)aDate
{
    NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger)whl_minutesAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_MINUTE);
}

- (NSInteger)whl_minutesBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_MINUTE);
}

- (NSInteger)whl_hoursAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_HOUR);
}

- (NSInteger)whl_hoursBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_HOUR);
}

- (NSInteger)whl_daysAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_DAY);
}

- (NSInteger)whl_daysBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)whl_distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark Decomposing Dates

- (NSInteger)whl_nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
    return components.hour;
}

- (NSInteger)whl_hour
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}

- (NSInteger)whl_minute
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}

- (NSInteger)whl_seconds
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.second;
}

- (NSInteger)whl_day
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}

- (NSInteger)whl_month
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}

- (NSInteger)whl_weekContainInMonth
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekOfMonth;
}

- (NSInteger)whl_weekContainInYear
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekOfYear;
}

- (NSInteger)whl_weekday
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekday;
}

- (NSInteger)whl_nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger)whl_year
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.year;
}

#pragma mark -
#pragma mark 私有方法

- (NSDateFormatter *)whl_dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

#pragma clang diagnostic pop

@end

#pragma mark -
#pragma mark 日期和字符串转换类

@implementation NSDate (WHLDateConversion)

//将时间转换成00:00:00格式
- (NSString *)whl_formatPlayTime:(NSTimeInterval)duration
{
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600) / 60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}

+ (NSDate *)whl_getLocationTimefromBeiJingTime:(NSDate *)beijingTime
{
    //设置源日期时区
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:beijingTime];
    //源日期与目标时区的时间的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:beijingTime];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate *destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:beijingTime];
    return destinationDateNow;
}

//当地时间转化为北京时间
+ (NSDate *)whl_getBeiJingTimeFromLocationTime:(NSDate *)CLocationTimsa
{
    //    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    NSTimeZone *destinationTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSInteger bjInterval = [destinationTimeZone secondsFromGMTForDate:CLocationTimsa];
    NSDate *bjDate = [CLocationTimsa dateByAddingTimeInterval:bjInterval];  //直接转为北京时间
    return bjDate;
}

+ (NSDate *)whl_getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate *destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

//将本地日期字符串转为UTC日期字符串
//本地日期格式:2013-08-03 12:53:51
//可自行指定输入输出格式

+ (NSString *)whl_getUTCFormateLocalDate:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
+ (NSString *)whl_getLocalDateFormateUTCDate:(NSString *)utcDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];

    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

//时间转换为字符串
+ (NSString *)whl_dateChangString:(NSDate *)newTimeDate WithFormater:(NSString *)formaterStr addTimeZone:(BOOL)addTimeZone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (addTimeZone) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];//不自动+8小时
    }
    [formatter setDateFormat:formaterStr];
    NSString *nowDateString = [formatter stringFromDate:newTimeDate];
    return nowDateString;
}

//字符串转化为时间数据
+ (NSDate *)whl_StringChangDate:(NSString *)timeString WithFormater:(NSString *)formaterStr addTimeZone:(BOOL)addTimeZone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (addTimeZone) {
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];//世界时间样式（不会根据系统时间自动对数据进行时区自动增加时区差值。）
    }
    [formatter setDateFormat:formaterStr];
    NSDate *nowDate = [formatter dateFromString:timeString];
    return nowDate;
}

+ (NSDate *)whl_switchOldDate:(NSDate *)oldDate withNewFormater:(NSString *)NewFormaterStr oldFormater:(NSString *)oldFormater {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:oldFormater];
    NSString *oldDateStr = [dateFormater stringFromDate:oldDate];
    [dateFormater setDateFormat:NewFormaterStr];
    return [dateFormater dateFromString:oldDateStr];
}

//比较两个时间的大小
+ (NSComparisonResult)whl_compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay andTheFormater:(NSString *)formaterStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formaterStr];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);

//    if (result == NSOrderedDescending) {//dateA比dateB大
//        //NSLog(@"Date1  is in the future");
//        return 1;
//    }
//    else if (result == NSOrderedAscending){//dateA比dateB小
//
//        //NSLog(@"Date1 is in the past");
//        return -1;
//    }
//    //NSLog(@"Both dates are the same");
//    return 0;
    return result;
}

+ (NSString *)whl_constellationStrWithFormater:(NSString *)formaterStr formDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formaterStr];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)whl_createDateFromatter:(NSString *)dateFormatterStr With:(NSTimeInterval)utcTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = dateFormatterStr.length == 0 ? @"yyyy-MM-dd HH:mm" : dateFormatterStr;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:utcTime / 1000.0];
    if (!date) {
        return @"";
    }

    return [df stringFromDate:date];
}

/**
 根据日期返回对应星座
 */
+ (NSString *)whl_constellationStrWithDate:(NSDate *)date {
    NSInteger m = [[date whl_stringWithFormat:@"MM"] integerValue];
    NSInteger d = [[date whl_stringWithFormat:@"dd"] integerValue];

    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;

    if (m < 1 || m > 12 || d < 1 || d > 31) {
        return @"错误日期格式!";
    }

    if (m == 2 && d > 29) {
        return @"错误日期格式!!";
    } else if (m == 4 || m == 6 || m == 9 || m == 11) {
        if (d > 30) {
            return @"错误日期格式!!!";
        }
    }

    result = [NSString stringWithFormat:@"%@", [astroString substringWithRange:NSMakeRange(m * 2 - (d < [[astroFormat substringWithRange:NSMakeRange((m - 1), 1)] intValue] - (-19)) * 2, 2)]];

    return [NSString stringWithFormat:@"%@座", result];
}

- (NSString *)whl_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

/**
 根据日期返回年龄
 */
+ (NSInteger)whl_getYearWithDate:(NSDate *)date {
    NSDate *currentDate = [NSDate date];

    double intervalTime = [currentDate timeIntervalSinceReferenceDate ] - [date timeIntervalSinceReferenceDate ];

    long lTime = (long)intervalTime;
    NSInteger iDays = lTime / 60 / 60 / 24;
    NSInteger iMonth = lTime / 60 / 60 / 24 / 12;
    NSInteger iYears = lTime / 60 / 60 / 24 / 384;
//    NSInteger iSeconds = lTime % 60;
//    NSInteger iMinutes = (lTime / 60) % 60;
//    NSInteger iHours = (lTime / 3600);
//    NSInteger iDays = lTime/60/60/24;
//    NSInteger iMonth = lTime/60/60/24/12;
//    NSInteger iYears = lTime/60/60/24/384;

    return iYears;
}

+ (NSString *)whl_getLocalDateWith:(NSTimeInterval)utcTime
{
    NSDateFormatter *ddff = [[NSDateFormatter alloc] init];
    ddff.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:utcTime / 1000.0];
    if (!date) {
        return @"";
    }
    if ([date whl_isToday]) {
        NSDateFormatter *ddff = [[NSDateFormatter alloc] init];
        ddff.dateFormat = @"今日 HH:mm";
        return [ddff stringFromDate:date];
    } else if ([date whl_isThisYear]) {
        NSDateFormatter *ddff = [[NSDateFormatter alloc] init];
        ddff.dateFormat = @"MM-dd HH:mm";
        return [ddff stringFromDate:date];
    } else {
        NSDateFormatter *ddff = [[NSDateFormatter alloc] init];
        ddff.dateFormat = @"yyyy-MM-dd HH:mm";
        return [ddff stringFromDate:date];
    }
}

+ (NSString *)whl_getDateShorteneFormWith:(NSTimeInterval)utcTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [df stringFromDate:[NSDate date]];

    NSDate *startdate = [df dateFromString:dateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:utcTime];
    if (!date) {
        return @"";
    }

    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date toDate:startdate options:0];
    int year = (int)[components year];
    int month = (int)[components month];
    int day = (int)[components day];
    int hour = (int)[components hour];
    int minute = (int)[components minute];
    int second = (int)[components second];

    int iOffset = (hour * 60 + minute) * 60 + second;

    if (year == 0 && month == 0 && day < 2) {
        NSString *title = nil;
        if (day <= 0) {
            if (iOffset <= 0) {
                int sTime = [date timeIntervalSince1970];
                int eTime = [[NSDate date] timeIntervalSince1970];
                int resultTime = eTime - sTime;
                if (resultTime > 0) {
                    if (resultTime < 3600) {
                        if (resultTime < 60) {
                            return [NSString stringWithFormat:@"%d秒前", resultTime];
                        } else {
                            return [NSString stringWithFormat:@"%d分钟前", resultTime / 60];
                        }
                    } else if (resultTime <= 3 * 3600 && resultTime >= 3600) {
                        return [NSString stringWithFormat:@"%d小时前", (int)(resultTime / 3600)];
                    } else {
                        title = @"今天";
                    }
                } else {
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    df.dateFormat = @"MM-dd";
                    return [df stringFromDate:date];
                }
            } else {
                title = @"昨天";
            }
        } else if (day == 1) {
            title = @"前天";
        }
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = [NSString stringWithFormat:@"%@ HH:mm", title];
        NSString *finalStr = [dateformatter stringFromDate:date];
        if ([title isEqualToString:@"今天"]) {
            return [finalStr stringByReplacingOccurrencesOfString:title withString:@"今天"];
        } else if ([title isEqualToString:@"昨天"]) {
            return [finalStr stringByReplacingOccurrencesOfString:title withString:@"昨天"];
        } else if ([title isEqualToString:@"前天"]) {
            return [finalStr stringByReplacingOccurrencesOfString:title withString:@"前天"];
        }
        return finalStr;
    }
    NSDateFormatter *ddff = [[NSDateFormatter alloc] init];
    ddff.dateFormat = @"MM-dd";
    return [ddff stringFromDate:date];
}

//使用秒数计算时间间隔
+ (NSString *)whl_getTimeStrFromInterval:(int)time
{
    NSString *str;
    int tian = time / (24 * 60 * 60);
    int shengyu = time % (24 * 60 * 60);
    int xiaoshi = shengyu / 3600;
    int yu = shengyu % 3600;
    int fen = yu / 60;
    if (!tian) {
        if (xiaoshi) {
            str = [NSString stringWithFormat:@"%d小时%d分", xiaoshi, fen];
        } else {
            str = [NSString stringWithFormat:@"%d分", fen];
        }
    } else str = [NSString stringWithFormat:@"%d天 %d小时%d分", tian, xiaoshi, fen];
    return str;
}

+ (NSInteger)whl_getWeekend:(NSDate *)date1 andWeekend:(NSDate *)date2
{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSDate *date = date1;
    while (date <= date2) {
        [dates addObject:date];
        [date whl_dateByAddingDays:1];
    }

    int i = 0;
    for (NSDate *d in dates) {
        if ([d whl_isWeekend]) {
            i++;
        }
    }
    return i;
}

@end
