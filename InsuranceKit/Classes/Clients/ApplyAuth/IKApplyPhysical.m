//
//  IKApplyPhysical.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyPhysical.h"

@implementation IKApplyPhysical

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        float h = frame.size.height;

        
        keys = [@"physiotherapyItem,totalCourse,finishCourse,applyPhyCourse,phyType" componentsSeparatedByString:@","];
        
        IKInputView *input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 0, frame.size.width-2*kContentPadding, 56) title:LocalizeStringFromKey(@"kTherapyname")];
        input.key = [keys objectAtIndex:0];
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 56, 325, 56) title:LocalizeStringFromKey(@"kTotalTherapyCourse")];
        input.key = [keys objectAtIndex:1];
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(365, 56, 310, 56) title:LocalizeStringFromKey(@"kFinishedcourse")];
        input.key = [keys objectAtIndex:2];
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 56*2, frame.size.width-2*kContentPadding, 56) title:LocalizeStringFromKey(@"kExpectedcourse")];
        input.key = [keys objectAtIndex:3];
        [self addSubview:input];
        
        ivType = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 56*3, frame.size.width-2*kContentPadding, 56) title:LocalizeStringFromKey(@"kTherapyplan") values:@[LocalizeStringFromKey(@"kplan1"),LocalizeStringFromKey(@"kplan2")]];
        ivType.key = [keys objectAtIndex:4];
        ivType.delegate = self;
        ivType.text = @"1";
        [self addSubview:ivType];
        
        
//        vPlan1 = [self inputPanelForTitles:[@"具体方案：,次/周，共,周" componentsSeparatedByString:@","]];
        
        vPlan1 = [self inputPanelForTitles:@[LocalizeStringFromKey(@"kDetails"),LocalizeStringFromKey(@"ktime/  Per week"),LocalizeStringFromKey(@"ktotal"),LocalizeStringFromKey(@"kweek")]];

        
        CGRect rect = vPlan1.frame;
        rect.origin.x = kContentPadding;
        rect.origin.y = 56*4;
        vPlan1.frame = rect;
        [self addSubview:vPlan1];
        
      //  vPlan2 = [self inputPanelForTitles:[@"具体方案：,次/每,天，共,次" componentsSeparatedByString:@","]];
        
         vPlan2 = [self inputPanelForTitles:@[LocalizeStringFromKey(@"kDetails"),LocalizeStringFromKey(@"ktime/  every"),LocalizeStringFromKey(@"kDay"),LocalizeStringFromKey(@"ktotal"),LocalizeStringFromKey(@"ktimes")]];
        rect = vPlan2.frame;
        rect.origin.x = kContentPadding;
        rect.origin.y = 56*4;
        vPlan2.frame = rect;
        [self addSubview:vPlan2];
        vPlan2.hidden = YES;
    }
    return self;
}

+ (id)applyView{
    IKApplyPhysical *apply = [[IKApplyPhysical alloc] initWithFrame:CGRectMake(0, 0, kContentWidth, 56*5)];
    
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
    
    if (!vPlan1.hidden){
        NSMutableString *str = [NSMutableString string];
        for (int i=0;i<2;i++){
            UITextField *tf = (UITextField *)[vPlan1 viewWithTag:1000+i*2+1];
            if (str.length>0)
                [str appendString:@","];
            if (tf.text.length>0)
                [str appendString:tf.text];
            else{
                finished = NO;
                break;
            }
        }
        
        [info setObject:str forKey:@"phyPlan"];
    }else{
        NSMutableString *str = [NSMutableString string];
        for (int i=0;i<3;i++){
            UITextField *tf = (UITextField *)[vPlan2 viewWithTag:1000+i*2+1];
            if (str.length>0)
                [str appendString:@","];
            if (tf.text.length>0)
                [str appendString:tf.text];
            else{
                finished = NO;
                break;
            }
        }
        
        [info setObject:str forKey:@"phyPlan"];
    }
    
    if (finished){
        return info;
    }
    
    else
        return nil;
}

- (UIView *)inputPanelForTitles:(NSArray *)titles{
    float W = self.frame.size.width-2*kContentPadding;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W, 56)];
    
    NSMutableString *str = [NSMutableString string];
    for (int i=0;i<titles.count;i++)
        [str appendString:[titles objectAtIndex:i]];
    
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:16]];
    
    float w = (W-size.width)/(titles.count-1);
    
    int count = titles.count*2-1;
    
    float x = 0;
    
    for (int i=0;i<count;i++){
        if (i%2==0){
            size = [[titles objectAtIndex:i/2] sizeWithFont:[UIFont systemFontOfSize:16]];
            UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(x, 0, size.width, 56) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.15 alpha:1]];
            lbl.text = [titles objectAtIndex:i/2];
            x += lbl.frame.size.width;
            [v addSubview:lbl];
        }else{
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(x, 0, w, 56)];
            tf.textAlignment = NSTextAlignmentCenter;
            tf.font = [UIFont systemFontOfSize:16];
            tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            tf.tag = 1000+i;
            [v addSubview:tf];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 55, w, 1)];
            line.backgroundColor = [UIColor colorWithWhite:.87 alpha:1];
            [v addSubview:line];
            
            x += w;
        }
    }
    
    return v;
}

- (void)showInfo:(NSDictionary *)info{
    [super showInfo:info];
    
    vPlan1.hidden = ivType.text.intValue!=1;
    vPlan2.hidden = ivType.text.intValue!=2;
    
    UIView *v = vPlan1.hidden?vPlan2:vPlan1;
    NSString *phyPlan = [info objectForKey:@"phyPlan"];
    NSArray *ary = [phyPlan componentsSeparatedByString:@","];
    
    for (int i=0;i<ary.count;i++){
        UITextField *tf = (UITextField *)[v viewWithTag:1000+i*2+1];
        tf.text = [ary objectAtIndex:i];
    }
}

#pragma mark - IKInputView Delegate
- (void)selectionChanged:(id)sender{
    IKInputView *iv = (IKInputView *)sender;
    vPlan1.hidden = iv.text.intValue!=1;
    vPlan2.hidden = iv.text.intValue!=2;
    
    if (vPlan1.hidden){
        for (UITextField *tf in vPlan1.subviews){
            if ([tf isKindOfClass:[UITextField class]])
                tf.text = nil;
        }
    }
    else{
        for (UITextField *tf in vPlan2.subviews){
            if ([tf isKindOfClass:[UITextField class]])
                tf.text = nil;
        }
    }
}

@end
