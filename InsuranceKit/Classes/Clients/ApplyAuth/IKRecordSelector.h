//
//  IKRecordSelector.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-5.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IKRecordSelectorDelegate

- (void)recordPhotoSelected:(NSArray *)photos;

@end

@interface IKRecordSelector : UIView<UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImageView *imgvBG;
    UICollectionView *cvList;
    UIPopoverController *pcPhotoPicker;
    
    NSMutableArray *aryList,*arySelectedList;
    NSDictionary *selectedPhotoInfo;
}
@property (nonatomic,weak) UIViewController *vcParent;
@property (nonatomic,strong) IKVisitCDSO *visit;
@property (nonatomic,weak) id<IKRecordSelectorDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *aryList;

+ (id)view;
+ (void)showWithVisit:(IKVisitCDSO *)vis delegate:(id<IKRecordSelectorDelegate>)dele selected:(NSArray *)selected;
+ (void)showWithVisitInfo:(NSDictionary *)visitInfo delegate:(id<IKRecordSelectorDelegate>)dele selected:(NSArray *)selected;
- (void)show;


@end
