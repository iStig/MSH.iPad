//
//  IKItemButton.h
//  InsuranceKit
//
//  Created by Stan Wu on 14/12/24.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKItemButton : UIView{
    UIImageView *imgvStatus;
    UILabel *lblTitle;
    
    BOOL selected;
    id __weak _target;
    SEL _action;
}
@property (nonatomic,assign) BOOL selected;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)setTitle:(NSString *)text;

@end
