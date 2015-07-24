//
//  IKPhotoViewer.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-5.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IKPhotoCDSO;

typedef enum {
    IKPhotoViewerTypeIDCard,//身份证
    IKPhotoViewerTypeSign,//签名
    IKPhotoViewerTypeFullscreen,//全屏
    IKPhotoViewerTypeInsurance//保险卡
}IKPhotoViewerType;

@interface IKPhotoViewer : UIView<UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIAlertViewDelegate>{
    UIImageView *imgvBG;
    UICollectionView *cvList;
    UIPopoverController *pcPhotoPicker;
    UIImageView *imgvPhoto;
    
    NSMutableArray *aryList;
    int viewerType;// 0-id card,1-sign, 2-fullscreen, 3-insurance
    IKPhotoCDSO *selectedPhoto;
}
@property (nonatomic,weak) UIViewController *vcParent;
@property (nonatomic,strong) IKVisitCDSO *visit;
@property (nonatomic,strong) NSMutableArray *aryList;
@property (nonatomic, strong) NSMutableArray *photos;
@property NSMutableArray *uploadNotPhotoAry;

+ (void)showIDCardPhoto:(IKVisitCDSO *)visit;
+ (void)showInsuranceCardPhoto:(IKVisitCDSO *)visit;
+ (void)showSignPhoto:(IKVisitCDSO *)visit;

+ (void)showFullImage:(UIImage *)img;

- (void)reloadData;

@end
