//
//  IKAddRecordsPhoto.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-3.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKRecordSelector.h"


@protocol IKAddRecordsPhotoViewDelegate

- (void)recordsAdded:(NSArray *)photos;

@end

@interface IKAddRecordsPhotoView : UIView<UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,IKRecordSelectorDelegate>{
    UIImageView *imgvBG;
    UICollectionView *cvList;
    UIPopoverController *pcPhotoPicker;
    
    NSMutableArray *aryList;
    NSDictionary *selectedPhotoInfo;
    NSString *aryCacheImage;
  
}
@property (nonatomic,weak) UIViewController *vcParent;
@property (nonatomic,strong) IKVisitCDSO *visit;
@property (nonatomic,strong) NSDictionary *dicVisitInfo;
@property (nonatomic,weak) id<IKAddRecordsPhotoViewDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *aryList;
@property (nonatomic,strong) NSMutableDictionary *otherVisitInfo;
@property (nonatomic)  BOOL canEditPhoto;
@property (nonatomic) BOOL isPad;

+ (id)view;
- (void)show;
@end
