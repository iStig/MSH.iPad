//
//  UIView+IK.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-9.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IK)

+ (UIViewController *)rootViewController;
- (UIImagePickerController *)imagePicker;

@end

@interface  UIResponder(IK)

+ (id)currentFirstResponder;

@end

@interface UIViewController (IK)

- (UIImagePickerController *)imagePicker;

@end
