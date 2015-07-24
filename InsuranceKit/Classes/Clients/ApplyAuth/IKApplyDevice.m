//
//  IKApplyDevice.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyDevice.h"

@implementation IKApplyDevice

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        keys = [@"equipmentName,brandAndmodel,expectedDateOfRP" componentsSeparatedByString:@","];
        //NSArray *titles = [@"设备名称,品牌及型号,预计租用或购买日期" componentsSeparatedByString:@","];
        NSArray *titles = @[LocalizeStringFromKey(@"kNameofEquipment"),
                            LocalizeStringFromKey(@"kBrandandproductmodel"),
                            LocalizeStringFromKey(@"kExpectedDateofRentorPurchase")];
        for (int i=0;i<3;i++){
            CGRect inputFrame;
            if (i<2){
                int row = i/2;
                int col = i%2;
                
                float w = col==0?325:310;
                float x = col==0?20:365;
                
                inputFrame = CGRectMake(x, 56*row, w, 56);
            }else{
                inputFrame = CGRectMake(kContentPadding, 56*1, frame.size.width-kContentPadding*2, 56);
            }
            IKInputView *input = [[IKInputView alloc] initWithFrame:inputFrame title:[titles objectAtIndex:i]];
                        
            input.key = [keys objectAtIndex:i];
            [self addSubview:input];
        }
    }
    return self;
}

+ (id)applyView{
    IKApplyDevice *apply = [[IKApplyDevice alloc] initWithFrame:CGRectMake(0, 0, kContentWidth, 56*2)];
    
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
