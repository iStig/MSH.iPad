//
//  IKMoreListViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKMoreListViewController.h"
#import "IKAboutListCell.h"

@interface IKMoreListViewController ()

@end

@implementation IKMoreListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"kMore")];
    [self addBGColor:nil];
    
    tvList = [[UITableView alloc] init];
    tvList.delegate = self;
    tvList.dataSource = self;
    tvList.backgroundColor = self.view.backgroundColor;
    [tvList registerClass:[IKAboutListCell class] forCellReuseIdentifier:@"AboutListCellIdentifier"];
    tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tvList];
    
    [tvList selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (void)viewWillLayoutSubviews{
    tvList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IKAboutListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutListCellIdentifier"];
    
    
    cell.title = [@[LocalizeStringFromKey(@"k_UpdatePassword"),LocalizeStringFromKey(@"k_Upgrade")] objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectLeftItemAtIndex:indexPath.row];
}

@end
