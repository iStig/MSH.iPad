//
//  IKGuideView.m
//  InsuranceKit
//
//  Created by Stan Wu on 14/12/15.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKGuideViewController.h"
#import "IKAppDelegate.h"

@implementation IKGuideViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    scvGuide = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    scvGuide.contentSize = CGSizeMake(1024*3, 768);
    scvGuide.pagingEnabled = YES;
    scvGuide.delegate = self;
    [self.view addSubview:scvGuide];
    scvGuide.showsHorizontalScrollIndicator = NO;
    NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.view.frame.size.width-60)/2, self.view.frame.size.width-40, 60, 20)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        pageControl.frame=CGRectMake((self.view.frame.size.width-60)/2, self.view.frame.size.height-40, 60, 20);
    }
//    pageControl.center =CGPointMake((self.view.frame.size.height-230)/2, (self.view.frame.size.width-20));
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [pageControl setHidden:NO];
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    
    for (int i=0;i<3;i++){
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(1024*i, 0, 1024, 768)];
        [imgv setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Guide%d.jpg",i]]];
        [scvGuide addSubview:imgv];
    }
    pageControl.numberOfPages =3;
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int offSetX = (int)scrollView.contentOffset.x;
    pageControl.currentPage = offSetX/1024;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.x+scrollView.frame.size.width>scrollView.contentSize.width){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GuideShown"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GuideRemoved" object:nil];
        
        
    }
}

@end
