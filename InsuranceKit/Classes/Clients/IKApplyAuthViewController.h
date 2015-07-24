//
//  IKApplyAuthViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKApplyDetailView.h"
#import "IKAddRecordsPhotoView.h"

typedef enum {
    IKAuthTypeCheck,
    IKAuthTypeHospital,
    IKAuthTypeBirth,
    IKAuthTypeDevice,
    IKAuthTypeChemical,
    IKAuthTypeRadical,
    IKAuthTypePhysical,
    IKAuthTypeOther
}IKAuthType;

@interface IKApplyAuthViewController : IKViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,IKAddRecordsPhotoViewDelegate>{
    UILabel *lblName,*lblPhone,*lblMethod;
    UITextView *lblPhotoNum;
    UIImageView *imgvTable;
    UIImageView *imgvFakeContent;
    
    UIView *vLeft;
    IKApplyDetailView *vDetail;
    UITableView *tvLeft;
    
//    NSMutableArray *aryReportImages;
    IKAuthType authType;
}
@property (nonatomic,strong) NSMutableArray *aryReportImages;
@property (nonatomic,strong) NSMutableDictionary *dicAuthInfo;
@property (nonatomic,strong) NSString *CaseId;

- (NSDictionary *)authInfo;



@end
