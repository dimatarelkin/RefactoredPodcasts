//
//  NSDate+ConvertToString.h
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 8/2/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ConvertToString)
+(NSString*)stringFromDate:(NSDate*)date;
+(NSDate*)createDateFromString:(NSString*)string;
+(NSString*)convertStringWithDateString:(NSString*)string;
@end
