//
//  IKClientsPaymentView.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"
#import "IKItemView.h"
#import "IKItemPopViewViewController.h"
@interface IKClientsPaymentView : IKView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextFieldDelegate,AFOpenFlowViewDataSource,AFOpenFlowViewDelegate,IKItemPopSelect,UIAlertViewDelegate>{
    UILabel *lblShouldPaid,*lblOutpatientMaxLimit,*lblfranchise,*lblCopay,*lblHospitalCopy,*lblInsuranceCopy;
    UITextField *tfTotal,*tfPaid,*lblDiscount;
    UITableView *tvList;
    UIImageView *imgvPayType;
    UIButton *btnPayType;
    
    NSMutableArray *aryValues;
    NSUInteger dPaymentType,dentalType;// 1—门诊;2-住院3-齿科,4-眼科,5-体检
    NSArray *dentalValues;
    
    
    AFOpenFlowView *_openFlowView;
    
    BOOL isPercent;
    
    UIPopoverController *popItemVC;
    
    
    
}

@property (nonatomic, retain) AFOpenFlowView *_openFlowView;

@end
