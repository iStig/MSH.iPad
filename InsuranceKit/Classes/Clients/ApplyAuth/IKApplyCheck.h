//
//  IKApplyAuthCheck.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyView.h"
#import "IKApplyView.h"
#import "IKCheckItemSelector.h"

@interface IKApplyCheck : IKApplyView<IKCheckItemSelector>{
    NSString *strItemIDs;
    IKInputView *ivCheckItem;
}

@end
