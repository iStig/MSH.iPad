//
//  IKHospitalListViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"

@protocol IKHospitalDelegate

- (void)hospitalSelected;

@end

@interface IKHospitalListViewController : IKViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tvList;
    UIImageView *imgvContent;
}
@property (nonatomic,strong) NSArray *aryAccountList;
@property (nonatomic,weak) id<IKHospitalDelegate> delegate;

@end
