//
//  IKChangePasswordViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKChangePasswordViewController.h"

@interface IKChangePasswordViewController ()

@end

@implementation IKChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"k_UpdatePassword")];
    [self addBGColor:[UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1]];

    
    UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(29, 60, 60, 17) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.42 alpha:1]];
    lbl.text = LocalizeStringFromKey(@"k_Oldpassword");
    [self.view addSubview:lbl];
    CGRect frame = lbl.frame;
    [lbl sizeToFit];
    frame.size.width = lbl.frame.size.width;
    lbl.frame = frame;
    tfOldPassword = [[UITextField alloc] initWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+5, lbl.frame.origin.y-15, 265, 47)];
    tfOldPassword.secureTextEntry = YES;
    tfOldPassword.backgroundColor = [UIColor clearColor];
    tfOldPassword.font = lbl.font;
    tfOldPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfOldPassword];
    
    lbl = [UILabel createLabelWithFrame:CGRectMake(29, 117, 60, 17) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.42 alpha:1]];
    lbl.text = LocalizeStringFromKey(@"k_Newpassword");
    [self.view addSubview:lbl];
    frame = lbl.frame;
    [lbl sizeToFit];
    frame.size.width = lbl.frame.size.width;
    lbl.frame = frame;
    tfNewPassword = [[UITextField alloc] initWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+5, lbl.frame.origin.y-15, 265, 47)];
    tfNewPassword.backgroundColor = [UIColor clearColor];
    tfNewPassword.secureTextEntry = YES;
    tfNewPassword.font = lbl.font;
    tfNewPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfNewPassword];
    
    lbl = [UILabel createLabelWithFrame:CGRectMake(29, 174, 100, 17) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.42 alpha:1]];
    lbl.text = LocalizeStringFromKey(@"k_Confirmnewpassword");
    [self.view addSubview:lbl];
    frame = lbl.frame;
    [lbl sizeToFit];
    frame.size.width = lbl.frame.size.width;
    lbl.frame = frame;
    tfConfirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+5, lbl.frame.origin.y-15, 265, 47)];
    tfConfirmPassword.backgroundColor = [UIColor clearColor];
    tfConfirmPassword.secureTextEntry = YES;
    tfConfirmPassword.font = lbl.font;
    tfConfirmPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfConfirmPassword];
    
    
    for (int i=0;i<3;i++){
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 95+57*i, 322, 1)];
        line.backgroundColor = [UIColor colorWithWhite:.82 alpha:1];
        [self.view addSubview:line];
    }
    
    
    btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSubmit.clipsToBounds = YES;
    btnSubmit.layer.cornerRadius = 2;
    btnSubmit.frame = CGRectMake(0, 0, 150, 40);
    btnSubmit.layer.borderColor = [UIColor colorWithRed:.95 green:.18 blue:.04 alpha:1].CGColor;
    btnSubmit.layer.borderWidth = 1;
    [btnSubmit setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.95 green:.35 blue:.31 alpha:1] size:btnSubmit.frame.size] forState:UIControlStateNormal];
    [btnSubmit setTitle:LocalizeStringFromKey(@"kOk") forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:20];
    [btnSubmit addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
}

- (void)submitClicked{
    if ([tfNewPassword.text isEqualToString:tfConfirmPassword.text]){
        if (tfNewPassword.text.length<6)
            [UIAlertView showAlertWithTitle:nil message:@"密码长度不能少于6位" cancelButton:nil];
        
        if (tfOldPassword.text.length>0){
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:tfOldPassword.text,@"oldPasswd",tfNewPassword.text,@"newPasswd",[[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"],@"providerID", nil];
            
            [SVProgressHUD showWithStatus:@"正在修改密码"];
            [NSThread detachNewThreadSelector:@selector(changePassword:) toTarget:self withObject:dict];
        }else{
            [UIAlertView showAlertWithTitle:nil message:@"请输入旧密码" cancelButton:nil];
        }
    }else{
        [UIAlertView showAlertWithTitle:nil message:@"两次密码不一致" cancelButton:nil];
    }
}

- (void)changePassword:(NSDictionary *)info{
    @autoreleasepool {
        NSDictionary *dict = [IKDataProvider updatePassword:info];
        
        NSLog(@"Update Password:%@",dict);
        
        sw_dispatch_sync_on_main_thread(^{
            int result = [[dict objectForKey:@"result"] intValue];
            if (0==result && dict){
                [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
                tfNewPassword.text = nil;
                tfOldPassword.text = nil;
                tfConfirmPassword.text = nil;
                [self.view endEditing:YES];
            }else{
                NSString *errStr = [dict objectForKey:@"errStr"];
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"密码修改失败,%@",errStr?errStr:@"请稍候再试"]];
            }
        });
        
    }
}

- (void)viewWillLayoutSubviews{
    btnSubmit.center = CGPointMake(self.view.frame.size.width/2, 310);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
