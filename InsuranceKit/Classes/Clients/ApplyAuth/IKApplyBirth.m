//
//  IKApplyBirth.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyBirth.h"

@implementation IKApplyBirth

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        keys = [@"applyHospiDays,roomType,deliveryType,csectionIndication" componentsSeparatedByString:@","];
//        NSArray *titles = [@"申请住院天数,病房类型,生育方式,剖腹产指征" componentsSeparatedByString:@","];
        NSArray *titles = @[LocalizeStringFromKey(@"kRequestLengthofStay"),
                            LocalizeStringFromKey(@"kRoomtype"),
                            LocalizeStringFromKey(@"kDeliverytype"),
                            LocalizeStringFromKey(@"kIndicationofC-section")];
        
        IKInputView *input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 0, frame.size.width-kContentPadding*2, 56) title:[titles objectAtIndex:0]];
        input.key = [keys objectAtIndex:0];
        input.tag = 1000;
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 56, frame.size.width-kContentPadding*2, 56) title:[titles objectAtIndex:1] values:@[LocalizeStringFromKey(@"kDouble"),LocalizeStringFromKey(@"kSingle"),LocalizeStringFromKey(@"kStandard")]];
        input.key = [keys objectAtIndex:1];
        input.tag = 1001;
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 56*2, frame.size.width-kContentPadding*2-187, 56) title:[titles objectAtIndex:2] values:@[LocalizeStringFromKey(@"kNormalDelivery"),LocalizeStringFromKey(@"kC-section")]];
        input.key = [keys objectAtIndex:2];
        input.delegate = self;
        input.tag = 10002;
        [self addSubview:input];
        
        
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 56*3, frame.size.width-kContentPadding*3, 56) title:[titles objectAtIndex:3]];
        input.key = [keys objectAtIndex:3];
        input.tag = 1003;
        [self addSubview:input];
        input.hidden = YES;
    }
    return self;
}

+ (id)applyView{
    IKApplyBirth *apply = [[IKApplyBirth alloc] initWithFrame:CGRectMake(0, 0, kContentWidth, 56*4)];
    
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

- (void)showInfo:(NSDictionary *)info{
    [super showInfo:info];
    
    int type = [[info objectForKey:@"deliverType"] intValue];
    UIView *iv = [self viewWithTag:1003];
    iv.hidden = type==1;
}

#pragma mark IKInputView Delegate
- (void)selectionChanged:(id)sender{
    IKInputView *iv = (IKInputView *)sender;
    int type = iv.text.intValue;
    
    UIView *v = [self viewWithTag:1003];
    v.hidden = 1==type;
}

@end
