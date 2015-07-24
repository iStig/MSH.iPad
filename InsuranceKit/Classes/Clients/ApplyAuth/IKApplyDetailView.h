//
//  IKApplyDetailView.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKView.h"
#import "IKApplyView.h"

@class IKApplyAuthViewController;

@interface IKApplyDetailView : IKView<UITextFieldDelegate,UIAlertViewDelegate>{
    UIScrollView *scvBG;
    UIView *vMethodList;
    UIView *vApplyDetail;
    IKApplyView *vApply;
    
    UILabel *lblDate,*lblUnit;
    UIPopoverController *pcDate;
    UIButton *btnSubmit,*btnDelete;
    
    NSArray *aryTitles,*aryImages;
    NSDate *datePlan;
    int category;
    NSDictionary *dicApplyInfo;
    NSMutableArray *aryReportImages;
}
@property (nonatomic,strong) NSMutableDictionary *dicAuthInfo;
@property (nonatomic,weak) IKApplyAuthViewController *vcApplyAuth;
@property (nonatomic, strong)UITextField *tfExpenses;



- (NSDictionary *)getAuthInfo;
- (void)showInfo:(NSDictionary *)info;

@end
