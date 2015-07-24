//
//  IKApplyPhysical.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyView.h"

@interface IKApplyPhysical : IKApplyView<IKInputViewDelegate>{
    UIView *vPlan1,*vPlan2;
    IKInputView *ivType;
}

@end
