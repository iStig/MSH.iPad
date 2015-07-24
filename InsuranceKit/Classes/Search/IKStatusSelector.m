//
//  IKStatusSelector.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-3.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKStatusSelector.h"
#import "IKAppDelegate.h"

@implementation IKStatusSelector
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame point:(CGPoint)pt
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        
        imgvContent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKViewStatusSelector.png"]];
        imgvContent.userInteractionEnabled = YES;
        CGRect rect = imgvContent.frame;
        rect.origin.x = pt.x;
        rect.origin.y = pt.y;
        imgvContent.frame = rect;
        
        NSArray *titles = [[InternationalControl isEnglish]?@"All,Approved,Denied,Canceled,Audit,Need MR":@"全 部,批 准,拒 绝,取 消,审核中,需要医学资料" componentsSeparatedByString:@","];
        
        [self addSubview:imgvContent];
        int tags[] = {99,1,0,3,2,4};
        for (int i=0;i<6;i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 10+42*i, imgvContent.frame.size.width, 42);
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            btn.showsTouchWhenHighlighted = YES;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = tags[i];
            [imgvContent addSubview:btn];
        }
        
    }
    return self;
}

- (void)btnClicked:(UIButton *)btn{
    switch (btn.tag) {
        case IKApplyStatusAll:[self.delegate statusSelected:IKApplyStatusAll];break;
        case IKApplyStatusApproval:[self.delegate statusSelected:IKApplyStatusApproval];break;
        case IKApplyStatusReviewing:[self.delegate statusSelected:IKApplyStatusReviewing];break;
        case IKApplyStatusDeny:[self.delegate statusSelected:IKApplyStatusDeny];break;
        case IKApplyStatusNeedData:[self.delegate statusSelected:IKApplyStatusNeedData];break;
        case IKApplyStatusCancel:[self.delegate statusSelected:IKApplyStatusCancel];break;
        default:
            break;
    }
    
    [self dismiss];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(imgvContent.frame, pt)){
        [self dismiss];
    }
}

- (void)dismiss{
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (void)showAtPoint:(CGPoint)pt delegate:(id)dele{

    
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    IKStatusSelector *v = [[IKStatusSelector alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) point:pt];
    v.delegate = dele;
    
    
    
    v.alpha = 0;
    
    [w.rootViewController.view addSubview:v];
    [UIView animateWithDuration:.3f animations:^{
        v.alpha = 1;
    }];
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
