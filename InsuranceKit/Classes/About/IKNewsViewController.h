//
//  IKNewsViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"

@interface IKNewsViewController : IKViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tvList;
    
    NSMutableArray *aryList;
    BOOL isLoadingMore;
}

@end
