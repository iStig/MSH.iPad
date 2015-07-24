//
//  IKClientsListViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-10.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKClientsListViewController.h"
#import "IKAddClientView.h"

@interface IKClientsListViewController ()

@end

@implementation IKClientsListViewController
@synthesize delegate;


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    UIView *vTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 278, 53)];
    vTop.backgroundColor = [UIColor colorWithRed:.97 green:.93 blue:.94 alpha:1];
    [self.view addSubview:vTop];
    
    UILabel *lbl = [UILabel createLabelWithFrame:CGRectZero font:[UIFont systemFontOfSize:24] textColor:[UIColor colorWithRed:1 green:.4 blue:0 alpha:1]];
    lbl.text = LocalizeStringFromKey(@"kPatient");
    [lbl sizeToFit];
    lbl.frame = CGRectMake(25, 0, 120, vTop.frame.size.height);
    [vTop addSubview:lbl];
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAdd setImage:[UIImage imageNamed:@"IKButtonAdd.png"] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(addUserClicked) forControlEvents:UIControlEventTouchUpInside];
    btnAdd.frame = CGRectMake(0, 0, 44, 44);
    btnAdd.center = CGPointMake(vTop.frame.size.width-28, vTop.frame.size.height/2);
    [vTop addSubview:btnAdd];
    
  

    tvList = [[UITableView alloc] init];
    tvList.delegate = self;
    tvList.dataSource = self;
    tvList.backgroundColor = [UIColor colorWithRed:.97 green:.93 blue:.94 alpha:1];
    [tvList registerClass:[IKClientsListCell class] forCellReuseIdentifier:@"ClientsListCellIdentifier"];
    tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tvList];
    
    UIView *vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 278, 47)];
    tvList.tableHeaderView = vHeader;//会调用tbdatasource delegate
    
    
    UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconSearch.png"]];
    imgv.center = CGPointMake(24, 23);
    [vHeader addSubview:imgv];
    
    UITextField *tfSearch = [[UITextField alloc] initWithFrame:CGRectMake(44, 0, 180, 47)];
    tfSearch.backgroundColor = [UIColor clearColor];
    tfSearch.font = [UIFont systemFontOfSize:15];
    tfSearch.returnKeyType = UIReturnKeySearch;
    tfSearch.placeholder = LocalizeStringFromKey(@"kSerch");
    tfSearch.delegate = self;
    [vHeader addSubview:tfSearch];
    
    vHeader.backgroundColor = [UIColor whiteColor];
    
    selectIndex =[NSIndexPath indexPathForRow:0 inSection:0];
    
    if ([self tableView:tvList numberOfRowsInSection:0] == 0)//当tablevew的section 不存在数据时候
        [self.delegate visitSelected:nil];
    else{//当存在数据的时候 默认选择数据库第一条
        selectedVisit = [[self fetchedResultsController] objectAtIndexPath:selectIndex];//获取选中的visit 将当前算中visit显示在界面上
        [self.delegate visitSelected:selectedVisit];
    }
    
    [tvList reloadData];
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visitAdded:) name:@"VisitAdded" object:nil];//当有新就诊用户的时候  选择当前用户
}


- (void)visitAdded:(NSNotification*)notice{
     IKVisitCDSO *v = [[notice userInfo] objectForKey:@"visit"];
     selectIndex =   [[self fetchedResultsController] indexPathForObject:v];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [tvList selectRowAtIndexPath:selectIndex animated:NO scrollPosition:UITableViewScrollPositionTop];
    
    selectedVisit = [[self fetchedResultsController] objectAtIndexPath:selectIndex];//获取选中的visit 将当前算中visit显示在界面上
    
    [self.delegate visitSelected:selectedVisit];
//    [tvList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [tvList reloadData];
    
}

-(void)reloadTbV:(NSIndexPath*)newIndexPath{

//如果第一时间用这个方法   会导致tvlist没有数据的情况下崩溃  可能数据没展示 cell没显示 但已经要选中
     [tvList selectRowAtIndexPath:newIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];


}

- (void)addUserClicked{
    [IKAddClientView show];
}



