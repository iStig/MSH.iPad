//
//  IKApplyClaimsDetailView.h
//  InsuranceKit
//
//  Created by iStig on 14-10-8.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKView.h"
#import "IKDatePickerViewController.h"
#import "IKAddRecordsPhotoView.h"
#import "IKDataProvider.h"
#import "IKPhotoCDSO.h"
#import "IKUnlimitDatePickerController.h"
@class IKApplyClaimsViewController;



@interface IKApplyClaimsDetailView : IKView<UITextFieldDelegate,IKAddRecordsPhotoViewDelegate,UIAlertViewDelegate,NSFetchedResultsControllerDelegate>{
  UIScrollView *scvBG;
  UILabel *lblDate,*lblEndDate,*lblUnit,*lblState,*lblPhotoNum;
  UIPopoverController *beginDate,*endDate;
  UIView *vMethodList;
  NSArray *aryTitles;
  UITextField *tfExpenses;
  UIButton *btnSubmit,*btnSave,*btnDelete,*btnDate,*btnDate_end,*btnAddRecord;
  NSDictionary *dicApplyInfo;
  NSInteger visitType;//（1-门诊，2-住院，3-齿科，4-眼科，5-体检）
    
  NSDate *dateBegin;
  NSDate *dateEnd;
    

    IKPhotoCDSO *photo;
    
    NSMutableArray *aryReportImages;
    NSMutableArray *aryReportImages_noPad;
    BOOL isPad;
    NSInteger photoIndex;
}
@property (nonatomic,weak) IKApplyClaimsViewController *vcApplyClaims;
@property (nonatomic,strong) NSMutableDictionary *dicAuthInfo;
@property (nonatomic,strong) NSMutableDictionary *otherVisitInfo;
@property (nonatomic,strong)NSString *key;

- (void)showInfo:(NSDictionary *)info;

@end
