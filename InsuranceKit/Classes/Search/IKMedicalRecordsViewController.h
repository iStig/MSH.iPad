//
//  IKMedicalRecordsViewController.h
//  InsuranceKit
//
//  Created by iStig on 14-9-16.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKDateRangeSelector.h"

@interface IKMedicalRecordsViewController : IKViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,IKDateRangerDelegate>{
    
    
    UITableView *tvList;
    UITextField *tfSearch;
    UIRefreshControl *rcList;
    
    UIImageView *imgvArrowTime;
    
    NSMutableArray *aryList;
    NSDate *dateStart,*dateEnd;
    NSInteger dCurrentPage;

    
}

@end
