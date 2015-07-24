//
//  IKViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-10.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"

@interface IKViewController ()

@end

@implementation IKViewController
@synthesize shouldShowNavigationBar,visit,delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
