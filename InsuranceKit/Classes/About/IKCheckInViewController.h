//
//  IKCheckInViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"

@interface IKCheckInViewController : IKViewController{
    UIView *vContent;
    UITextField *tfName,*tfEmail,*tfPhone;
    UIButton *btnSubmit;
}

@end
