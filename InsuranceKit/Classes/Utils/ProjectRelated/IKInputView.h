//
//  IKInputView.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IKInputViewDelegate
@optional
- (void)selectionChanged:(id)sender;

@end

@interface IKInputView : UIView<UITextFieldDelegate>{
    UIView *line;
    UILabel *lblTitle;
    UITextField *tfInput;
    UIPopoverController *pcDate;

    int total;
    BOOL necessary;
    NSDate *datePlan;
}
@property (nonatomic,strong) NSString *key;
@property (nonatomic) BOOL necessary;
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,weak) id<IKInputViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title values:(NSArray *)values;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor*)color;
- (void)changeToDateSelector;

- (NSString *)text;
- (void)setText:(NSString *)text;

- (UILabel *)titleLabel;
- (UITextField *)inputField;
- (void)determineNecessary:(NSString *)category;
@property(nonatomic,assign) BOOL isFutureDate;

@end
