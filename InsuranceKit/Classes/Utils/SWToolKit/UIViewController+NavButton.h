//
//  UIViewController+UIViewController_NavButton.h
//  AiBa
//
//  Created by Wu Stan on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SWNavItemPositionLeft,
    SWNavItemPositionRight
}SWNavItemPosition;

@interface UIViewController (NavButton)
- (void)navBack;
- (void)clearNavBack;
- (void)addNavBack;
- (void)addNavBackWithTitle:(NSString *)title;
- (void)addNavBackWithTitle:(NSString *)title hasLine:(BOOL)hasline;
- (void)addClearNavBackWithTitle:(NSString *)title;
- (void)addClearNavBackWithTitle:(NSString *)title hasLine:(BOOL)hasline;
- (void)addRefreshToPosition:(SWNavItemPosition)position;
- (void)addNavButtonWithSTitle:(NSString *)title atPosition:(SWNavItemPosition)position action:(SEL)sel;
- (void)addNavButtonWithTitle:(NSString *)title image:(UIImage *)img atPosition:(SWNavItemPosition)position action:(SEL)sel;
- (void)addNavButtonWithTitle:(NSString *)title atPosition:(SWNavItemPosition)position action:(SEL)sel;
- (void)addNavButtonWithTitle:(NSString *)title titleImage:(UIImage *)timg atPosition:(SWNavItemPosition)position action:(SEL)sel;
- (void)addNavButtonWithImage:(UIImage *)img atPosition:(SWNavItemPosition)position action:(SEL)sel;
- (void)addClearNavButtonWithImage:(UIImage *)img atPosition:(SWNavItemPosition)position action:(SEL)sel;
- (void)addBGColor:(UIColor *)color;
- (void)setNavTitle:(NSString *)str;
- (void)showFrameLog;

- (void)addClearNavButtonWithImage:(UIImage *)img atPosition:(SWNavItemPosition)position action:(SEL)sel hasLine:(BOOL)hasline;
@end

@interface UIViewController(LoadMore)

- (void)moreClicked:(UIButton *)btn;
- (UIView *)footerViewForLoadMore;

@end

@interface UIBarButtonItem(NavButton)

+ (id)navButtonWithTitle:(NSString *)title position:(SWNavItemPosition)position target:(id)target action:(SEL)sel;
+ (id)navButtonWithTitle:(NSString *)title position:(SWNavItemPosition)position target:(id)target image:(UIImage *)img action:(SEL)sel isHighlight:(BOOL)highlight isClear:(BOOL)isclear hasLine:(BOOL)hasline;

@end