//
//  NSString+TrimmingCharacters.m
//  PadcastsApp
//
//  Created by Dzmitry Tarelkin on 8/2/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "NSString+TrimmingCharacters.h"

@implementation NSString (TrimmingCharacters)

+(NSString*)parseString:(NSString*)string {
    NSMutableString * resultString = [NSMutableString stringWithString:string];
    NSRange range;
    //    [string stringByReplacingOccurrencesOfString:@"  " withString:@""];
    //    [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    if ([resultString containsString:@"\n      "]) {
        range = [resultString rangeOfString:@"\n      "];
        [resultString deleteCharactersInRange:range];
    }
    
    if ([resultString containsString:@"  "]) {
        range = [resultString rangeOfString:@"  "];
        [resultString deleteCharactersInRange:range];
    }
    
    if ([resultString containsString:@"\n"]) {
        range = [resultString rangeOfString:@"\n"];
        [resultString deleteCharactersInRange:range];
    }
    
    return [resultString copy];
}

@end
