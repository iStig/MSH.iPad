//
//  IKClientsViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-9.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKClientsListViewController.h"
#import "IKClientsDetailViewController.h"

@interface IKClientsViewController : IKViewController<IKClientsListDelegate,IKViewControllerDelegate>{
    IKClientsListViewController *vcList;
    IKClientsDetailViewController *vcDetail;
    UIView *vRight;
}

@end
