//
//  IKClientsListViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-10.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKClientsListCell.h"
#import <CoreData/CoreData.h>
#import "IKVisitCDSO.h"

@protocol IKClientsListDelegate

- (void)visitSelected:(IKVisitCDSO *)v;

@end

@interface IKClientsListViewController : IKViewController<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextFieldDelegate>{
    UITableView *tvList;
    
    NSMutableArray *aryList;
    NSFetchedResultsController *fetchedResultsController;
    NSString *keyword;
    NSIndexPath *selectedPath;
    IKVisitCDSO __weak *selectedVisit;
    
    NSIndexPath *selectIndex;
}
@property (nonatomic,weak) id<IKClientsListDelegate,IKViewControllerDelegate> delegate;

@end
