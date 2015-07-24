//
//  UIViewController+UIViewController_NavButton.m
//  AiBa
//
//  Created by Wu Stan on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+NavButton.h"
#import <CoreImage/CoreImage.h>

@implementation UIViewController (NavButton)

- (void)navBack{
    [self.navigationController popViewControllerAnimated:YES];
    
    [SVProgressHUD dismiss];
}

- (void)clearNavBack{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *fixspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    self.navigationItem.leftBarButtonItems = @[fixspace,item];
}

- (void)addNavBack{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 64, 32);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    btn.backgroundColor = [UIColor colorWithRed:.96 green:.5 blue:.13 alpha:1];
    btn.layer.cornerRadius = 4;
    
    UIBarButtonItem *fixspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    fixspace.width = -15;
    
    //    btn.layer.borderWidth = 1;
    //    btn.layer.borderColor = [UIColor colorWithWhite:.24 alpha:1].CGColor;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *img = [btn imageContent];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems = @[fixspace,item];
    
}

- (void)addNavBackWithTitle:(NSString *)title{
    UIImage *img = [UIImage imageNamed:@"ABNavBack.png"];
    
    [self addNavButtonWithTitle:title image:img atPosition:SWNavItemPositionLeft action:@selector(navBack) isHighlight:NO];
}

- (void)addNavBackWithTitle:(NSString *)title hasLine:(BOOL)hasline{
    UIImage *img = [UIImage imageNamed:@"ABNavBack.png"];
    
    [self addNavButtonWithTitle:title image:img atPosition:SWNavItemPositionLeft action:@selector(navBack) isHighlight:NO isClear:NO hasLine:hasline];
}

- (void)addClearNavBackWithTitle:(NSString *)title{
    UIImage *img = [UIImage imageNamed:@"ABNavBack.png"];
    
    [self addNavButtonWithTitle:title image:img atPosition:SWNavItemPositionLeft action:@selector(navBack) isHighlight:NO isClear:YES];
}

- (void)addClearNavBackWithTitle:(NSString *)title hasLine:(BOOL)hasline{
    UIImage *img = [UIImage imageNamed:@"ABNavBack.png"];
    
    [self addNavButtonWithTitle:title image:img atPosition:SWNavItemPositionLeft action:@selector(navBack) isHighlight:NO isClear:YES hasLine:NO];
}

- (void)addNavButtonWithTitle:(NSString *)title image:(UIImage *)img atPosition:(SWNavItemPosition)position action:(SEL)sel{
    [self addNavButtonWithTitle:title image:img atPosition:position action:sel isHighlight:NO];
}

- (void)addNavButtonWithImage:(UIImage *)img atPosition:(SWNavItemPosition)position action:(SEL)sel{
    [self addNavButtonWithTitle:nil image:img atPosition:position action:sel isHighlight:NO];
}

- (void)addClearNavButtonWithImage:(UIImage *)img atPosition:(SWNavItemPosition)position action:(SEL)sel{
    [self addNavButtonWithTitle:nil image:img atPosition:position action:sel isHighlight:NO isClear:YES];
}

- (void)addClearNavButtonWithImage:(UIImage *)img atPosition:(SWNavItemPosition)position action:(SEL)sel hasLine:(BOOL)hasline{
    [self addNavButtonWithTitle:nil image:img atPosition:position action:sel isHighlight:NO isClear:YES hasLine:hasline];
}

- (void)addRefreshToPosition:(SWNavItemPosition)position{
    [self addNavButtonWithTitle:nil image:[UIImage imageNamed:@"ABNavRefresh.png"] atPosition:position action:@selector(refresh) isHighlight:NO];
}

- (void)addNavButtonWithSTitle:(NSString *)title atPosition:(SWNavItemPosition)position action:(SEL)sel{
    [self addNavButtonWithTitle:title image:nil atPosition:position action:sel isHighlight:YES];
}

- (void)addNavButtonWithTitle:(NSString *)title atPosition:(SWNavItemPosition)position action:(SEL)sel{
    [self addNavButtonWithTitle:title image:nil atPosition:position action:sel isHighlight:NO];
    

}

- (void)addNavButtonWithTitle:(NSString *)title titleImage:(UIImage *)timg atPosition:(SWNavItemPosition)position action:(SEL)sel{
    [self addNavButtonWithTitle:title image:timg atPosition:position action:sel isHighlight:NO];
}

- (void)addNavButtonWithTitle:(NSString *)title image:(UIImage *)img atPosition:(SWNavItemPosition)position action:(SEL)sel isHighlight:(BOOL)highlight{
    [self addNavButtonWithTitle:title image:img atPosition:position action:sel isHighlight:highlight isClear:NO];
}

- (void)addNavButtonWithTitle:(NSString *)title image:(UIImage *)img atPosition:(SWNavItemPosition)position action:(SEL)sel isHighlight:(BOOL)highlight isClear:(BOOL)isclear{
    [self addNavButtonWithTitle:title image:img atPosition:position action:sel isHighlight:highlight isClear:isclear hasLine:YES];
}

- (void)addNavButtonWithTitle:(NSString *)title image:(UIImage *)img atPosition:(SWNavItemPosition)position action:(SEL)sel isHighlight:(BOOL)highlight isClear:(BOOL)isclear hasLine:(BOOL)hasline{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 44);
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:img forState:UIControlStateNormal];
    
    if (img && title)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -4);
    
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btn sizeToFit];
    
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    

    


    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *fixspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixspace.width = [UIDevice currentDevice].systemVersion.floatValue>=7.0f?-20:-10;
    
    if (SWNavItemPositionLeft==position)
        self.navigationItem.leftBarButtonItems = @[fixspace,item];
    else
        self.navigationItem.rightBarButtonItems = @[fixspace,item];
}

