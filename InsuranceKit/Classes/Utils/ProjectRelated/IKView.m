//
//  IKView.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKView.h"

@implementation IKView
@synthesize visit;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showInfo{
    
}

- (void)setVisit:(IKVisitCDSO *)v{
    visit = v;
    [self showInfo];
}

- (IKVisitCDSO *)visit{
    return visit;
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
