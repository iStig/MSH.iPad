//
//  IKClientsAuthCell.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-1-20.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKClientsAuthCell : UITableViewCell{
    UIView *vBG,*vCircle;
    UIButton *btnMail;
    UILabel *lblID,*lblStatus,*lblPlan,*lblDate;
    
    NSDictionary *dicInfo;
}
@property (nonatomic,strong) NSDictionary *dicInfo;

@end
