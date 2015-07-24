//
//  IKStatusSelector.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-3.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IKApplyStatusDeny,//拒绝
    IKApplyStatusApproval,//批准
    IKApplyStatusReviewing,//审核中
    IKApplyStatusCancel,//取消
    IKApplyStatusNeedData,//需要医学资料
    IKApplyStatusAll = 99//全部
}IKApplyStatus;

@protocol IKStatusSelectorDelegate

- (void)statusSelected:(IKApplyStatus)status;

@end


@interface IKStatusSelector : UIView{
    UIImageView *imgvContent;
}
@property (nonatomic,weak) id<IKStatusSelectorDelegate> delegate;

+ (void)showAtPoint:(CGPoint)pt delegate:(id<IKStatusSelectorDelegate>)dele;

@end
