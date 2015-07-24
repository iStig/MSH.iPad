//
//  IKScanView.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-13.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKPopCenterView.h"
#import "RedLaserSDK.h"
#import <AudioToolbox/AudioToolbox.h>

@interface IKScanView : IKPopCenterView<BarcodePickerControllerDelegate,UITextFieldDelegate>{
    UITextField *tfNumber;
    UIView *bgscan;
    
    BarcodePickerController *barcodeReader;
    SystemSoundID beepSound;
}
- (NSString *)cardNo;
- (void)startScan;

@end
