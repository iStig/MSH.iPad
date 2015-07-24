//
//  IKPlanCell.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IKPlanCell;

@protocol IKPlanCellDelegate

- (void)planChanged:(IKPlanCell *)cell;

@end

@interface IKPlanCell : UITableViewCell<UITextFieldDelegate>{
    NSMutableDictionary *dicInfo;
}
@property (nonatomic,strong) NSMutableDictionary *dicInfo;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<IKPlanCellDelegate> delegate;
@end
