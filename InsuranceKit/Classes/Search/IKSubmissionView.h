//
//  IKIClaimSubmissionView.h
//  InsuranceKit
//
//  Created by 大明五阿哥 on 15/1/26.
//  Copyright (c) 2015年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IKSubmissionView;

@protocol IKSubmissionViewDelegate

- (void)submissionView:(IKSubmissionView *)submissionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath visitCDSO:(IKVisitCDSO *)visitCDSO;

@end
@interface IKSubmissionView : UIView{
   
     NSMutableArray *contentList;
}
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, strong)  NSMutableArray *claimListState;
@property (nonatomic, strong)   UITableView *noSubmissionTable;
@property (nonatomic,weak) id<IKSubmissionViewDelegate> delegate;
@property NSMutableArray *visitArr;
-(void)vistWithID:(IKVisitCDSO *)visit;

@property NSMutableArray *selectArray;
//-(void)setNoSubmissionTableFrame:(CGRect)noSubmissionTableFrame;
-(void)refreshList:(NSNotification *)notification;
@end
