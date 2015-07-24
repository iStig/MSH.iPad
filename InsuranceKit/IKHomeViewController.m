//
//  IKHomeViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-9.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKHomeViewController.h"
#import "IKTextView.h"
@interface IKHomeViewController ()

@end

@implementation IKHomeViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
	// Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor colorWithWhite:.26 alpha:1];
    
    
    
    
    vcNav = [[IKNavigationViewController alloc] init];
    [self.view addSubview:vcNav.view];
    
    vSideBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 42, 768-20)];
    [self.view addSubview:vSideBar];
    
    //  Generate SideBar Icon BG
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    v.backgroundColor = [UIColor colorWithRed:.96 green:.5 blue:.13 alpha:1];
    v.clipsToBounds = YES;
    v.layer.cornerRadius = 3;
    //    v.layer.borderColor = [UIColor colorWithRed:.19 green:.18 blue:.2 alpha:1].CGColor;
    //    v.layer.borderWidth = 1;
    
    
    
    NSArray *imgnames = [@"Clients,Authorization,About,Settings" componentsSeparatedByString:@","];
    for (int i=0;i<4;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = i<3?CGRectMake(4, 54+72*i, 34, 34):CGRectMake(4, 657+44, 34, 34);
        //        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        //        [btn setBackgroundImage:img forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"IKSideBarIcon%@.png",[imgnames objectAtIndex:i]]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"IKSideBarIcon%@Selected.png",[imgnames objectAtIndex:i]]] forState:UIControlStateSelected];
        [vSideBar addSubview:btn];
        [btn addTarget:self action:@selector(sideBarClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        btn.selected = i==dSelectedIndex;
    }
    
    
    
    //
    //    vContent = [[UIView alloc] initWithFrame:CGRectMake(42, 20, 1024-42, 868-20)];
    //    [self.view addSubview:vContent];
    vcClients = [[IKClientsViewController alloc] init];
    [vcNav pushViewController:vcClients animated:NO];
    //    vcClients.view.frame = vContent.bounds;
    //    [vContent addSubview:vcClients.view];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowed:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [NSThread detachNewThreadSelector:@selector(checkUpdate) toTarget:self withObject:nil];
}

- (void)checkUpdate{
    @autoreleasepool {
        NSDictionary *dict = [IKDataProvider getVersionInfo:nil];
        NSLog(@"Version Info:%@",dict);
        sw_dispatch_sync_on_main_thread(^{
            if ([dict objectForKey:@"data"]){
                [SVProgressHUD dismiss];
                versionInfo = [dict objectForKey:@"data"];
                
                NSString *latest = [versionInfo objectForKey:@"number"];
                NSString *current = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
                NSString *intro = [versionInfo objectForKey:@"introduce"];
                
                if ([current compare:latest]==NSOrderedAscending){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最新版本%@可供下载",latest] message:intro?[NSString stringWithFormat:@"更新说明：%@",intro]:nil delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即更新", nil];
                    [alert show];
                }
            }
        });
        
    }
}

- (void)sideBarClicked:(UIButton *)btn{
    if (dSelectedIndex!=btn.tag-100||btn.tag-100 == 1){
        dSelectedIndex = btn.tag-100;
        for (int i=0;i<4;i++){
            UIButton *iconbutton = (UIButton *)[vSideBar viewWithTag:100+i];
            iconbutton.selected = i==dSelectedIndex;
        }
        
        switch (dSelectedIndex) {
            case 0:
                if (!vcClients)
                    vcClients = [[IKClientsViewController alloc] init];
                vcNav.viewControllers = @[vcClients];
                break;
            case 1:{
                //                if (!vcAuthorization)
                //                    vcAuthorization = [[IKAuthorizationViewController alloc] init];
                //                vcAuthorization.shouldShowNavigationBar = YES;
                //                vcNav.viewControllers = @[vcAuthorization];
                if (!vcSearch)
                    vcSearch = [[IKSearchViewController alloc] init];
                vcSearch.shouldShowNavigationBar = NO;
                vcNav.viewControllers = @[vcSearch];
                
                
            }
                break;
            case 2:{
                if (!vcAbout)
                    vcAbout = [[IKAboutViewController alloc] init];
                vcNav.viewControllers = @[vcAbout];
                break;
            }
            case 3:{
                if (!vcMore)
                    vcMore = [[IKMoreViewController alloc] init];
                vcNav.viewControllers = @[vcMore];
            }
            default:
                break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideDutyView" object:nil];
}

- (void)viewWillLayoutSubviews{
    originalTransform = self.view.transform;
    vcNav.view.frame = CGRectMake(42, 20, 1024-42, 768-20);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeLeft;
//}

- (void)keyboardShowed:(NSNotification *)notice{
    UIView *v = [UIResponder currentFirstResponder];
    CGRect rect = [[[notice userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float h = MIN(rect.size.height, rect.size.width);
    
    if ([v isKindOfClass:[UITextField class]]||[v isKindOfClass:[IKTextView class]]){
//        if ([self isInAuthDetail:v] || [self isInAuthDetail:v.superview] || [self isInAuthDetail:v.superview.superview])
//            return;
        
        CGRect frame = [self.view convertRect:v.frame fromView:v.superview];
        
        if (frame.origin.y+frame.size.height>768-h){
            h = 768-frame.origin.y-frame.size.height-h;
            self.view.transform = CGAffineTransformTranslate(originalTransform, 0, h);
        }
        
        NSLog(@"Current Field:%@",NSStringFromCGRect(v.frame));
    }
    
    
    
}

- (BOOL)isInAuthDetail:(UIView *)tf{
    UIView *v = tf;
    while (v.superview) {
        if ([v isKindOfClass:NSClassFromString(@"IKApplyDetailView")])
            return YES;
        
        v = v.superview;
    }
    
    return NO;
}

- (void)keyboardHidden:(NSNotification *)notice{
    self.view.transform = originalTransform;
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"立即更新"]){
        NSString *link = [versionInfo objectForKey:@"link"];
        if (link){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
        }
    }
}

@end
