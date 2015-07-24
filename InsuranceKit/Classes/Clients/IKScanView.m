//
//  IKScanView.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-13.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKScanView.h"
#define Adjust_Height 80.0f
@interface IKBarCodePicker : BarcodePickerController2

@end

@implementation IKBarCodePicker

- (BOOL)shouldAutorotate{
    NSLog(@"Asked Auto Rotate");
    
    return YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)doneScanning{
    [super doneScanning];
    NSLog(@"Done Scanning");
}
@end


@implementation IKScanView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        UIImageView *cover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKCoverScan.png"]];
        
        bgscan = [[UIImageView alloc] initWithFrame:cover.bounds];
        bgscan.backgroundColor = [UIColor colorWithWhite:.27 alpha:1];
        bgscan.center = CGPointMake(frame.size.width/2, 160+Adjust_Height);
        [self addSubview:bgscan];
        
        barcodeReader = [[BarcodePickerController alloc] init];
        barcodeReader.delegate = self;
        barcodeReader.view.frame = bgscan.bounds;
        [bgscan addSubview:barcodeReader.view];
        [barcodeReader prepareToScan];
        
        [[NSNotificationCenter defaultCenter] removeObserver:barcodeReader];
//        vZbarReader = [ZBarReaderView new];
//        vZbarReader.frame = bgscan.bounds;
//        [bgscan addSubview:vZbarReader];
//        vZbarReader.readerDelegate = self;
//        [vZbarReader willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];

        
//        [vZbarReader.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
//        [vZbarReader.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:0];
        
//        [vZbarReader start];

        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, bgscan.frame.size.height/2+Adjust_Height, bgscan.frame.size.width, .5f)];
        line.backgroundColor = [UIColor greenColor];
        [barcodeReader.view addSubview:line];
        
        AudioSessionInitialize(NULL, NULL, NULL, NULL);
        AudioSessionSetActive(TRUE);
        
        
        
        // Load up the beep sound
        UInt32 flag = 0;
        float aBufferLength = 1.0; // In seconds
        NSURL *soundFileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                      pathForResource:@"beep" ofType:@"wav"] isDirectory:NO];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundFileURL, &beepSound);
        OSStatus error = AudioServicesSetProperty(kAudioServicesPropertyIsUISound,
                                                  sizeof(UInt32), &beepSound, sizeof(UInt32), &flag);
        error = AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration,
                                        sizeof(aBufferLength), &aBufferLength);
        
        
        [bgscan addSubview:cover];
        
        UIImageView *bginput = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKBGNumberInput.png"]];
        bginput.center = CGPointMake(frame.size.width/2, 340+Adjust_Height);
        [self addSubview:bginput];
        bginput.userInteractionEnabled = YES;
        
        tfNumber = [[UITextField alloc] initWithFrame:bginput.bounds];
        tfNumber.font = [UIFont boldSystemFontOfSize:19];
        tfNumber.placeholder = LocalizeStringFromKey(@"kInputCardNoOrMemberID");
        tfNumber.returnKeyType = UIReturnKeyDone;
        tfNumber.delegate = self;
        [bginput addSubview:tfNumber];
        tfNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tfNumber.layer.sublayerTransform = CATransform3DMakeTranslation(16, 0, 0);
                
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)orientationChanged:(NSNotification *)notice{
    int status = RL_CheckReadyStatus();
    if (status>0){
        [barcodeReader.view removeFromSuperview];
        barcodeReader = nil;
        
        barcodeReader = [[BarcodePickerController alloc] init];
        barcodeReader.delegate = self;
        barcodeReader.view.frame = bgscan.bounds;
        [bgscan insertSubview:barcodeReader.view atIndex:0];
        barcodeReader.view.frame = bgscan.bounds;
        [barcodeReader prepareToScan];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, bgscan.frame.size.height/2+Adjust_Height, bgscan.frame.size.width, .5f)];
        line.backgroundColor = [UIColor greenColor];
        [barcodeReader.view addSubview:line];
    }else{
        NSLog(@"证书检验失败，错误代码:%d",status);
//        [UIAlertView showAlertWithTitle:@"证书检验失败" message:[NSString stringWithFormat:@"错误代码:%d",status] cancelButton:nil];
    }
    
    
    
}

- (void)startScan{
    int status = RL_CheckReadyStatus();
    if (status>0){
        [barcodeReader.view removeFromSuperview];
        barcodeReader = nil;
        
        barcodeReader = [[BarcodePickerController alloc] init];
        barcodeReader.delegate = self;
        barcodeReader.view.frame = bgscan.bounds;
        [bgscan insertSubview:barcodeReader.view atIndex:0];
        barcodeReader.view.frame = bgscan.bounds;
        [barcodeReader prepareToScan];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, bgscan.frame.size.height/2+Adjust_Height, bgscan.frame.size.width, .5f)];
        line.backgroundColor = [UIColor greenColor];
        [barcodeReader.view addSubview:line];
    }else{
        NSLog(@"证书检验失败，错误代码:%d",status);
        //        [UIAlertView showAlertWithTitle:@"证书检验失败" message:[NSString stringWithFormat:@"错误代码:%d",status] cancelButton:nil];
    }
}


- (NSString *)cardNo{
    return tfNumber.text;
}

- (void)showNextClicked{
    if (tfNumber.text.length>0){
        [barcodeReader doneScanning];
        [self endEditing:YES];
        [self.delegate cardNoEntered:tfNumber.text];
    }else{
        [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kInputCardNoOrMemberID") cancelButton:nil];
    }
}



#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (tfNumber.text.length>0){
        [barcodeReader doneScanning];
        [self endEditing:YES];
        [self.delegate cardNoEntered:tfNumber.text];
    }
    
    return NO;
}

#pragma mark - BarCode Delegate
- (void)barcodePickerController:(BarcodePickerController2 *)picker returnResults:(NSSet *)results{
    for (BarcodeResult *result in results){
        NSString *str = result.barcodeString;
        NSLog(@"Bar Code Detected:%@",str);
        if (![tfNumber.text isEqualToString:str]){
            AudioServicesPlayAlertSound(beepSound);
            tfNumber.text = str;
            
            [barcodeReader doneScanning];
            
            [self showNextClicked];
            
            break;
        }
    }
}


@end
