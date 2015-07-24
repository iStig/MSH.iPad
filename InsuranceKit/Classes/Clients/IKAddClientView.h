//
//  IKAddClientView.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-13.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKPopCenterView.h"
#import "IKVisitCDSO.h"

@interface IKAddClientView : UIView<IKPopCenterViewDelegate,UIActionSheetDelegate>{
    UIView *vContent;
    NSUInteger dCurrentPage;
    
    NSDictionary *dicClientInfo;
    NSArray *aryPeopleList;
    NSMutableArray *aryPhoto;
    BOOL bCanGoBack;
    UILabel *yyyymmddLab;
    UILabel *hhmmLab;
    UILabel *registerTimerLab;
    UIButton *yyyymmddBtn;
    UIButton *hhmmBtn;
    UIPopoverController *pcTime;
    
    NSDate *datePlan;
    NSDate *minPlan;
}
@property (nonatomic,weak) UIViewController *vcParent;
@property (nonatomic,strong) IKVisitCDSO *visit;
@property (nonatomic) BOOL addedVisit;

- (void)showAddSignature;
- (id)initWithFrame:(CGRect)frame clientInfo:(IKVisitCDSO *)v showType:(int)showType;// 0-默认,1-相册,2-签名
+ (void)show;
+ (void)showAddSignature:(IKVisitCDSO *)v;
+ (void)showAddSignatureOfVisit:(IKVisitCDSO *)v;

@end
