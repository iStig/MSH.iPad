//
//  IKClientsListCell.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-10.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKVisitCDSO.h"

@interface IKClientsListCell : UITableViewCell{
    UILabel *lblName,*lblGender,*lblStatus,*lblApproval,*lblTime;
    UIImageView *imgvPaid,*imgvRecords,*imgvSigned;
    
    
    IKVisitCDSO *visit;
}
@property (nonatomic,strong) IKVisitCDSO *visit;

- (void)makeSelected:(BOOL)selected;

@end
