//
//  IKSummaryViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKDateRangeSelector.h"

@interface IKSummaryViewController : IKViewController<UITableViewDataSource,UITableViewDelegate,IKDateRangerDelegate,UIAlertViewDelegate>{
    UITableView *tvList;
    UIRefreshControl *rcList;
    
    NSMutableArray *aryList;
    int dCurrentPage;
    NSDate *dateStart,*dateEnd;
    NSString *strEmailAddress;
    BOOL isLoadingMore;
}

@end
