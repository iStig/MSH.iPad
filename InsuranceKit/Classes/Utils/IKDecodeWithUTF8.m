//
//  IKDecodeWithUTF8.m
//  InsuranceKit
//
//  Created by 大明五阿哥 on 15/2/4.
//  Copyright (c) 2015年 Stan Wu. All rights reserved.
//

#import "IKDecodeWithUTF8.h"

@implementation IKDecodeWithUTF8
#pragma mark 转化带有中文的str
+(NSString*)getDecodeWithUTF8:(NSString *)_str
{
    
    NSString *newStr = [_str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return newStr;
}
+(NSString *)notRounding:(NSString *)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
@end
