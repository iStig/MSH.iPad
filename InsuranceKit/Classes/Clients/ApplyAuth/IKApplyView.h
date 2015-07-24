//
//  IKApplyView.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKView.h"
#import "IKInputView.h"

#define kContentPadding 10.0f
#define kInputPadding   5.0f

#define kContentWidth   697.0f

@interface IKApplyView : IKView{
    NSArray *keys;
}
@property (nonatomic,strong) NSString *categoryID;

- (NSDictionary *)authInfo;
+ (id)applyView;
- (void)showInfo:(NSDictionary *)info;
@property(nonatomic,assign) BOOL isFutureDate;
- (void)updateNecessaryStatus;

@end
