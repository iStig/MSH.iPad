//
//  IKHospitalViewController.h
//  InsuranceKit
//
//  Created by iStig on 14-9-19.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKTextView.h"


@interface IKHospitalViewController : IKViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>{
    UITableView *tvList;
    NSArray *titleAry;
    NSMutableDictionary *evaluateDic;
    
    IKTextView *noteView;
    
        NSArray   *titles_cell_normal;
        NSArray   *titles_cell_delay;
     NSArray   *titles_cell_communite;
}

@end
