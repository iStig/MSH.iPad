//
//  IKScreenSaver.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-22.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKScreenSaver.h"
#import "IKAppDelegate.h"

#define maxIdleTime 500*60

@implementation IKScreenSaver

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    
    // Only want to reset the timer on a Began touch or an Ended touch, to reduce the number of timer resets.
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        // allTouches count only ever seems to be 1, so anyObject works here.
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded)
            [self resetIdleTimer];
    }
}

- (void)resetIdleTimer {
    if (idleTimer) {
        [idleTimer invalidate];
        idleTimer = nil;
    }
    
    idleTimer = [NSTimer scheduledTimerWithTimeInterval:maxIdleTime target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
}

- (void)idleTimerExceeded {
    NSLog(@"idle time exceeded");
    
    if (!vCover){
        UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
        UIViewController *vc = w.rootViewController;
        NSMutableArray *ary = [NSMutableArray array];
//        for (int i=0;i<4;i++)
//            [ary addObject:[NSString stringWithFormat:@"cover%d.png",i+1]];
        [ary addObject:@"Cover1.png"];
        [ary addObject:@"Cover2.png"];
        vCover = [[BSTCoverView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) info:@{@"images":ary}];
        vCover.delegate = self;
        [vc.view addSubview:vCover];
    }
    
}

#pragma mark - BSTCoverView Delegate
- (void)animateEnded:(id)view{
    [view removeFromSuperview];
    view = nil;
    [vCover removeFromSuperview];
    vCover = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutAccount" object:nil];
}

@end
