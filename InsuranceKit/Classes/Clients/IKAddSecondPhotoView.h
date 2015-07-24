//
//  IKAddSecondPhotoView.h
//  InsuranceKit
//
//  Created by iStig on 14-9-26.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKPopCenterView.h"

@interface IKAddSecondPhotoView : IKPopCenterView<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>{
    UICollectionView *cvList;
    
    
    CGRect popFrame;
    NSMutableArray *aryList;
    UIPopoverController *pcPhotoPicker;
}




@end
