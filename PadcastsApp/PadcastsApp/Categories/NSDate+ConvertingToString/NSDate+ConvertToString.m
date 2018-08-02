//
//  NSDate+ConvertToString.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 8/2/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "NSDate+ConvertToString.h"

@implementation NSDate (ConvertToString)
+(NSString*)stringFromDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"E dd MMM yyyy HH:mm"];
    NSString *string = [dateFormat stringFromDate:date];
    return string;
}

+(NSDate*)createDateFromString:(NSString*)string {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"E dd MMM yyyy HH:mm"];
    NSDate *date = [dateFormat dateFromString:string];
    return date;
}

+(NSString*)convertStringWithDateString:(NSString*)string {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"E, dd MMM yyyy HH:mm:ss Z"];
    NSDate *date = [dateFormat dateFromString:string];
    [dateFormat setDateFormat:@"E dd MMM yyyy HH:mm"];
    return  [dateFormat stringFromDate:date];
}
@end
