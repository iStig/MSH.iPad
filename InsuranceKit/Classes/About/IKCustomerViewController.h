//
//  IKCustomerViewController.h
//  InsuranceKit
//
//  Created by iStig on 14-9-19.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKTextView.h"


@interface IKCustomerViewController : IKViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>{
    UITableView *tvList;
    NSArray *titleAry;
    NSMutableDictionary *evaluateDic;
    
    IKTextView *noteView;
    UITextField *nameText;
    UITextField *mailtext;
    UITextField *docterName;
    
    NSArray   *titles_cell_min;
    
    NSArray   *titles_cell_treatment;
    
    NSArray   *titles_cell_normal;
}

@end
