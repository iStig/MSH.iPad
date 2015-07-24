//
//  IKPopCenterView.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-13.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IKPopCenterView;

@protocol IKPopCenterViewDelegate

- (void)showNext:(IKPopCenterView *)v;
- (void)showPrev:(IKPopCenterView *)v;
- (BOOL)canShowNext:(IKPopCenterView *)v;
- (BOOL)canShowPrev:(IKPopCenterView *)v;
- (void)finished;

@optional
- (void)cardNoEntered:(NSString *)cardNo;
- (void)peopleSelected:(NSDictionary *)peopleInfo;
- (void)photoAdded:(NSArray *)photos;
- (void)signAdded:(UIImage *)sign;
- (void)secondPhotoAdded:(NSArray*)photos;

@end

@interface IKPopCenterView : UIView{
    UIButton *btnPrev,*btnNext;
}
@property (nonatomic,weak) id<IKPopCenterViewDelegate> delegate;

+ (id)view;
- (void)showPrevClicked;
- (void)showNextClicked;

@end
