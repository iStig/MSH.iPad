//
//  IKApplyRadiant.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyRadiant.h"

@implementation IKApplyRadiant

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        keys = [@"serviceType,expectedHospiDay,totalCourse,curCourse,radioPlan" componentsSeparatedByString:@","];
        
        IKInputView *input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 0, frame.size.width-2*kContentPadding, 56) title:LocalizeStringFromKey(@"kServiceType") values:@[LocalizeStringFromKey(@"kOutpatient"),LocalizeStringFromKey(@"kInpatient"),LocalizeStringFromKey(@"kDaycase")]];
        input.key = [keys objectAtIndex:0];
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 56, frame.size.width-2*kContentPadding, 56) title:LocalizeStringFromKey(@"kExpectedLengthofStayPerRound")];
        input.key = [keys objectAtIndex:1];
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 56*2, 325, 56) title:LocalizeStringFromKey(@"kTotalRadiotherapyCourse")];
        input.key = [keys objectAtIndex:2];
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(365, 56*2, 310, 56) title:LocalizeStringFromKey(@"kCurrentlyincourse")];
        input.key = [keys objectAtIndex:3];
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 56*3, frame.size.width-2*kContentPadding, 56) title:LocalizeStringFromKey(@"kRadiotherapyPlan")];
        input.key = [keys objectAtIndex:4];
        [self addSubview:input];
    }
    return self;
}

+ (id)applyView{
    IKApplyRadiant *apply = [[IKApplyRadiant alloc] initWithFrame:CGRectMake(0, 0, kContentWidth, 56*4)];
    
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
