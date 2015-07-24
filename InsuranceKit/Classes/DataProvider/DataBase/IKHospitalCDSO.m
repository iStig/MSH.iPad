//
//  IKHospitalCDSO.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-4-9.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKHospitalCDSO.h"
#import "IKPhotoCDSO.h"

@interface IKHospitalCDSO()

@property (nonatomic) NSSet *visits,*members;

@end

@implementation IKHospitalCDSO
@dynamic providerID,providerName;
@dynamic visits,members;

+ (IKHospitalCDSO *)hospitalWithProviderID:(NSString *)pid{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *photoEntity = [NSEntityDescription entityForName:@"Hospital" inManagedObjectContext:[IKDataProvider managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"providerID=%@",pid];
    //    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES];
    
    [fetchRequest setEntity:photoEntity];
    [fetchRequest setPredicate:predicate];
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchLimit:1];
    
    NSArray *ary = [[IKDataProvider managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if (0==ary.count){
        IKHospitalCDSO *hospital = [NSEntityDescription insertNewObjectForEntityForName:@"Hospital" inManagedObjectContext:[IKDataProvider managedObjectContext]];
        hospital.providerID = pid;
        [[IKDataProvider managedObjectContext] save:nil];
        
        return hospital;
    }else{
        return [ary objectAtIndex:0];
    }
}

+ (IKHospitalCDSO *)currentHospital{
    return [IKHospitalCDSO hospitalWithProviderID:[[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"]];
}

+ (NSArray *)otherHospitals{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *photoEntity = [NSEntityDescription entityForName:@"Hospital" inManagedObjectContext:[IKDataProvider managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self!=%@",[IKHospitalCDSO currentHospital]];
    //    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES];
    
    [fetchRequest setEntity:photoEntity];
    [fetchRequest setPredicate:predicate];
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
//    [fetchRequest setFetchLimit:1];
    
    NSArray *ary = [[IKDataProvider managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if (0==ary.count){
        return nil;
    }else{
        return ary;
    }
}

- (void)remove{
    for (IKVisitCDSO *vis in self.visits){
        BOOL shouldDeleteVisit = YES;
        
        for (IKPhotoCDSO *pho in vis.photos){
            if (pho.uploaded.boolValue){
                [[NSFileManager defaultManager] removeItemAtPath:[pho.seqID imageCachePath] error:nil];
                [[IKDataProvider managedObjectContext] deleteObject:pho];
            }else
                shouldDeleteVisit = NO;
        }
        
        if (!vis.uploadTime || vis.modifyTime>vis.uploadTime)
            shouldDeleteVisit = NO;
        
        vis.invisible = [NSNumber numberWithBool:YES];
        if (shouldDeleteVisit)
            [[IKDataProvider managedObjectContext] deleteObject:vis];
    }
    
    [[IKDataProvider managedObjectContext] save:nil];
}

@end
