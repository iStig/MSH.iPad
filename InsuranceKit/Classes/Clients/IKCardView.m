//
//  IKCardView.m
//  InsuranceKit
//
//  Created by iStig on 14-9-28.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKCardView.h"

@implementation IKCardView
@synthesize cardImageV;


- (id)initWithFrame:(CGRect)frame cardName:(NSString*)string{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        self.layer.cornerRadius = 5;
        
        cardImageV = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:cardImageV];
        
        
        cardType = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 20,frame.size.width , 20)];
        [cardType setFont:[UIFont systemFontOfSize:13]];
        cardType.backgroundColor = [UIColor colorWithRed:190.0/255.f green:90.0/255.f blue:92.0/255.f alpha:1];
        [cardType setTextColor:[UIColor whiteColor]];
        [cardType setText:[string length]?string:@""];
        cardType.textAlignment = NSTextAlignmentCenter;
        [self addSubview:cardType];
        
        
        
        
        
//        self.visit = v;
//        if (!self.visit){
//            self.visit = [NSEntityDescription insertNewObjectForEntityForName:@"Visit" inManagedObjectContext:[IKDataProvider managedObjectContext]];
//            self.visit.hospital = [IKDataProvider currentHospital];
//        }
//        
//        vContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 737, 475)];
//        vContent.clipsToBounds = YES;
//        vContent.center = CGPointMake(frame.size.width/2, frame.size.height/2);
//        [self addSubview:vContent];
//        
//        if (0==showType){
//            IKScanView *vScan = [IKScanView view];
//            vScan.delegate = self;
//            vScan.tag = dCurrentPage;
//            vScan.center = CGPointMake(frame.size.width/2, frame.size.height/2);
//            
//            vScan.frame = vContent.bounds;
//            [vContent addSubview:vScan];
//        }else if (1==showType){
//            
//        }else if (2==showType){
//            bCanGoBack = NO;
//            
//            IKSignNameView *vSign = [IKSignNameView view];
//            vSign.tag = 2;
//            vSign.delegate = self;
//            [vContent addSubview:vSign];
//        }
//        
//        
        
    }
    return self;
}



@end
