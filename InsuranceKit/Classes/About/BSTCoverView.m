//
//  BSTCover.m
//  BookSystem
//
//  Created by Wu Stan on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BSTCoverView.h"

@implementation BSTCoverView
@synthesize aryCover,delegate;

- (void)dealloc{
    self.aryCover = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateCover) object:nil];
}

- (id)initWithFrame:(CGRect)frame info:(NSDictionary *)info
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        coverIndex = 0;
        
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[@"wallpaper.bundle" bundlePath] error:nil];
        
        
        // Initialization code
        self.aryCover = contents;
        if (!aryCover || 0==[aryCover count])
            self.aryCover = [NSArray arrayWithObject:@"cover.jpg"];
        
        
        UIImage *imgCover = [UIImage imageNamed:[@"wallpaper.bundle" stringByAppendingPathComponent:[aryCover objectAtIndex:0]]];
        
        imgvCover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [imgvCover setImage:imgCover];
        [self addSubview:imgvCover];

        
        imgvCoverNext = [[UIImageView alloc] initWithFrame:imgvCover.frame];
        [self addSubview:imgvCoverNext];
        imgvCoverNext.hidden = YES;
        
        
        
        
        
        
        
        [self animateCover];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)animateCover{
    if (imgvCover.isAnimating || imgvCoverNext.isAnimating){
        @autoreleasepool {
            NSLog(@"My Superview:%@",self.superview);
            
            [self performSelector:@selector(animateCover) withObject:nil afterDelay:7];
            return;
        }
        
    }
    
    else { 
        @autoreleasepool {
            coverIndex++;
            if (coverIndex>=[aryCover count])
                coverIndex = 0;
            

            NSString *name = [aryCover objectAtIndex:coverIndex];// objectForKey:@"cover"];
            NSLog(@"Image Name:%@",name);
 
            if (imgvCover.hidden){
                [imgvCover setImage:[UIImage imageNamed:[@"wallpaper.bundle" stringByAppendingPathComponent:name]]];
                [self insertSubview:imgvCover belowSubview:imgvCoverNext];
                imgvCover.alpha = 1;
                imgvCover.hidden = NO;
                //            imgvCover.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:3.0f delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                    //                imgvCover.alpha = 1;
                    imgvCoverNext.alpha = 0;
                }completion:^(BOOL finished) {
                    imgvCoverNext.hidden = YES;
                    
                    [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                        CGAffineTransform rotate = CGAffineTransformMakeRotation(0.00);
                        CGAffineTransform moveLeft = CGAffineTransformMakeTranslation(coverIndex%2==0?0.9:1.1,coverIndex%2==0?0.9:1.1);
                        CGAffineTransform combo1 = CGAffineTransformConcat(rotate, moveLeft);
                        
                        CGAffineTransform zoomOut = CGAffineTransformMakeScale(1.1,1.1);
                        CGAffineTransform transform = CGAffineTransformConcat(zoomOut, combo1);
                        imgvCover.transform =  CGAffineTransformIsIdentity(imgvCover.transform)?transform:CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        if ([self isKindOfClass:[BSTCoverView class]])
                            [self performSelector:@selector(animateCover) withObject:nil afterDelay:1];
                    }];
                }];
            }else{
                [imgvCoverNext setImage:[UIImage imageNamed:[@"wallpaper.bundle" stringByAppendingPathComponent:name]]];
                imgvCoverNext.alpha = 1;
                [self insertSubview:imgvCoverNext belowSubview:imgvCover];
                imgvCoverNext.hidden = NO;
                //            imgvCoverNext.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:3.0f delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                    //                imgvCoverNext.alpha = 1;
                    imgvCover.alpha = 0;
                }completion:^(BOOL finished) {
                    imgvCover.hidden = YES;
                    
                    [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                        CGAffineTransform rotate = CGAffineTransformMakeRotation(0.00);
                        CGAffineTransform moveLeft = CGAffineTransformMakeTranslation(coverIndex%2==0?0.9:1.1,coverIndex%2==0?0.9:1.1);
                        CGAffineTransform combo1 = CGAffineTransformConcat(rotate, moveLeft);
                        
                        CGAffineTransform zoomOut = CGAffineTransformMakeScale(1.1,1.1);
                        CGAffineTransform transform = CGAffineTransformConcat(zoomOut, combo1);
                        imgvCoverNext.transform = CGAffineTransformIsIdentity(imgvCoverNext.transform)?transform:CGAffineTransformIdentity;
                    } completion:^(BOOL finished) {
                        if ([self isKindOfClass:[BSTCoverView class]])
                            [self performSelector:@selector(animateCover) withObject:nil afterDelay:1];
                    }];
                }];
        }
        
        }
        
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.delegate animateEnded:self];
}



@end
