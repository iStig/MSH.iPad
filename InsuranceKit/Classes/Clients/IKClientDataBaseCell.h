//
//  IKClientClaimsCell.h
//  InsuranceKit
//
//  Created by iStig on 14-10-9.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKClientDataBaseCell : UITableViewCell{
    UIView *vBG,*vCircle;
    UIButton *btnMail;
    UILabel *lblID,*lblStatus,*lblPlan,*lblDate;
    NSArray *aryList;
    NSDictionary *dicInfo;
}
@property (nonatomic,strong) NSDictionary *dicInfo;

@end