- (void)addBGColor:(UIColor *)color{
    if (!color)
        color = [UIColor colorWithRed:.97 green:.93 blue:.94 alpha:1];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"ABMorePatternBG.png"]];
    self.view.backgroundColor = color;
}

- (void)setNavTitle:(NSString *)str{
    UILabel *lbl = [UILabel createLabelWithFrame:CGRectZero font:[UIFont boldSystemFontOfSize:20] textColor:[UIColor whiteColor]];
    lbl.text = str;
    [lbl sizeToFit];
    self.navigationItem.titleView = lbl;
}

- (void)showFrameLog{
    NSLog(@"%@'s Frame:%@",NSStringFromClass([self class]),NSStringFromCGRect(self.view.frame));
}

@end



#pragma mark -  UIViewController Load More Extensions
@implementation UIViewController(LoadMore)

- (UIView *)footerViewForLoadMore{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = self.view.backgroundColor;
    [btn setTitleColor:[UIColor colorWithWhite:157/255.0f alpha:1] forState:UIControlStateNormal];
    btn.frame = v.bounds;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"点击查找更多" forState:UIControlStateNormal];
    [v addSubview:btn];
    [btn addTarget:self action:@selector(moreClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 100;
    
    UILabel *lbl = [UILabel createLabelWithFrame:v.bounds font:[UIFont systemFontOfSize:15] textColor:[btn titleColorForState:UIControlStateNormal]];
    lbl.textAlignment = UITextAlignmentCenter;
    [v insertSubview:lbl belowSubview:btn];
    lbl.text = @"正在载入";
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(160+[lbl.text sizeWithFont:lbl.font].width/2+10, lbl.center.y);
    [v insertSubview:indicator belowSubview:btn];
    indicator.tag = 101;
    
    return v;
}

- (void)moreClicked:(UIButton *)btn{
    btn.hidden = YES;
    
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[btn.superview viewWithTag:101];
    [indicator startAnimating];
    
    [NSThread detachNewThreadSelector:@selector(loadMoreData) toTarget:self withObject:nil];
}

@end

@implementation UIBarButtonItem(NavButton)

+ (id)navButtonWithTitle:(NSString *)title position:(SWNavItemPosition)position target:(id)target action:(SEL)sel{
    return [UIBarButtonItem navButtonWithTitle:title position:position target:target image:nil action:sel isHighlight:NO isClear:NO hasLine:YES];
}

+ (id)navButtonWithTitle:(NSString *)title position:(SWNavItemPosition)position target:(id)target image:(UIImage *)img action:(SEL)sel isHighlight:(BOOL)highlight isClear:(BOOL)isclear hasLine:(BOOL)hasline;
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 44);
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:img forState:UIControlStateNormal];
    
    if (img && title)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -4);
    
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    if (!isclear){
        CIImage *cimgsel = [CIImage imageWithColor:highlight?[CIColor colorWithRed:0xbd/255.0f green:0x75/255.0f blue:0x21/255.0f alpha:1]:[CIColor colorWithRed:0xc7/255.0f green:0x2b/255.0f blue:0x36/255.0f alpha:1]];
        CIImage *cimg = [CIImage imageWithColor:highlight?[CIColor colorWithRed:.96 green:.63 blue:.23 alpha:1]:[CIColor colorWithRed:.96 green:.23 blue:.28 alpha:1]];
        
        CGImageRef cgimg = [[CIContext contextWithOptions:nil] createCGImage:cimg fromRect:btn.bounds];
        CGImageRef cgimgsel = [[CIContext contextWithOptions:nil] createCGImage:cimgsel fromRect:btn.bounds];
        
        UIImage *imgbg = [UIImage imageWithCGImage:cgimg];
        UIImage *imgbgsel = [UIImage imageWithCGImage:cgimgsel];
        
        CGImageRelease(cgimg);
        CGImageRelease(cgimgsel);
        
        [btn setBackgroundImage:imgbg forState:UIControlStateNormal];
        [btn setBackgroundImage:imgbgsel forState:UIControlStateHighlighted];
    }
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1.5f, btn.frame.size.height)];
    [btn addSubview:line];
    
    UIImageView *line0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, .5f, line.frame.size.height)];
    line0.backgroundColor = [UIColor colorWithRed:0xff/255.0f green:0x57/255.0f blue:0x63/255.0f alpha:1];
    [line addSubview:line0];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(.5f, 0, 1, line.frame.size.height)];
    line1.backgroundColor = [UIColor colorWithRed:0xb8/255.0f green:0x27/255.0f blue:0x31/255.0f alpha:1];
    [line addSubview:line1];
    
    if (!hasline){
        line.hidden = YES;
    }
    //  ff5763    b82731
    if (SWNavItemPositionLeft==position){
        line.frame = CGRectMake(btn.frame.size.width-line.frame.size.width, 0, line.frame.size.width, line.frame.size.height);
        CGRect frame = line0.frame;
        frame.origin.x = 1;
        line0.frame = frame;
        
        frame = line1.frame;
        frame.origin.x = 0;
        line1.frame = frame;
    }else{
        line.frame = CGRectMake(0, 0, line.frame.size.width, line.frame.size.height);
        CGRect frame = line0.frame;
        frame.origin.x = 0;
        line0.frame = frame;
        
        frame = line1.frame;
        frame.origin.x = .5f;
        line1.frame = frame;
    }
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *fixspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixspace.width = [UIDevice currentDevice].systemVersion.floatValue>=7.0f?-20:-10;
    
    
    return @[fixspace,item];
}

@end
