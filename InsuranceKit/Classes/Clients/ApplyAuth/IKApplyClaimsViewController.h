//
//  IKApplyClaimsViewController.h
//  InsuranceKit
//
//  Created by iStig on 14-10-8.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKInputView.h"
#import "IKApplyClaimsDetailView.h"

@interface IKApplyClaimsViewController : IKViewController{


    UIView *vLeft;
    IKApplyClaimsDetailView *vDetail;
    


}

@property (nonatomic,strong) NSString *claimsNo;
@property (nonatomic, strong) NSString *claimStatus;
@property (nonatomic,strong) NSMutableDictionary *dicAuthInfo;
@property (nonatomic,strong) NSMutableDictionary *otherVisitInfo;
@property (nonatomic,strong) NSArray *selectArr;
@property NSString *key;
- (NSDictionary *)authInfo;
- (NSArray *)selectImgArr;
- (void)resignTextFieldInFirstResponse;

@end
