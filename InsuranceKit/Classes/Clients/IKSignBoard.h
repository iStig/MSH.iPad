//
//  IKSignBoard.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-2-28.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface IKSignBoard : CALayer{
    NSMutableArray *aryPaths;
}

- (void)addPoint:(CGPoint)pt;
- (void)nextLine;
- (BOOL)isBlank;
- (UIImage *)signImage;

@end
