//
//  IKClientsAuthorizationView.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKClientsAuthorizationView : IKView<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tvList;
    UIRefreshControl *rcList;
    
    NSMutableArray *aryList;
}

@end
