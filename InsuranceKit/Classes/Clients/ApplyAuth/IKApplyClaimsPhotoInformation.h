//
//  KindInformation.h
//  SummerMatch
//
//  Created by mac on 13-6-17.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IKApplyClaimsPhotoInformation.h"


@interface IKApplyClaimsPhotoInformation : NSObject


@property (nonatomic, retain)NSMutableArray * photoCardArr;
@property (nonatomic, retain)NSMutableArray * photoPaymentArr;
@property (nonatomic, retain)NSMutableArray * photoOtherArr;
@property (nonatomic, retain)NSMutableArray * selectArray;
+(IKApplyClaimsPhotoInformation *)sharedApplyClaimsPhotoInformation;

@end
