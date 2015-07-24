//
//  IKChangePasswordViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"

@interface IKChangePasswordViewController : IKViewController{
    UIView *vContent;
    UITextField *tfOldPassword,*tfNewPassword,*tfConfirmPassword;
    UIButton *btnSubmit;
}

@end
