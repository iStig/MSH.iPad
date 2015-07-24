//
//  IKImagePickerViewController.m
//  InsuranceKit
//
//  Created by K.E. on 15/4/9.
//  Copyright (c) 2015年 Stan Wu. All rights reserved.
//

#import "IKImagePickerViewController.h"

@interface IKImagePickerViewController ()

@end

@implementation IKImagePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self changeLands];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self change];
}
-(void)changeLands{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >=8)
    {
        
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
        }
        else
        {
            [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        }
    }
}
-(void)change{
    if ([[UIDevice currentDevice].systemVersion floatValue] >=8)
    {
        if([[UIDevice currentDevice]orientation] == UIDeviceOrientationFaceUp)
        {
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
        }
        else
        {
            [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        }
        }
    }

}
- (BOOL)shouldAutorotate
{
    [super shouldAutorotate];
    return self.chageDirection;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
