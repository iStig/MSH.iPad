//
//  UIView+IK.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-9.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "UIView+IK.h"
#import "IKAppDelegate.h"
#import <objc/runtime.h>
#import "SWUIToolKit.h"

static __weak id currentFirstResponder;

@implementation UIView (IK)

+ (UIViewController *)rootViewController{
    IKAppDelegate *appdele = (IKAppDelegate *)[UIApplication sharedApplication].delegate;
    
    return appdele.window.rootViewController;
}

- (UIImagePickerController *)imagePicker{
    IKAppDelegate *appdele = (IKAppDelegate *)[UIApplication sharedApplication].delegate;
    
    return appdele.imagePicker;
}

@end



@implementation UIResponder (IK)



+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end

@implementation UIViewController (IK)

- (UIImagePickerController *)imagePicker{
    IKAppDelegate *appdele = (IKAppDelegate *)[UIApplication sharedApplication].delegate;
    
    return appdele.imagePicker;
}


@end


