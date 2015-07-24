//
//  IKItemButton.m
//  InsuranceKit
//
//  Created by Stan Wu on 14/12/24.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKItemButton.h"

@implementation IKItemButton
@synthesize selected;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        float distance = 10;
        
        imgvStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconCircleCheckNO.png"]];
        imgvStatus.center = CGPointMake(imgvStatus.frame.size.width/2, frame.size.height/2);
        [self addSubview:imgvStatus];
        
        lblTitle = [UILabel createLabelWithFrame:CGRectMake(imgvStatus.frame.size.width+distance, 0, frame.size.width-imgvStatus.frame.size.width-distance, frame.size.height) font:[UIFont systemFontOfSize:[InternationalControl isEnglish]?14:17] textColor:[UIColor colorWithWhite:.54 alpha:1]];
        lblTitle.numberOfLines = 0;
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:lblTitle];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)btnClicked{
    [_target performSelector:_action withObject:self];
}

- (void)setTitle:(NSString *)text{
    lblTitle.text = text;
}

- (void)setSelected:(BOOL)bsel{
    selected = bsel;
    [imgvStatus setImage:[UIImage imageNamed:selected?@"IKIconCircleCheckYES.png":@"IKIconCircleCheckNO.png"]];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    _target = target;
    _action = action;
}

@end
