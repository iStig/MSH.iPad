//
//  IKClientsLogView.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IKPhotoCDSO;
@interface IKClientsLogView : IKView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    UIPopoverController *pcPhotoPicker;
    UICollectionView *cvList;
    
    NSMutableArray *aryList;
    IKPhotoCDSO *selectedPhoto;
}

@end
