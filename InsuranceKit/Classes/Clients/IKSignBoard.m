//
//  IKSignBoard.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-2-28.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKSignBoard.h"

@implementation IKSignBoard

- (void)drawInContext:(CGContextRef)ctx{
    CGContextSetLineWidth(ctx, 2);
    
    
    for (int i=0;i<aryPaths.count;i++){
        CGMutablePathRef path = CGPathCreateMutable();
        NSArray *points = [aryPaths objectAtIndex:i];
        
        for (int i=0;i<points.count;i++){
            CGPoint pt = [[points objectAtIndex:i] CGPointValue];
            
            if (0==i)
                CGPathMoveToPoint(path, NULL, pt.x, pt.y);
            else
                CGPathAddLineToPoint(path, NULL, pt.x, pt.y);
        }
//        CGPathCloseSubpath(path);
        CGContextAddPath(ctx, path);
        CGContextStrokePath(ctx);
        CGPathRelease(path);
        
    }
    
    
}

- (void)addPoint:(CGPoint)pt{
    if (!aryPaths)
        aryPaths = [NSMutableArray array];
    
    if (aryPaths.count==0){
        [aryPaths addObject:[NSMutableArray array]];
    }
    
    [[aryPaths lastObject] addObject:[NSValue valueWithCGPoint:pt]];
    
    [self setNeedsDisplay];
}

- (void)nextLine{
    if (!aryPaths)
        aryPaths = [NSMutableArray array];
    [aryPaths addObject:[NSMutableArray array]];
}

- (BOOL)isBlank{
    int total = 0;
    for (int i=0;i<aryPaths.count;i++){
        NSArray *ary = [aryPaths objectAtIndex:i];
        total += ary.count;
    }
    return total==0;
}

- (UIImage *)signImage{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    [self drawInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
