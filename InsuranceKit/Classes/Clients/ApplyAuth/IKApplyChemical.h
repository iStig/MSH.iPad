//
//  IKApplyChemical.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKView.h"
#import "IKApplyView.h"
#import "IKPlanCell.h"

@interface IKApplyChemical:IKApplyView<UITableViewDataSource,UITableViewDelegate,IKPlanCellDelegate>{
    UITableView *tvPlan;
    UIView *vHeader;
    UIButton *btnReduce;
    
    NSMutableArray *aryPlan;
}

@end
