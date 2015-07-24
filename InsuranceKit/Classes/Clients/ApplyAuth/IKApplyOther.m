//
//  IKApplyOther.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyOther.h"

@implementation IKApplyOther

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        float h = frame.size.height;
        keys = [@"treatPlan" componentsSeparatedByString:@","];
//        NSArray *titles = [@"治疗方案" componentsSeparatedByString:@","];
                NSArray *titles = @[LocalizeStringFromKey(@"kServiceCase")];
      
        for (int i=0;i<1;i++){
            IKInputView *input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, h*i, frame.size.width-2*kContentPadding, h) title:[titles objectAtIndex:i]];
            input.key = [keys objectAtIndex:i];
            [self addSubview:input];
        }
    }
    return self;
}

+ (id)applyView{
    IKApplyOther *apply = [[IKApplyOther alloc] initWithFrame:CGRectMake(0, 0, kContentWidth, 56)];
    
    return apply;
}

- (NSDictionary *)authInfo{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    
    BOOL finished = YES;
    
    for (IKInputView *v in self.subviews){
        if ([v isKindOfClass:[IKInputView class]]){
            if (v.text && v.text.length>0)
                [info setObject:v.text forKey:v.key];
            else{
                [info setObject:@"" forKey:v.key];
                if (v.necessary){
                    finished = NO;
                    break;
                }
            }
        }
    }
    
    if (finished)
        return info;
    else
        return nil;
}

@end
