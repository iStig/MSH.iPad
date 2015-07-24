//
//  IKPopCenterView.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-13.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKPopCenterView.h"

@implementation IKPopCenterView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame //宽：737 高：475
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKBGAddUser.png"]];
        [self addSubview:imgv];
        self.frame = imgv.bounds;
        NSLog(@"IKPopCenterView : Rect == %@",NSStringFromCGRect(self.frame));
        
        btnPrev = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPrev setBackgroundImage:[UIImage imageNamed:@"IKButtonGray.png"] forState:UIControlStateNormal];
        [btnPrev sizeToFit];
        [btnPrev setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnPrev setTitle:LocalizeStringFromKey(@"kBack") forState:UIControlStateNormal];
        btnPrev.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        btnPrev.center = CGPointMake(95, 425);
        [self addSubview:btnPrev];
        [btnPrev addTarget:self action:@selector(showPrevClicked) forControlEvents:UIControlEventTouchUpInside];
        
        btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnNext setBackgroundImage:[UIImage imageNamed:@"IKButtonYellow.png"] forState:UIControlStateNormal];
        [btnNext sizeToFit];
        [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnNext setTitle:LocalizeStringFromKey(@"kNext") forState:UIControlStateNormal];
        btnNext.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        btnNext.center = CGPointMake(642, 425);
        [self addSubview:btnNext];
        [btnNext addTarget:self action:@selector(showNextClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    btnPrev.hidden = ![self.delegate canShowPrev:self];// 当前v 未设置tag或者tag ＝ 0，1 则隐藏“上一步”按钮。 其他则显示“上一步”
    [btnNext setTitle:[self.delegate canShowNext:self]?LocalizeStringFromKey(@"kNext"):LocalizeStringFromKey(@"kDone") forState:UIControlStateNormal];
    //当前v 未设置tag或者tag ＝ 0，1 则显示为“下一步”按钮。 其他则显示“完成”

}

- (void)showPrevClicked{
    if ([self.delegate canShowPrev:self])
        [self.delegate showPrev:self];
}

- (void)showNextClicked{
    if ([self.delegate canShowNext:self])
        [self.delegate showNext:self];
    else{
        if ([(NSObject *)self.delegate respondsToSelector:@selector(finished)])
            [self.delegate finished];
    }
    
}

+ (id)view{
    return [[[self class] alloc] initWithFrame:CGRectMake(0, 0, 737, 475)];
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
