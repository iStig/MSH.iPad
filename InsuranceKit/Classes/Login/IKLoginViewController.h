//
//  IKLoginViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKHospitalListViewController.h"
#import <AdSupport/AdSupport.h>

@protocol IKLoginViewControllerDelegate

- (void)accountDidLogin;

@end

@interface IKLoginViewController : IKViewController<UIAlertViewDelegate,IKHospitalDelegate>{
    UIImageView *imgvBG;
    UITextField *tfAccount,*tfPassword;
    UIButton *btnLogin;
    UILabel *lblDeviceID;
    
    UISwipeGestureRecognizer *swipeGesture;
    int totalSwipped;
    NSDate *lastSwipeTime;
    
    UIButton *btnLoginCh;
    UIButton *btnLoginEng;
}
@property (nonatomic,weak) id<IKLoginViewControllerDelegate,IKViewControllerDelegate> delegate;

@end
