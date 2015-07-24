//
//  IKSignNameView.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-13.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKSignNameView.h"


@implementation IKSignNameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10;
        vSignArea = [[UIView alloc] initWithFrame:CGRectMake(2, 0, frame.size.width-4, 380)];
        vSignArea.backgroundColor = [UIColor colorWithRed:1 green:.97 blue:.98 alpha:1];
//        vSignArea.layer.cornerRadius = 8;
//        vSignArea.clipsToBounds = YES;
//        vSignArea.bounds = CGRectMake(0, 0, frame.size.width-4, 370);
        [self addSubview:vSignArea];
        
        signBoard = [[IKSignBoard alloc] init];
        signBoard.frame = vSignArea.bounds;
        [vSignArea.layer addSublayer:signBoard];
        
        
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(30, 22, 200, 23) font:[UIFont boldSystemFontOfSize:22] textColor:[UIColor colorWithWhite:.44 alpha:1]];
        [vSignArea addSubview:lbl];
        lbl.text = @"请在此签名";
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
- (void)showNextClicked{
    if (signBoard.isBlank){
        [self.delegate signAdded:nil];
    }else{
        [self.delegate signAdded:[signBoard signImage]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [signBoard nextLine];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint pt = [touch locationInView:vSignArea];
    
    [signBoard addPoint:pt];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    CGPoint pt = [touch locationInView:vSignArea];
    
    [signBoard addPoint:pt];
}

@end
