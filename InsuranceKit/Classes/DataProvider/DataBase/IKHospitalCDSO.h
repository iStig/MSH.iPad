//
//  IKHospitalCDSO.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-4-9.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface IKHospitalCDSO : NSManagedObject

@property (nonatomic) NSString *providerID,*providerName;

+ (IKHospitalCDSO *)hospitalWithProviderID:(NSString *)pid;
+ (IKHospitalCDSO *)currentHospital;
+ (NSArray *)otherHospitals;

- (void)remove;

@end
