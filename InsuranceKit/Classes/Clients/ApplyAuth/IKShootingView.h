//
//  IKShootingView.h
//  InsuranceKit
//
//  Created by K.E. on 15/1/26.
//  Copyright (c) 2015年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKView.h"
#import "IKSelectPhotoFromRecordsView.h"
#import "IKSelectPhotoOtherView.h"
#import "IKSelectPhotoPayDetailView.h"
//@protocol IKShootingViewDelagate <NSObject>
//
//-(void)shootingShow:(NSString *)title;
//@end

@protocol IKShootingViewDelegate

- (void)selectImageArr:(NSArray *)allImgArr;

@end
typedef NS_ENUM(NSInteger, claimAddPhotoType) {
    claimPhotoType_all=0,
    claimPhotoType_received,
    claimPhotoType_needmr,
    claimPhotoType_processing,
    claimPhotoType_paid
};

typedef NS_ENUM(NSInteger, claimType) {
    claimTypeShootingRecords,
    claimTypeShootingPayDetail,
    claimTypeShootingOther
};
@interface IKShootingView : IKView<IKSelectPhotoFromRecordsViewDelegate,IKSelectPhotoOtherViewDelegate,IKSelectPhotoPayDetailViewDelegate>
{
    UIView *line;
    UILabel *lblTitle;
    UILabel *lblShootingPages;
    UIImageView *photoImageview;
    BOOL isPad;
    NSDictionary *dicApplyInfo;
    NSMutableArray *aryReportImages;
    NSMutableArray *aryReportImages_noPad;
    
    int claimPhotoType;
}

@property (nonatomic,weak) id<IKShootingViewDelegate> delegate;

@property (nonatomic,strong) NSString *claimsNo;

@property (nonatomic,strong) NSString *key;
@property (nonatomic) BOOL necessary;
@property (nonatomic,strong) UIColor *lineColor;
//@property (nonatomic,weak) id<IKShootingViewDelagate> delegate;
@property (nonatomic,copy)NSString *titleType;
@property (nonatomic,strong) NSMutableDictionary *otherVisitInfo;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title shootingPagesTextColor:(UIColor*)color shootingPagesText:(NSString *)shootingPagesText photoImgName:(NSString *)photoImgName claimType:(NSInteger)claimType visit:(IKVisitCDSO *)visi;

@property (nonatomic, retain)NSArray * photoCardArr;
@property (nonatomic, retain)NSArray * photoPaymentArr;
@property (nonatomic, retain)NSArray * photoOtherArr;
- (void)showInfo:(NSDictionary *)info;
@property NSString *photoStatus;
@end