- (void)viewWillLayoutSubviews{
    tvList.frame = CGRectMake(0, 53, self.view.frame.size.width, self.view.frame.size.height-53);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ClientsListCellIdentifier";
    
    IKClientsListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    

    cell.visit = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    BOOL bselected = [cell.visit.visitID isEqualToString:selectedVisit.visitID];//当选中的
    [cell makeSelected:bselected];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];//获取当前section的row数目
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[[self fetchedResultsController] sections] count];//获取sections数目
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedVisit = [[self fetchedResultsController] objectAtIndexPath:indexPath];//获取选中的visit 将当前算中visit显示在界面上
    [self.delegate visitSelected:selectedVisit];
    
    [tvList reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideDutyView" object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Fetched results controller
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
//    fetchedResultsController = nil;
    
	if (fetchedResultsController == nil)
	{
        
        
        
		NSSortDescriptor *statusSD;//排序条件
		NSArray *sortDescriptors;
		NSFetchRequest *fetchRequest;
		
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Visit"
		                                          inManagedObjectContext:[IKDataProvider managedObjectContext]];
		
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyyMMdd"];
        [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        NSDate *date = [formatter dateFromString:[formatter stringFromDate:[[NSDate alloc] initWithTimeInterval:(-1*24*60*60) sinceDate:[NSDate date]]]];//只筛选创建时间1天内的数据
//      statusSD = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
        statusSD = [[NSSortDescriptor alloc] initWithKey:@"registrationTime" ascending:NO];//根据就诊时间降序排列
        NSPredicate *predicate = nil;//筛选条件
        if (keyword.length>0){
//            predicate = [NSPredicate predicateWithFormat:@"hospital=%@ and modifyTime!=nil and modifyTime>=%@ and (memberID contains[cd] %@ || memberName contains[cd] %@) and (invisible=nil or invisible=NO)",[IKDataProvider currentHospital],date,keyword,keyword];
            
            predicate = [NSPredicate predicateWithFormat:@"hospital=%@ and createTime!=nil and createTime>=%@ and (memberID contains[cd] %@ || memberName contains[cd] %@) and (invisible=nil or invisible=NO)",[IKDataProvider currentHospital],date,keyword,keyword];
   

        }
        else{
//            predicate = [NSPredicate predicateWithFormat:@"hospital=%@ and modifyTime!=nil and modifyTime>=%@ and (invisible=nil or invisible=NO)",[IKDataProvider currentHospital],date];
            
                     predicate = [NSPredicate predicateWithFormat:@"hospital=%@ and createTime!=nil and createTime>=%@ and (invisible=nil or invisible=NO)",[IKDataProvider currentHospital],date];
            

            
        }
		sortDescriptors = [[NSArray alloc] initWithObjects:statusSD, nil];
		
		fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setFetchBatchSize:20];
		[fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setPredicate:predicate];
	
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:[IKDataProvider managedObjectContext]
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
        fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error])
        {
			NSLog(@"%@: Error fetching messages: %@ %@", [self class], error, [error userInfo]);
        }
        
    }
    
	return fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (![self isViewLoaded]) return;//当前界面已经加载过了 则继续 没有则跳出 不刷新tvlist
	
	[tvList beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	if(![self isViewLoaded]) return;
	
	NSLog(@"%@: controllerDidChangeContent", [self class]);
    
    [tvList endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
	if (![self isViewLoaded]) return;
	
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tvList insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                           withRowAnimation:UITableViewRowAnimationFade];
            
            //如果用了这个 可以去掉 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visitAdded:) name:@"VisitAdded" object:nil];
        
            
            selectedVisit = [[self fetchedResultsController] objectAtIndexPath:newIndexPath];//获取选中的visit 将当前算中visit显示在界面上
            
            [self.delegate visitSelected:selectedVisit];

            [tvList reloadData];
            
            [self performSelector:@selector(reloadTbV:) withObject:newIndexPath afterDelay:1];
//            [tvList selectRowAtIndexPath:newIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            
			break;
			
        case NSFetchedResultsChangeDelete:
            [tvList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                           withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
			[tvList reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                           withRowAnimation:UITableViewRowAnimationNone];
			break;
			
        case NSFetchedResultsChangeMove:
            [tvList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                           withRowAnimation:UITableViewRowAnimationFade];
			
			[tvList insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                           withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    keyword = textField.text;
    
    fetchedResultsController = nil;
    
    [tvList reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return NO;
}

@end
