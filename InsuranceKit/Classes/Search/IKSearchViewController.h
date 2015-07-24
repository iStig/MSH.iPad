//
//  IKSearchViewController.h
//  InsuranceKit
//
//  Created by iStig on 14-9-16.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
typedef enum {
    IKSearchMedicalRecords  = 100,//就诊记录
    IKSearchAuthorization = 101,//事件授权
    IKSearchClaim = 102,//理赔申请
}IKsearchType;

@interface IKSearchViewController : IKViewController{

        NSMutableArray *aryList;

}

@end
