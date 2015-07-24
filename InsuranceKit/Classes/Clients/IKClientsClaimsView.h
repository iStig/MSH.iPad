//
//  IKClientClaimsView.h
//  InsuranceKit
//
//  Created by iStig on 14-10-8.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKView.h"


@interface IKClientsClaimsView : IKView<UITableViewDataSource,UITableViewDelegate>{

    UITableView *tvList;
    UIRefreshControl *rcList;
    NSMutableArray *aryList;
    
     NSArray *visitDatabaArr;
}

@end
