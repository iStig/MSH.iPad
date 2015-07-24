//
//  IKLoginViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKLoginViewController.h"
#import "IKDataProvider.h"
#import "IKGuideViewController.h"
#import "IKAppDelegate.h"

@interface IKLoginViewController ()

@end

@implementation IKLoginViewController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    imgvBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKBGLogin.png"]];
    [self.view addSubview:imgvBG];
    
    NSString *language = [InternationalControl userLanguage];
    if ([language isEqualToString:@"en"])
        [imgvBG setImage:[UIImage imageNamed:@"IKBGLoginEn.png"]];
    else
        [imgvBG setImage:[UIImage imageNamed:@"IKBGLogin.png"]];
    
    
    tfAccount = [[UITextField alloc] initWithFrame:CGRectMake(420, 248, 236, 32)];
//    tfAccount.userInteractionEnabled = NO;
    tfAccount.font = [UIFont systemFontOfSize:30];
    tfAccount.text = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"];
    tfAccount.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tfAccount];
    
    tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(420, 292, 236, 32)];
    tfPassword.font = [UIFont systemFontOfSize:30];
    tfPassword.secureTextEntry = YES;
    tfPassword.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tfPassword];
    
    btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.frame = CGRectMake(369, 373, 286, 46);
    [btnLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.88 green:.5 blue:.14 alpha:1] size:btnLogin.frame.size] forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont boldSystemFontOfSize:17];
   // [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [btnLogin setTitle:LocalizeStringFromKey(@"kSignin") forState:UIControlStateNormal];

    [self.view addSubview:btnLogin];
    [btnLogin addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    //中文Button
    btnLoginCh=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLoginCh.frame=CGRectMake(430, 445, 80, 30);
    
    //normal
    [btnLoginCh setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.94 green:.9 blue:.9 alpha:1] size:btnLoginCh.frame.size] forState:UIControlStateNormal];
    [btnLoginCh setTitleColor:[UIColor colorWithRed:.58 green:.5 blue:.5 alpha:1]  forState:UIControlStateNormal];
    
//select
    [btnLoginCh setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.88 green:.5 blue:.14 alpha:1] size:btnLoginCh.frame.size] forState:UIControlStateSelected];//黄色
    [btnLoginCh setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];//白
    
    
    btnLoginCh.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [btnLoginCh setTitle:@"中文" forState:UIControlStateNormal];
    [btnLoginCh setTitle:@"中文" forState:UIControlStateSelected];
    [self.view addSubview:btnLoginCh];
    btnLoginCh.tag=10;
    btnLoginCh.selected = [[InternationalControl userLanguage] isEqualToString:@"zh-Hans"]?YES:NO;
    [btnLoginCh addTarget:self action:@selector(localLanguage:) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    //EnglishBtn
    btnLoginEng=[UIButton buttonWithType:UIButtonTypeCustom];
    btnLoginEng.frame=CGRectMake(510, 445, 80, 30);
    
    //normal
    [btnLoginEng setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.94 green:.9 blue:.9 alpha:1] size:btnLoginEng.frame.size] forState:UIControlStateNormal];
    [btnLoginEng setTitleColor:[UIColor colorWithRed:.58 green:.5 blue:.5 alpha:1] forState:UIControlStateNormal];
    
    //select
    [btnLoginEng setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.88 green:.5 blue:.14 alpha:1] size:btnLoginEng.frame.size] forState:UIControlStateSelected];
    [btnLoginEng setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    btnLoginEng.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [btnLoginEng setTitle:@"English" forState:UIControlStateNormal];
    [btnLoginEng setTitle:@"English" forState:UIControlStateSelected];
    btnLoginEng.tag=20;
    btnLoginEng.selected =  [[InternationalControl userLanguage] isEqualToString:@"zh-Hans"]?NO:YES;
    [self.view addSubview:btnLoginEng];
    [btnLoginEng addTarget:self action:@selector(localLanguage:) forControlEvents:UIControlEventTouchUpInside];
    
    
    lblDeviceID = [UILabel createLabelWithFrame:CGRectZero font:[UIFont systemFontOfSize:12] textColor:[UIColor grayColor]];
    lblDeviceID.text = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
    [lblDeviceID sizeToFit];
    lblDeviceID.center = CGPointMake(512, 768-lblDeviceID.frame.size.height*.5f);
    [self.view addSubview:lblDeviceID];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 60, 40);
//    [btn setImage:[UIImage imageNamed:@"IKSideBarIconSettings.png"] forState:UIControlStateNormal];
//    btn.center = CGPointMake(1024-30, 768-25);
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(settingsClicked) forControlEvents:UIControlEventTouchUpInside];
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipped)];
    swipeGesture.numberOfTouchesRequired = 3;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    totalSwipped = 0;
    [self.view addGestureRecognizer:swipeGesture];
//    [self loginClicked];
    
    
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:kChangeLanguge object:nil];
        
    
}

