//
//  IKDecodeWithUTF8.h
//  InsuranceKit
//
//  Created by 大明五阿哥 on 15/2/4.
//  Copyright (c) 2015年 Stan Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKDecodeWithUTF8 : NSObject
+(NSString*)getDecodeWithUTF8:(NSString *)_str;
+(NSString *)notRounding:(NSString *)price afterPoint:(int)position;//遇5进位。
@end
