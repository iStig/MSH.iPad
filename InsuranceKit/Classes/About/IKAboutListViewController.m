//
//  IKAboutListViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKAboutListViewController.h"
#import "IKAboutListCell.h"
@interface IKAboutListViewController ()

@end

@implementation IKAboutListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"kAbout")];
    
//    NSArray *ary = [@"联系方式,直付流程,公司形象展示,新闻栏,回访客户登记,自付额统计表,医院评价,客户评价" componentsSeparatedByString:@","];
    NSArray *ary = @[LocalizeStringFromKey(@"kContactinformation"),
                     LocalizeStringFromKey(@"kaboutDirectbilling"),
                     LocalizeStringFromKey(@"kAboutMSHChina"),
                     LocalizeStringFromKey(@"kNews"),
                     LocalizeStringFromKey(@"kPotentialclient"),
                     LocalizeStringFromKey(@"kCo-paysummary"),
                     LocalizeStringFromKey(@"kSuggestionfromprovider"),
                     LocalizeStringFromKey(@"kSuggestionfromClient")];

    aryList = [NSArray arrayWithArray:ary];
    
    tvList = [[UITableView alloc] init];
    tvList.delegate = self;
    tvList.dataSource = self;
    tvList.backgroundColor = [UIColor colorWithRed:.97 green:.93 blue:.94 alpha:1];
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
    
    
    cell.title = [aryList objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return aryList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectLeftItemAtIndex:indexPath.row];
    
    if (2==indexPath.row)
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}



@end
