//
//  IKClaimViewController.h
//  InsuranceKit
//
//  Created by iStig on 14-9-16.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKStatusSelector.h"
#import "IKDateRangeSelector.h"
#import "IKClaimsStateSelector.h"

@interface IKClaimViewController : IKViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,IKStatusSelectorDelegate,IKDateRangerDelegate,IKClaimsStatusSelectorDelegate>{
    
    
    UITableView *tvList;
    UITextField *tfSearch;
    UIRefreshControl *rcList;
    
    UIImageView *imgvArrowTime,*imgvArrowStatus;
    
    NSMutableArray *aryList;
    NSDate *dateStart,*dateEnd;
    NSInteger dCurrentPage;
    
    int applyStatus;
    
   
}
@property (nonatomic, strong)  NSMutableArray *ClaimStateList;

@end
