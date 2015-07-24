//
//  IKNewsDetailViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKNewsDetailViewController.h"

@interface IKNewsDetailViewController ()

@end

@implementation IKNewsDetailViewController
@synthesize dicInfo;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"kNews")];
    [self addBGColor:[UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1]];
    [self addNavBack];
    
    wvContent = [[UIWebView alloc] init];
    [self.view addSubview:wvContent];
    
    NSString *html = [NSString stringWithFormat:@"<html><body><h1>%@</h1><p><img src=\"%@\"/></p><p>%@<p></body></html>",[dicInfo objectForKey:@"title"],[dicInfo objectForKey:@"path"],[dicInfo objectForKey:@"content"]];
    [wvContent loadHTMLString:html baseURL:nil];
}

- (void)viewWillLayoutSubviews{
    wvContent.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
