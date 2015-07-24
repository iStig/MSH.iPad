//
//  IKClaimsStateSelector.h
//  InsuranceKit
//
//  Created by iStig on 14-10-9.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IKClaimsStatusSelectorDelegate

- (void)statusSelected:(int)status;
@end

@interface IKClaimsStateSelector : UIView{
    UIImageView *imgvContent;   
}
@property (nonatomic,weak) id<IKClaimsStatusSelectorDelegate> delegate;
+ (void)showAtPoint:(CGPoint)pt  states:(NSArray*)statesList  delegate:(id<IKClaimsStatusSelectorDelegate>)dele;
@end
