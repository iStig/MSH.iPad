//
//  InternationalControl.h
//  YHBusiness
//
//  Created by syzhou on 13-11-7.
//  Copyright (c) 2013年 LYG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LocalizeStringFromKey(key) [[InternationalControl bundle] localizedStringForKey:key value:nil table:@"IKLanguage"]

@interface InternationalControl : NSObject

+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言
+ (BOOL)isEnglish;

@end
