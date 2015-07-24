//
//  IKView.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKVisitCDSO.h"

@interface IKView : UIView{
    IKVisitCDSO *visit;
}
@property (nonatomic,strong) IKVisitCDSO *visit;

- (void)showInfo;

@end
