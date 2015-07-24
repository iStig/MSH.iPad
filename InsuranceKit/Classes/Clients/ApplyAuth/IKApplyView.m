//
//  IKApplyView.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyView.h"

@implementation IKApplyView
@synthesize categoryID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1];
    }
    return self;
}

+ (id)applyView{
    return [[IKApplyView alloc] init];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (NSDictionary *)authInfo{
    return nil;
}

- (void)showInfo:(NSDictionary *)info{
    for (IKInputView *iv in self.subviews){
        if ([iv isKindOfClass:[IKInputView class]]){
            iv.text = [info objectForKey:iv.key];
        }
    }
}

- (void)updateNecessaryStatus{
    for (IKInputView *iv in self.subviews){
        if ([iv isKindOfClass:[IKInputView class]]){
            [iv determineNecessary:self.categoryID];
        }
    }
}

@end
