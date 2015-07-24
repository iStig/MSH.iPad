//
//  IKClientsAuthorizationView.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKClientsAuthorizationView.h"
#import "IKClientsAuthCell.h"
#import "IKApplyAuthViewController.h"

@implementation IKClientsAuthorizationView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:.98 green:.97 blue:.98 alpha:1];
        
        tvList = [[UITableView alloc] initWithFrame:self.bounds];
        tvList.delegate = self;
        tvList.dataSource = self;
        tvList.backgroundColor = [UIColor clearColor];
        tvList.backgroundView = [[UIView alloc] init];
        tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
        tvList.showsVerticalScrollIndicator = NO;
        [self addSubview:tvList];
        
        rcList = [[UIRefreshControl alloc] init];
//        rcList.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        [rcList addTarget:self action:@selector(refreshChanged:) forControlEvents:UIControlEventValueChanged];
        [tvList addSubview:rcList];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshApplyList) name:@"RefreshApplyList" object:nil];
    }
    return self;
}

- (void)refreshChanged:(UIRefreshControl *)rc{
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)refreshApplyList{
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}


- (void)showInfo{
    [rcList beginRefreshing];
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)loadData{
    @autoreleasepool {
        NSString *providerID = self.visit.providerID;
        NSString *memberID = self.visit.memberID;
        NSString *depID = self.visit.depID;
        
        NSDictionary *dict = [IKDataProvider getAuthList:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type",providerID,@"providerID",memberID,@"memberID",depID,@"depID", nil]];
        
        NSLog(@"Auth List:%@",dict);
        aryList = [NSMutableArray arrayWithArray:[dict objectForKey:@"data"]];
        
        sw_dispatch_sync_on_main_thread(^{
            
            
            [rcList endRefreshing];
            [tvList reloadData];
        });
    }
}



- (void)applyAuthorization{
    if ([IKDataProvider canEditApply])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyAuthorization" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.visit,@"visit", nil]];
    else
        [UIAlertView showAlertWithTitle:nil message:@"您没有权限进行此项操作" cancelButton:nil];
}

#pragma mark - UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier0 = @"ApplyAuthorization";
    static NSString *identifier1 = @"AuthorizationList";
    
    NSString *identifier = indexPath.row==0?identifier0:identifier1;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        if (0==indexPath.row){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundView = [[UIView alloc] init];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 55, 55);
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = btn.frame.size.width/2;
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:.52 blue:.55 alpha:1] size:btn.frame.size] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"IKButtonAddWhite.png"] forState:UIControlStateNormal];
            btn.center = CGPointMake(tableView.frame.size.width/2, 55/2);
            [cell.contentView addSubview:btn];
            [btn addTarget:self action:@selector(applyAuthorization) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            cell = [[IKClientsAuthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

    }
    
    if (indexPath.row>0){
        ((IKClientsAuthCell *)cell).dicInfo = [aryList objectAtIndex:indexPath.row-1];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return aryList.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row==0?55:94;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tvList.frame.size.width, 22)];

    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row>0){
        NSString *caseId = [[aryList objectAtIndex:indexPath.row-1] objectForKey:@"caseId"];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyAuthorization" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:caseId,@"caseId", nil]];
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
