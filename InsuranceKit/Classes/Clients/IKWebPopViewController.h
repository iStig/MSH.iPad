//
//  IKWebPopViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-16.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKWebPopViewController : UIViewController{
    UIWebView *wvContent;
}
@property (nonatomic,strong) NSString *content;

@end
