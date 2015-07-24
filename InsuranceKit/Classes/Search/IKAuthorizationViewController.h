//
//  IKAuthorizationViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKStatusSelector.h"
#import "IKDateRangeSelector.h"

typedef enum {
    IKAuthStatusHandling,
    IKAuthStatusRefused,
    IKAuthStatusAccept
}IKAuthStatus;

@interface IKAuthorizationViewController : IKViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,IKStatusSelectorDelegate,IKDateRangerDelegate>{
    UITableView *tvList;
    UITextField *tfSearch;

    UIImageView *imgvArrowTime,*imgvArrowStatus;

    UIRefreshControl *rcList;
    
    NSMutableArray *aryList;
    
    NSDate *dateStart,*dateEnd;
    NSInteger dCurrentPage;
    int applyStatus;
}

@end
