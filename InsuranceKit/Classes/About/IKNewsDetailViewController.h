//
//  IKNewsDetailViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"

@interface IKNewsDetailViewController : IKViewController{
    UIWebView *wvContent;
}
@property (nonatomic,strong) NSDictionary *dicInfo;

@end
