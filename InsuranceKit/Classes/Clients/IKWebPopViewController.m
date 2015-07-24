//
//  IKWebPopViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-16.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKWebPopViewController.h"

@interface IKWebPopViewController ()

@end

@implementation IKWebPopViewController
@synthesize content;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    wvContent = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    [self.view addSubview:wvContent];
    [wvContent loadHTMLString:content baseURL:nil];
}

- (CGSize)preferredContentSize{
    return CGSizeMake(320, 216);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
