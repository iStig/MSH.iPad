//
//  IKItemView.m
//  InsuranceKit
//
//  Created by iStig on 14-10-8.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKItemView.h"

@implementation IKItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame   showItemInfo:(NSString*)title  value:(NSString*)value   atIndex:(int)index{

    if (self = [super initWithFrame:frame]){
      NSArray *item_title = @[@"齿科",@"住院",@"门诊",@"眼科",@"体检"];//用于区别图片别改成中英文适配
    
        self.opaque = YES;
//        self.backgroundColor = [UIColor colorWithRed:247.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1];
        self.backgroundColor = [UIColor clearColor];
        item_bg = [UIButton buttonWithType:UIButtonTypeCustom];
        item_bg.frame = frame;
        [item_bg setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[item_title objectAtIndex:index]]] forState:UIControlStateNormal];
        [item_bg setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@g",[item_title objectAtIndex:index]]] forState:UIControlStateDisabled];
        [self addSubview:item_bg];
        
        item_type = [UILabel createLabelWithFrame:CGRectMake(0, 120 -40 -3, frame.size.width, 20) font:[UIFont systemFontOfSize:17]textColor:[UIColor whiteColor]];
        item_type.textAlignment = NSTextAlignmentCenter;
        item_type.text = title;
        [self addSubview:item_type];
        
        item_value = [UILabel createLabelWithFrame:CGRectMake(0, 120 -20 , frame.size.width, 20) font:[UIFont systemFontOfSize:17]textColor:[UIColor whiteColor]];
        item_value.textAlignment = NSTextAlignmentCenter;
        item_value.text = value;
        [self addSubview:item_value];
        
        

    }

    return self;

}

- (void)makeSelected:(BOOL)selected{
    item_bg.enabled = selected;
}


@end
