//
//  BSTCover.h
//  BookSystem
//
//  Created by Wu Stan on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSTCoverViewDelegate

- (void)animateEnded:(id)view;

@end

@interface BSTCoverView : UIView{
    UIButton *btnSetting;
    UILabel *lblCaption,*lblAdText,*lblSource;
    UIImageView *imgvCover,*imgvCoverNext;
    
    
    NSArray *aryCover;
    int coverIndex;
}
@property (nonatomic,retain) NSArray *aryCover;
@property (nonatomic,weak) id<BSTCoverViewDelegate> delegate;

- (void)animateCover;
- (id)initWithFrame:(CGRect)frame info:(NSDictionary *)info;

@end
