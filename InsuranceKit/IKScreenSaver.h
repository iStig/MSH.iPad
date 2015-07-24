//
//  IKScreenSaver.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-22.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTCoverView.h"

@interface IKScreenSaver : UIApplication<BSTCoverViewDelegate>{
    NSTimer *idleTimer;
    BSTCoverView *vCover;
}

@end
