//
//  IKApplyAuthHospital.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyHospital.h"

@implementation IKApplyHospital

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        keys = [@"applyHospiDays,operationDate,operationName,operationDoctor,currSurFee,assistSurFee,anaesthesiaFee,operRoomFee,materialsFee,otherFee" componentsSeparatedByString:@","];
//        NSArray *titles = [@"申请住院天数,手术日期,手术名称,手术医生,手术医生费,助理医生费,麻醉费,手术室费,材料费,其他" componentsSeparatedByString:@","];
        
        NSArray *titles = @[LocalizeStringFromKey(@"kRequestLengthofStay"),
                            LocalizeStringFromKey(@"kDateofOperation"),
                            LocalizeStringFromKey(@"kNameofOperation"),
                            LocalizeStringFromKey(@"kNameofSurgeon"),
                            LocalizeStringFromKey(@"kSurgeonfee"),
                            LocalizeStringFromKey(@"kAssistantSurgeonfee"),
                            LocalizeStringFromKey(@"kAnaesthesiafee"),
                            LocalizeStringFromKey(@"kOperationRoomfee"),
                            LocalizeStringFromKey(@"kMaterialsfee"),
                            LocalizeStringFromKey(@"kOthers")];

        
        for (int i=0;i<10;i++){
            int row = i/2;
            int col = i%2;
            
            float w = col==0?325:310;
            float x = col==0?20:365;
            
            IKInputView *input = [[IKInputView alloc] initWithFrame:CGRectMake(x, 56*row, w, 56) title:[titles objectAtIndex:i]];
              input.isFutureDate = self.isFutureDate;
            input.key = [keys objectAtIndex:i];
            [self addSubview:input];
        }

        IKInputView *input = [[IKInputView alloc] initWithFrame:CGRectMake(20, 56*5, frame.size.width-2*20, 56) title:LocalizeStringFromKey(@"kRoomtype") values:@[LocalizeStringFromKey(@"kDouble"),LocalizeStringFromKey(@"kSingle"),LocalizeStringFromKey(@"kStandard")]];
        input.key = @"roomType";
        [self addSubview:input];
    }
    return self;
}

+ (id)applyView{
    IKApplyHospital *apply = [[IKApplyHospital alloc] initWithFrame:CGRectMake(0, 0, kContentWidth, 56*6)];
    
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
