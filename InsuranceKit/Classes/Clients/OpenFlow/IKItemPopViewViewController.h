//
//  IKItemPopViewViewController.h
//  InsuranceKit
//
//  Created by iStig on 14-10-8.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IKItemPopSelect <NSObject>

-(void)itemSelectAtIndex:(int)index;

@end

@interface IKItemPopViewViewController : UIViewController
{
  

}
@property (nonatomic,strong) UILabel *base_value;
@property (nonatomic,strong) UILabel *significant_value;
@property (nonatomic,strong) UILabel *prevent_value;
@property (nonatomic,strong) UILabel *correctional_value;
@property (nonatomic,strong) NSArray *title_Values;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic, weak) id<IKItemPopSelect> delegate;
@end