- (void)changeLanguage:(NSNotification *)notification
{
    NSString *language = [InternationalControl userLanguage];
    if ([language isEqualToString:@"en"])
        [imgvBG setImage:[UIImage imageNamed:@"IKBGLoginEn.png"]];
    else
        [imgvBG setImage:[UIImage imageNamed:@"IKBGLogin.png"]];
    [btnLogin setTitle:LocalizeStringFromKey(@"kSignin")forState:UIControlStateNormal];

    
}

- (void)swipped{
    if (!lastSwipeTime){
        lastSwipeTime = [NSDate date];
    }
    
    if ([[NSDate date] timeIntervalSinceDate:lastSwipeTime]<0.3f)
        totalSwipped++;
    else
        totalSwipped = 1;
    lastSwipeTime = [NSDate date];
    if (totalSwipped>=5){
        BOOL isInTest = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInTest"];
        isInTest = !isInTest;
        [[NSUserDefaults standardUserDefaults] setBool:isInTest forKey:@"IsInTest"];
        
        [UIAlertView showAlertWithTitle:isInTest?@"切到到测试环境":@"切换到正式环境" message:nil cancelButton:nil];
        totalSwipped = 0;
        lastSwipeTime = nil;
    }
}

- (void)settingsClicked{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入管理员账号密码" message:nil delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") otherButtonTitles:LocalizeStringFromKey(@"kOk"), nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
}

- (void)loginClicked{
    if (tfAccount.text.length>0 && tfPassword.text.length>0){
        [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kSigning")];
        
        [NSThread detachNewThreadSelector:@selector(loginAccount:) toTarget:self withObject:[NSDictionary dictionaryWithObjectsAndKeys:tfAccount.text,@"providerID",[[[tfPassword.text dataUsingEncoding:NSUTF8StringEncoding] MD5String] lowercaseString],@"password", nil]];
    }else{
        [UIAlertView showAlertWithTitle:nil message:@"用户名和密码不能留空" cancelButton:nil];
    }
    
    
    
//    [self.delegate accountDidLogin];
}

-(IBAction)localLanguage:(UIButton*)sender{
 
    if (!sender.selected) {
        
        if (sender == btnLoginCh) {
            btnLoginCh.selected = YES;
            btnLoginEng.selected = NO;
            
            [InternationalControl setUserlanguage:@"zh-Hans"];
            //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:kChangeLanguge object:nil];
            
        }else{
            btnLoginCh.selected = NO;
            btnLoginEng.selected = YES;
            
            [InternationalControl setUserlanguage:@"en"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kChangeLanguge object:nil];
            

        }
        
    }
}


- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangeLanguge object:nil];
}

- (void)loginAccount:(NSDictionary *)account{
    @autoreleasepool {
        NSDictionary *dict = [IKDataProvider login:account];
        
        sw_dispatch_sync_on_main_thread(^{
            if ([dict objectForKey:@"data"]){
                NSMutableDictionary *hospitalInfo = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"data"]];
                [hospitalInfo setObject:[account objectForKey:@"providerID"] forKey:@"providerID"];
                
                [IKDataProvider saveHospitalInfo:hospitalInfo];
                
                
                [self.delegate accountDidLogin];
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            }else{
                NSString *errStr = [dict objectForKey:@"errStr"];
                [SVProgressHUD showErrorWithStatus:errStr?errStr:@"登录失败，请检查您的网络后重试"];
            }
        });
        
    }
}

- (void)showHospitalList{
    IKHospitalListViewController *vcHospitalList = [[IKHospitalListViewController alloc] init];
    [self presentViewController:vcHospitalList animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:LocalizeStringFromKey(@"kOk")]){
        NSString *userID = [alertView textFieldAtIndex:0].text;
        NSString *password = [alertView textFieldAtIndex:1].text;
        if (userID.length>0 && password.length>0){
            [SVProgressHUD showWithStatus:@"正在获取账号列表"];
            
            sw_dispatch_async_on_background_thread(^{
                @autoreleasepool {
                    NSDictionary *dict = [IKDataProvider getAccountList:[NSDictionary dictionaryWithObjectsAndKeys:userID,@"UserID",password,@"password", nil]];
                    NSArray *ary = [dict objectForKey:@"data"];
                    if (ary){
                        sw_dispatch_sync_on_main_thread(^{
                            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                            IKHospitalListViewController *vcHospitalList = [[IKHospitalListViewController alloc] init];
                            vcHospitalList.delegate = self;
                            vcHospitalList.aryAccountList = ary;
                            [self presentViewController:vcHospitalList animated:YES completion:^{
                                
                            }];
                        });
                    }else{
                        NSString *errStr = [dict objectForKey:@"errStr"];
                        sw_dispatch_sync_on_main_thread(^{
                            [SVProgressHUD showErrorWithStatus:errStr?errStr:@"登录失败，请检查您的网络后重试"];
                        });
                    }
                }
            });
            
            
            
            
            
            
        }
        
        
    }
}

#pragma mark - IKHospitalDelegate
- (void)hospitalSelected{
    tfAccount.text = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"];
    tfPassword.text = nil;
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    UITextField *tf = [alertView textFieldAtIndex:0];
    tf.placeholder = @"管理员账号";
    tf = [alertView textFieldAtIndex:1];
    tf.placeholder = LocalizeStringFromKey(@"kPassword");
}


@end
