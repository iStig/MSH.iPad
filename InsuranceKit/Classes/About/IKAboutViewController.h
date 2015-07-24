//
//  IKAboutViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKAboutListViewController.h"
#import "BSTCoverView.h"

@interface IKAboutViewController : IKViewController<IKViewControllerDelegate,BSTCoverViewDelegate>{
    IKNavigationViewController *navLeft,*navRight;
    UIView *vRight;
}

@end
