//
//  IKClientsInfoView.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKClientsInfoView : IKView<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate>{
    UILabel *lblPlanName,*lblStartDate,*lblNumber,*lblEndDate,*lblMPE,*lblMZRatio,*lblZYRatio,*lblThreshold,*lblInstantPay;
    UITextView *lblMemo;
    UIImageView *imgvInstantPay;
    UITableView *tvList;
    UIView *vHeader,*vFooter;
    UIPopoverController *pcDetail;
    
    
    NSInteger dSelectedIndex;
    BOOL bShowInfoList;
    NSArray *aryRights;
    NSMutableDictionary *dicRights;
    UIButton *languageBtn;

}


@end
