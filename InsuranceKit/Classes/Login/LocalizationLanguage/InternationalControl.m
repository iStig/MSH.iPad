//
//  InternationalControl.m
//  YHBusiness
//
//  Created by syzhou on 13-11-7.
//  Copyright (c) 2013年 LYG. All rights reserved.
//

#import "InternationalControl.h"

@implementation InternationalControl

static NSBundle *bundle = nil;

+ ( NSBundle * )bundle{
    return bundle;
}

+(void)initUserLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:kChangeLanguge];
    if(string.length == 0){
        //获取系统当前语言版本(中文zh-Hans,英文en)
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        NSString *current = [languages objectAtIndex:3];
        string = current;
        [def setValue:current forKey:kChangeLanguge];
        [def synchronize];//持久化，不加的话不会保存
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

+(NSString *)userLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:kChangeLanguge];
    return language;
}

+(void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
    //2.持久化
    [def setValue:language forKey:kChangeLanguge];
    
    [def synchronize];
    
}

+ (BOOL)isEnglish{
    NSString *language = [InternationalControl userLanguage];
    if ([language isEqualToString:@"en"])
        return YES;
    else
        return NO;
}

@end
