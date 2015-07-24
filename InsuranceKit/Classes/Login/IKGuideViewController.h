//
//  IKGuideViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 14/12/15.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKGuideViewController : UIViewController<UIScrollViewDelegate>{
    UIScrollView *scvGuide;
    UIPageControl *pageControl;
}

@end
