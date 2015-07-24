//
//  IKAddPhotoView.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-13.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKPopCenterView.h"

@interface IKAddPhotoView : IKPopCenterView<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>{
    UICollectionView *cvList;
    
    
    CGRect popFrame;
    NSMutableArray *aryList;
    UIPopoverController *pcPhotoPicker;
}

@end
