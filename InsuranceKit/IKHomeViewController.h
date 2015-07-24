//
//  IKHomeViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-9.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKClientsViewController.h"
#import "IKAboutViewController.h"
#import "IKMoreViewController.h"
#import "IKAuthorizationViewController.h"
#import "IKSearchViewController.h"

@interface IKHomeViewController : IKViewController<UIAlertViewDelegate>{
    IKNavigationViewController *vcNav;
    IKClientsViewController *vcClients;
    IKAboutViewController *vcAbout;
    IKMoreViewController *vcMore;
    IKAuthorizationViewController *vcAuthorization;
    
    IKSearchViewController *vcSearch;
    UIView *vSideBar,*vContent;
    
    NSUInteger dSelectedIndex;
    CGAffineTransform originalTransform;
    NSDictionary *versionInfo;
}

@end
