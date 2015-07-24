//
//  IKClaimsStateSelector.m
//  InsuranceKit
//
//  Created by iStig on 14-10-9.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKClaimsStateSelector.h"
#import "IKAppDelegate.h"
@implementation IKClaimsStateSelector
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame point:(CGPoint)pt states:(NSArray*)statesList
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
        
        [self addSubview:imgvContent];
     
        for (int i=0;i<[statesList count];i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 10+41*i, frame.size.width, 41);
            btn.showsTouchWhenHighlighted = YES;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [imgvContent addSubview:btn];
        }
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame point:(CGPoint)pt claimStates:(NSArray*)statesList{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        
        imgvContent = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1] size:CGSizeMake([InternationalControl isEnglish]?300:170, 42*(statesList.count))]];
        imgvContent.userInteractionEnabled = YES;
        CGRect rect = imgvContent.frame;
        rect.origin.x = pt.x;
        rect.origin.y = pt.y;
        imgvContent.frame = rect;
        
        [self addSubview:imgvContent];
        
        for (int i=0;i<[statesList count];i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 10+41*i, frame.size.width, 41);
            btn.showsTouchWhenHighlighted = YES;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [imgvContent addSubview:btn];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 42*i, imgvContent.frame.size.width, 42)];
            lbl.text = [[statesList objectAtIndex:i] objectForKey:[InternationalControl isEnglish]?@"ename":@"cname"];
            lbl.textColor = [UIColor whiteColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.backgroundColor = [UIColor clearColor];
            lbl.font = [UIFont systemFontOfSize:17];
            [imgvContent addSubview:lbl];
        }
        
    }
    return self;



}


- (void)btnClicked:(UIButton *)btn{

    [self.delegate statusSelected:btn.tag];
    
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


+ (void)showAtPoint:(CGPoint)pt  states:(NSArray*)statesList  delegate:(id<IKClaimsStatusSelectorDelegate>)dele{


    
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    IKClaimsStateSelector *v = [[IKClaimsStateSelector alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) point:pt claimStates:statesList];
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
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
