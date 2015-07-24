//
//  IKApplyAuthCheck.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyCheck.h"

@implementation IKApplyCheck

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        float h = frame.size.height/3;
        keys = [@"examItem,operationName,others" componentsSeparatedByString:@","];
//        NSArray *titles = [@"检查项目,手术名称,其他" componentsSeparatedByString:@","];
            NSArray *titles = @[LocalizeStringFromKey(@"kExamItem"),
                                LocalizeStringFromKey(@"kNameofOperation"),
                                LocalizeStringFromKey(@"kOthers")];
        for (int i=0;i<3;i++){
            IKInputView *input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, h*i, frame.size.width-2*kContentPadding, h) title:[titles objectAtIndex:i]];
            input.key = [keys objectAtIndex:i];
            [self addSubview:input];
            input.tag = i;
            
            if (0==i){
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = input.frame;
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
                
                input.inputField.placeholder = LocalizeStringFromKey(@"kitemsmaximum");
                input.inputField.textAlignment = NSTextAlignmentRight;
                input.inputField.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 0);
 
                ivCheckItem = input;
            }
        }
    }
    return self;
}

- (void)btnClicked:(UIButton *)btn{
    [IKCheckItemSelector showAtPoint:CGPointMake(512, 80) delegate:self];
}

+ (id)applyView{
    IKApplyCheck *apply = [[IKApplyCheck alloc] initWithFrame:CGRectMake(0, 0, kContentWidth, 56*3)];
    
    return apply;
}

- (void)showInfo:(NSDictionary *)info{
    [super showInfo:info];
    
    strItemIDs = [info objectForKey:ivCheckItem.key];
    if (strItemIDs.length==0)
        strItemIDs = nil;
    
    [self didSelectedItems:strItemIDs];
}

- (NSDictionary *)authInfo{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    
    BOOL finished = YES;
    
    for (IKInputView *v in self.subviews){
        if ([v isKindOfClass:[IKInputView class]]){
            if (v.tag==ivCheckItem.tag){
                if (strItemIDs && strItemIDs.length>0)
                    [info setObject:strItemIDs forKey:v.key];
                else{
                    if (v.necessary){
                        finished = NO;
                        break;
                    }
                }
            }else{
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
    }
    
    if (finished)
        return info;
    else
        return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - IKCheckItemSelector Delegate
- (void)didSelectedItems:(NSString *)items{
    NSArray *titles = [[NSString stringWithFormat:@"%@,24hrs Holter,Ultrasound,CT,CTA,MRI,PET-CT,Sleep Study,MRA,Gastroscopy,Colonoscopy,Capsule Endoscopy",LocalizeStringFromKey(@"koptions")] componentsSeparatedByString:@","];

    
    strItemIDs = items;
    if (!strItemIDs)
        ivCheckItem.text = nil;
    else{
        NSArray *ids = [strItemIDs componentsSeparatedByString:@","];
        NSMutableString *mutstr = [NSMutableString string];
        
        for (int i=0;i<ids.count;i++){
            NSString *content = [titles objectAtIndex:[[ids objectAtIndex:i] intValue]];
            if ([mutstr length]>0)
                [mutstr appendFormat:@",%@",content];
            else
                [mutstr appendString:content];
        }
        
        ivCheckItem.text = mutstr;
    }
}

@end
