//
//  IKViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-10.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIViewController+NavButton.h"
#import "IKVisitCDSO.h"
typedef NS_ENUM(NSInteger, IKEvaluate_Level){
    
    IKEvaluate_Excellent = 100,
    IKEvaluate_Fine,
    IKEvaluate_Common,
    IKEvaluate_Bad,
    IKEvaluate_Other
};
@class IKViewController;

@protocol IKViewControllerDelegate

@optional
- (void)didSelectLeftItemAtIndex:(NSInteger)index;

@end

@interface IKViewController : UIViewController{
    BOOL shouldShowNavigationBar;
    IKVisitCDSO *visit;
}
@property (nonatomic,strong) IKVisitCDSO *visit;
@property (nonatomic) BOOL shouldShowNavigationBar;
@property (nonatomic,weak) id<IKViewControllerDelegate> delegate;

- (void)showInfo;

@end
