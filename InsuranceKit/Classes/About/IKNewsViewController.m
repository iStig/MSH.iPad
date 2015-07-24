//
//  IKNewsViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKNewsViewController.h"
#import "IKNewsDetailViewController.h"
#import "IKDataProvider.h"
#import "IKNewsListCell.h"

@interface IKNewsViewController ()

@end

@implementation IKNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"kNews")];
    [self addBGColor:[UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1]];
    
    tvList = [[UITableView alloc] initWithFrame:CGRectZero];
    tvList.delegate = self;
    tvList.dataSource = self;
    tvList.backgroundColor = [UIColor clearColor];
    tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tvList];
    
    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kRefreshnews")];
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)loadData{
    @autoreleasepool {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *createtime = [formatter stringFromDate:[NSDate date]];
        
        NSDictionary *dict = [IKDataProvider getNews:[NSDictionary dictionaryWithObjectsAndKeys:createtime,@"synchrTime", nil]];
        
        NSString *key = [NSString stringWithFormat:@"NewsListCache-%@",[[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"]];
        
        sw_dispatch_sync_on_main_thread(^{
            [SVProgressHUD dismiss];
            aryList = [NSMutableArray arrayWithArray:[dict objectForKey:@"data"]];
            if (aryList.count==0){
                aryList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:aryList forKey:key];
            }
            
            [tvList reloadData];
        });
    }
}

- (void)loadMoreData{
    @autoreleasepool {
        if (aryList.count>0){
            NSDictionary *lastNews = [aryList lastObject];
            NSString *createtime = [lastNews objectForKey:@"createtime"];
            NSDictionary *dict = [IKDataProvider getNews:[NSDictionary dictionaryWithObjectsAndKeys:createtime,@"synchrTime", nil]];
            
            NSArray *ary = [dict objectForKey:@"data"];
            if (ary.count>0){
                [aryList addObjectsFromArray:ary];
                
                NSString *key = [NSString stringWithFormat:@"NewsListCache-%@",[[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"]];
                if (aryList.count>0)
                    [[NSUserDefaults standardUserDefaults] setObject:aryList forKey:key];
                
                sw_dispatch_sync_on_main_thread(^{
                    [tvList reloadData];
                });
            }
        }
        
        isLoadingMore = NO;
    }
}

- (void)needMore{
    if (isLoadingMore)
        return;
    isLoadingMore = YES;
    [NSThread detachNewThreadSelector:@selector(loadMoreData) toTarget:self withObject:nil];
}

- (void)newsClicked{
    IKNewsDetailViewController *vcNewsDetail = [[IKNewsDetailViewController alloc] init];
    vcNewsDetail.shouldShowNavigationBar = YES;
    [self.navigationController pushViewController:vcNewsDetail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews{
    tvList.frame = self.view.bounds;
}

#pragma mark - UITableView Data Source & Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"NewsCellIdentifier";
    
    IKNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[IKNewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.dicInfo = [aryList objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 191;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return aryList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IKNewsDetailViewController *vcNewsDetail = [[IKNewsDetailViewController alloc] init];
    vcNewsDetail.dicInfo = [aryList objectAtIndex:indexPath.row];
    vcNewsDetail.shouldShowNavigationBar = YES;
    [self.navigationController pushViewController:vcNewsDetail animated:YES];
    
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int lines = aryList.count;
    if (scrollView.contentOffset.y+scrollView.frame.size.height>lines*48 && aryList.count>0 && aryList.count%20==0)
        [self needMore];
}

@end
