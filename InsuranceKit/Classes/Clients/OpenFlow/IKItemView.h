//
//  IKItemView.h
//  InsuranceKit
//
//  Created by iStig on 14-10-8.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKItemView : UIView{

    UIButton *item_bg;
    UILabel *item_type;
    UILabel *item_value;
}

-(id)initWithFrame:(CGRect)frame   showItemInfo:(NSString*)title  value:(NSString*)value atIndex:(int)index;

- (void)makeSelected:(BOOL)selected;
@end
